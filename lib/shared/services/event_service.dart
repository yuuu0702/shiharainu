import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/models/participant_model.dart';
import 'package:shiharainu/shared/services/firestore_service.dart';
import 'package:shiharainu/shared/services/user_service.dart';
import 'package:shiharainu/shared/utils/app_logger.dart';

/// イベント作成パラメータ
class CreateEventParams {
  final String title;
  final String description;
  final DateTime date;
  final double totalAmount;
  final PaymentType paymentType;

  const CreateEventParams({
    required this.title,
    required this.description,
    required this.date,
    required this.totalAmount,
    required this.paymentType,
  });
}

/// イベントサービス
/// イベントの作成、更新、削除などの操作を提供
class EventService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirestoreService _firestoreService;
  final UserService _userService;

  EventService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    required FirestoreService firestoreService,
    required UserService userService,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _firestoreService = firestoreService,
        _userService = userService;

  /// イベントを作成
  ///
  /// - 一意の招待コードを生成
  /// - イベントドキュメントを作成
  /// - 作成者を主催者として参加者サブコレクションに追加
  /// - 作成したイベントのIDを返す
  Future<String> createEvent(CreateEventParams params) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('ログインしていません');
      }

      AppLogger.info('イベント作成開始: ${params.title}', name: 'EventService');

      // ユーザー情報を取得
      final userProfile = await _userService.getUserProfile();
      if (userProfile == null) {
        throw Exception('ユーザー情報が見つかりません');
      }

      // 招待コードを生成
      final inviteCode = await _firestoreService.generateUniqueInviteCode();
      AppLogger.debug('招待コード生成: $inviteCode', name: 'EventService');

      final now = DateTime.now();

      // イベントドキュメントを作成
      final eventRef = _firestore.collection('events').doc();
      final event = EventModel(
        id: eventRef.id,
        title: params.title,
        description: params.description,
        date: params.date,
        organizerIds: [user.uid], // 作成者を主催者として設定
        totalAmount: params.totalAmount,
        status: EventStatus.planning,
        paymentType: params.paymentType,
        createdAt: now,
        updatedAt: now,
        inviteCode: inviteCode,
      );

      // トランザクションでイベントと主催者参加者を作成
      await _firestoreService.runTransaction((transaction) async {
        // イベントを作成
        transaction.set(eventRef, EventModel.toFirestore(event));

        // 主催者を参加者として追加
        final participantRef = eventRef.collection('participants').doc();
        final participant = ParticipantModel(
          id: participantRef.id,
          eventId: eventRef.id,
          userId: user.uid,
          displayName: userProfile.name,
          role: ParticipantRole.organizer,
          age: userProfile.age,
          gender: userProfile.gender ?? ParticipantGender.other,
          multiplier: 1.0,
          amountToPay: 0.0,
          paymentStatus: PaymentStatus.unpaid,
          joinedAt: now,
        );

        transaction.set(participantRef, ParticipantModel.toFirestore(participant));
      });

      AppLogger.info('イベント作成完了: ${eventRef.id}', name: 'EventService');
      return eventRef.id;
    } catch (e) {
      AppLogger.error('イベント作成エラー', name: 'EventService', error: e);
      throw Exception('イベントの作成に失敗しました: $e');
    }
  }

  /// イベントを更新
  Future<void> updateEvent(String eventId, EventModel event) async {
    try {
      AppLogger.info('イベント更新: $eventId', name: 'EventService');

      final eventRef = _firestore.collection('events').doc(eventId);

      // 更新日時を更新
      final updatedEvent = event.copyWith(updatedAt: DateTime.now());

      await eventRef.update(EventModel.toFirestore(updatedEvent));

      AppLogger.info('イベント更新完了: $eventId', name: 'EventService');
    } catch (e) {
      AppLogger.error('イベント更新エラー: $eventId', name: 'EventService', error: e);
      throw Exception('イベントの更新に失敗しました: $e');
    }
  }

  /// イベントを削除
  Future<void> deleteEvent(String eventId) async {
    try {
      AppLogger.info('イベント削除: $eventId', name: 'EventService');

      final eventRef = _firestore.collection('events').doc(eventId);

      // サブコレクションも削除（バッチ処理）
      final batch = _firestoreService.batch();

      // 参加者を削除
      final participants = await eventRef.collection('participants').get();
      for (final doc in participants.docs) {
        batch.delete(doc.reference);
      }

      // 支払い記録を削除
      final payments = await eventRef.collection('payments').get();
      for (final doc in payments.docs) {
        batch.delete(doc.reference);
      }

      // イベント自体を削除
      batch.delete(eventRef);

      await batch.commit();

      AppLogger.info('イベント削除完了: $eventId', name: 'EventService');
    } catch (e) {
      AppLogger.error('イベント削除エラー: $eventId', name: 'EventService', error: e);
      throw Exception('イベントの削除に失敗しました: $e');
    }
  }

  /// 招待コードからイベントに参加
  Future<String> joinEventByInviteCode(String inviteCode) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('ログインしていません');
      }

      AppLogger.info('招待コード経由でイベント参加: $inviteCode', name: 'EventService');

      // イベントを検索
      final eventDoc = await _firestoreService.findEventByInviteCode(inviteCode);
      if (eventDoc == null) {
        throw Exception('招待コードが無効です');
      }

      final eventId = eventDoc.id;

      // 既に参加しているかチェック
      final existingParticipant = await _firestore
          .collection('events')
          .doc(eventId)
          .collection('participants')
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (existingParticipant.docs.isNotEmpty) {
        throw Exception('既にこのイベントに参加しています');
      }

      // ユーザー情報を取得
      final userProfile = await _userService.getUserProfile();
      if (userProfile == null) {
        throw Exception('ユーザー情報が見つかりません');
      }

      // 参加者として追加
      final participantRef = _firestore
          .collection('events')
          .doc(eventId)
          .collection('participants')
          .doc();

      final participant = ParticipantModel(
        id: participantRef.id,
        eventId: eventId,
        userId: user.uid,
        displayName: userProfile.name,
        role: ParticipantRole.participant,
        age: userProfile.age,
        gender: userProfile.gender ?? ParticipantGender.other,
        multiplier: 1.0,
        amountToPay: 0.0,
        paymentStatus: PaymentStatus.unpaid,
        joinedAt: DateTime.now(),
      );

      await participantRef.set(ParticipantModel.toFirestore(participant));

      AppLogger.info('イベント参加完了: $eventId', name: 'EventService');
      return eventId;
    } catch (e) {
      AppLogger.error('イベント参加エラー', name: 'EventService', error: e);
      throw Exception('イベントへの参加に失敗しました: $e');
    }
  }
}

/// EventServiceプロバイダー
final eventServiceProvider = Provider<EventService>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final userService = ref.watch(userServiceProvider);

  return EventService(
    firestoreService: firestoreService,
    userService: userService,
  );
});
