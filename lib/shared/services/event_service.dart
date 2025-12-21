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
  final EventType eventType;
  final DateTime date;
  final double totalAmount;
  final PaymentType paymentType;

  const CreateEventParams({
    required this.title,
    required this.description,
    required this.eventType,
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
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
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
        eventType: params.eventType,
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
          email: user.email ?? '',
          role: ParticipantRole.organizer,
          age: userProfile.age,
          gender: userProfile.gender ?? ParticipantGender.other,
          multiplier: 1.0,
          amountToPay: 0.0,
          paymentStatus: PaymentStatus.unpaid,
          joinedAt: now,
          updatedAt: now,
        );

        transaction.set(
          participantRef,
          ParticipantModel.toFirestore(participant),
        );
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

  /// イベントの特定フィールドを更新
  Future<void> updateEventFields({
    required String eventId,
    String? title,
    String? description,
    EventType? eventType,
    DateTime? date,
    double? totalAmount,
    PaymentType? paymentType,
    EventStatus? status,
    String? paymentUrl,
    String? paymentNote,
  }) async {
    try {
      AppLogger.info('イベントフィールド更新: $eventId', name: 'EventService');

      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (eventType != null) updates['eventType'] = eventType.name;
      if (date != null) updates['date'] = Timestamp.fromDate(date);
      if (totalAmount != null) updates['totalAmount'] = totalAmount;
      if (paymentType != null) updates['paymentType'] = paymentType.name;
      if (status != null) updates['status'] = status.name;
      if (paymentUrl != null) updates['paymentUrl'] = paymentUrl;
      if (paymentNote != null) updates['paymentNote'] = paymentNote;

      await _firestore.collection('events').doc(eventId).update(updates);

      AppLogger.info('イベントフィールド更新完了: $eventId', name: 'EventService');
    } catch (e) {
      AppLogger.error(
        'イベントフィールド更新エラー: $eventId',
        name: 'EventService',
        error: e,
      );
      throw Exception('イベント情報の更新に失敗しました: $e');
    }
  }

  /// イベントステータスを変更
  Future<void> updateEventStatus({
    required String eventId,
    required EventStatus status,
  }) async {
    try {
      AppLogger.info('イベントステータス変更: $eventId -> $status', name: 'EventService');

      await _firestore.collection('events').doc(eventId).update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.info('イベントステータス変更完了: $eventId', name: 'EventService');
    } catch (e) {
      AppLogger.error(
        'イベントステータス変更エラー: $eventId',
        name: 'EventService',
        error: e,
      );
      throw Exception('イベントステータスの変更に失敗しました: $e');
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
      final eventDoc = await _firestoreService.findEventByInviteCode(
        inviteCode,
      );
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

      final now = DateTime.now();
      final participant = ParticipantModel(
        id: participantRef.id,
        eventId: eventId,
        userId: user.uid,
        displayName: userProfile.name,
        email: user.email ?? '',
        role: ParticipantRole.participant,
        age: userProfile.age,
        gender: userProfile.gender ?? ParticipantGender.other,
        multiplier: 1.0,
        amountToPay: 0.0,
        paymentStatus: PaymentStatus.unpaid,
        joinedAt: now,
        updatedAt: now,
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

/// 特定イベントのStreamProviderファミリー（リアルタイム更新）
final eventStreamProvider = StreamProvider.family<EventModel, String>((
  ref,
  eventId,
) {
  final eventsCollection = ref.watch(eventsCollectionProvider);
  return eventsCollection.doc(eventId).snapshots().map((snapshot) {
    if (!snapshot.exists) {
      throw Exception('イベントが存在しません');
    }
    return snapshot.data()!;
  });
});

/// 特定イベントのFutureProviderファミリー（1回だけ取得）
final eventProvider = FutureProvider.family<EventModel, String>((
  ref,
  eventId,
) async {
  final eventsCollection = ref.watch(eventsCollectionProvider);
  final snapshot = await eventsCollection.doc(eventId).get();

  if (!snapshot.exists) {
    throw Exception('イベントが存在しません');
  }

  return snapshot.data()!;
});

/// イベント参加者一覧のStreamProviderファミリー（リアルタイム更新）
final eventParticipantsStreamProvider =
    StreamProvider.family<List<ParticipantModel>, String>((ref, eventId) {
      final participantsCollection = ref.watch(
        participantsCollectionProvider(eventId),
      );
      return participantsCollection.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      });
    });

/// イベント参加者一覧のFutureProviderファミリー（1回だけ取得）
final eventParticipantsProvider =
    FutureProvider.family<List<ParticipantModel>, String>((ref, eventId) async {
      final participantsCollection = ref.watch(
        participantsCollectionProvider(eventId),
      );
      final snapshot = await participantsCollection.get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    });

/// 現在のユーザーがイベントの主催者かどうかを判定するプロバイダー
final isEventOrganizerProvider = FutureProvider.family<bool, String>((
  ref,
  eventId,
) async {
  final event = await ref.watch(eventProvider(eventId).future);
  final auth = FirebaseAuth.instance;
  final currentUserId = auth.currentUser?.uid;

  if (currentUserId == null) {
    return false;
  }

  return event.organizerIds.contains(currentUserId);
});

/// 現在のユーザーの参加者情報を取得するプロバイダー
final currentUserParticipantProvider =
    FutureProvider.family<ParticipantModel?, String>((ref, eventId) async {
      final auth = FirebaseAuth.instance;
      final currentUserId = auth.currentUser?.uid;

      if (currentUserId == null) {
        return null;
      }

      final participantsCollection = ref.watch(
        participantsCollectionProvider(eventId),
      );
      final query = await participantsCollection
          .where('userId', isEqualTo: currentUserId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return null;
      }

      return query.docs.first.data();
    });

/// 現在のユーザーが参加している全イベントのStreamProvider（リアルタイム更新）
final userEventsStreamProvider = StreamProvider<List<EventModel>>((ref) {
  final auth = FirebaseAuth.instance;
  final currentUserId = auth.currentUser?.uid;

  if (currentUserId == null) {
    AppLogger.warning('ユーザーが未ログイン', name: 'userEventsStreamProvider');
    return Stream.value([]);
  }

  final firestore = FirebaseFirestore.instance;

  // コレクショングループクエリで現在のユーザーの参加記録を取得
  return firestore
      .collectionGroup('participants')
      .where('userId', isEqualTo: currentUserId)
      .snapshots()
      .asyncMap((participantsSnapshot) async {
        if (participantsSnapshot.docs.isEmpty) {
          return <EventModel>[];
        }

        // 参加しているイベントIDを取得（重複を除外）
        final eventIds = participantsSnapshot.docs
            .map((doc) => doc.data()['eventId'] as String)
            .toSet()
            .toList();

        AppLogger.debug(
          '参加イベント数: ${eventIds.length}',
          name: 'userEventsStreamProvider',
        );

        // 各イベントの情報を取得
        final eventsCollection = ref.read(eventsCollectionProvider);
        final events = <EventModel>[];

        for (final eventId in eventIds) {
          try {
            final eventDoc = await eventsCollection.doc(eventId).get();
            if (eventDoc.exists) {
              events.add(eventDoc.data()!);
            }
          } catch (e) {
            AppLogger.error(
              'イベント取得エラー: $eventId',
              name: 'userEventsStreamProvider',
              error: e,
            );
          }
        }

        // 日付順でソート（新しい順）
        events.sort((a, b) => b.date.compareTo(a.date));

        return events;
      });
});
