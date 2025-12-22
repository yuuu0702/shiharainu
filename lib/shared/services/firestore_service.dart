import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/models/participant_model.dart';
import 'package:shiharainu/shared/models/payment_model.dart';
import 'package:shiharainu/shared/models/notification_model.dart';

/// Firestoreインスタンスプロバイダー
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

/// イベントコレクション参照プロバイダー
final eventsCollectionProvider = Provider<CollectionReference<EventModel>>((
  ref,
) {
  final firestore = ref.watch(firestoreProvider);
  return firestore
      .collection('events')
      .withConverter<EventModel>(
        fromFirestore: (snapshot, _) => EventModel.fromFirestore(snapshot),
        toFirestore: (event, _) => EventModel.toFirestore(event),
      );
});

/// 特定イベントのドキュメント参照プロバイダー（ファミリー）
final eventDocProvider = Provider.family<DocumentReference<EventModel>, String>(
  (ref, eventId) {
    final eventsCollection = ref.watch(eventsCollectionProvider);
    return eventsCollection.doc(eventId);
  },
);

/// 参加者サブコレクション参照プロバイダー（ファミリー）
final participantsCollectionProvider =
    Provider.family<CollectionReference<ParticipantModel>, String>((
      ref,
      eventId,
    ) {
      final firestore = ref.watch(firestoreProvider);
      return firestore
          .collection('events')
          .doc(eventId)
          .collection('participants')
          .withConverter<ParticipantModel>(
            fromFirestore: (snapshot, _) =>
                ParticipantModel.fromFirestore(snapshot),
            toFirestore: (participant, _) =>
                ParticipantModel.toFirestore(participant),
          );
    });

/// 支払いサブコレクション参照プロバイダー（ファミリー）
final paymentsCollectionProvider =
    Provider.family<CollectionReference<PaymentModel>, String>((ref, eventId) {
      final firestore = ref.watch(firestoreProvider);
      return firestore
          .collection('events')
          .doc(eventId)
          .collection('payments')
          .withConverter<PaymentModel>(
            fromFirestore: (snapshot, _) =>
                PaymentModel.fromFirestore(snapshot),
            toFirestore: (payment, _) => PaymentModel.toFirestore(payment),
          );
    });

/// 通知コレクション参照プロバイダー
final notificationsCollectionProvider =
    Provider<CollectionReference<NotificationModel>>((ref) {
      final firestore = ref.watch(firestoreProvider);
      return firestore
          .collection('notifications')
          .withConverter<NotificationModel>(
            fromFirestore: (snapshot, _) =>
                NotificationModel.fromFirestore(snapshot),
            toFirestore: (notification, _) =>
                NotificationModel.toFirestore(notification),
          );
    });

/// Firestoreサービスクラス
/// 共通的なFirestore操作を提供
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// トランザクション処理
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) transactionHandler,
  ) async {
    return await _firestore.runTransaction(transactionHandler);
  }

  /// バッチ処理
  WriteBatch batch() {
    return _firestore.batch();
  }

  /// 一意の招待コードを生成
  Future<String> generateUniqueInviteCode() async {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    var code = '';

    while (true) {
      // 8文字のランダムコード生成
      final random = Random.secure();
      code = List.generate(
        8,
        (_) => chars[random.nextInt(chars.length)],
      ).join();

      // 既存コードとの重複チェック
      final existingEvent = await _firestore
          .collection('events')
          .where('inviteCode', isEqualTo: code)
          .limit(1)
          .get();

      if (existingEvent.docs.isEmpty) {
        break; // 重複がなければループを抜ける
      }
    }

    return code;
  }

  /// 招待コードからイベントを検索
  Future<DocumentSnapshot<Map<String, dynamic>>?> findEventByInviteCode(
    String inviteCode,
  ) async {
    final query = await _firestore
        .collection('events')
        .where('inviteCode', isEqualTo: inviteCode)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      return null;
    }

    return query.docs.first;
  }
}

/// FirestoreServiceプロバイダー
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirestoreService(firestore: firestore);
});
