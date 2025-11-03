import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/models/participant_model.dart';
import 'package:shiharainu/shared/utils/app_logger.dart';

/// 支払いサービス
/// 支払い金額の計算とステータス管理を提供
class PaymentService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PaymentService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  /// 支払い金額を一括計算・更新
  Future<void> calculateAndUpdatePayments(String eventId) async {
    try {
      AppLogger.info('支払い金額計算開始: $eventId', name: 'PaymentService');

      final eventDoc = await _firestore.collection('events').doc(eventId).get();
      if (!eventDoc.exists) {
        throw Exception('イベントが見つかりません');
      }

      final eventData = eventDoc.data()!;
      eventData['id'] = eventDoc.id;
      final event = EventModel.fromJson(eventData);

      final participantsSnapshot = await _firestore
          .collection('events')
          .doc(eventId)
          .collection('participants')
          .get();

      final participants = participantsSnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ParticipantModel.fromJson(data);
      }).toList();

      if (participants.isEmpty) {
        throw Exception('参加者が見つかりません');
      }

      if (event.paymentType == PaymentType.equal) {
        await _calculateEqualSplit(eventId, event.totalAmount, participants);
      } else {
        await _calculateProportionalSplit(eventId, event.totalAmount, participants);
      }

      AppLogger.info('支払い金額計算完了: $eventId', name: 'PaymentService');
    } catch (e) {
      AppLogger.error('支払い金額計算エラー: $eventId', name: 'PaymentService', error: e);
      throw Exception('支払い金額の計算に失敗しました: $e');
    }
  }

  /// 均等割り計算
  Future<void> _calculateEqualSplit(
    String eventId,
    double totalAmount,
    List<ParticipantModel> participants,
  ) async {
    final amountPerPerson = totalAmount / participants.length;

    final batch = _firestore.batch();
    for (final participant in participants) {
      final ref = _firestore
          .collection('events')
          .doc(eventId)
          .collection('participants')
          .doc(participant.id);

      batch.update(ref, {
        'amountToPay': amountPerPerson,
        'multiplier': 1.0,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  /// 比例割り計算
  Future<void> _calculateProportionalSplit(
    String eventId,
    double totalAmount,
    List<ParticipantModel> participants,
  ) async {
    // 各参加者の係数を計算
    final multipliers = <String, double>{};
    double totalMultiplier = 0.0;

    for (final participant in participants) {
      final multiplier = participant.calculateMultiplier();
      multipliers[participant.id] = multiplier;
      totalMultiplier += multiplier;
    }

    // 各参加者の支払い金額を計算
    final batch = _firestore.batch();
    for (final participant in participants) {
      final multiplier = multipliers[participant.id]!;
      final amount = totalAmount * (multiplier / totalMultiplier);

      final ref = _firestore
          .collection('events')
          .doc(eventId)
          .collection('participants')
          .doc(participant.id);

      batch.update(ref, {
        'amountToPay': amount,
        'multiplier': multiplier,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  /// 支払いステータスを更新
  Future<void> updatePaymentStatus({
    required String eventId,
    required String participantId,
    required PaymentStatus status,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('ログインしていません');
      }

      AppLogger.info(
        '支払いステータス更新: $participantId -> $status',
        name: 'PaymentService',
      );

      final participantRef = _firestore
          .collection('events')
          .doc(eventId)
          .collection('participants')
          .doc(participantId);

      await participantRef.update({
        'paymentStatus': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      AppLogger.info('支払いステータス更新完了', name: 'PaymentService');
    } catch (e) {
      AppLogger.error('支払いステータス更新エラー', name: 'PaymentService', error: e);
      throw Exception('支払いステータスの更新に失敗しました: $e');
    }
  }
}

/// PaymentServiceプロバイダー
final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});
