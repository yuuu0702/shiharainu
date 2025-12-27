 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/models/event_model.dart';
import 'package:shiharainu/shared/models/participant_model.dart';
import 'package:shiharainu/shared/utils/app_logger.dart';
import 'package:shiharainu/shared/exceptions/app_exception.dart';

/// 支払いサービス
/// 支払い金額の計算とステータス管理を提供
class PaymentService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  PaymentService({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  /// 支払い金額を一括計算・更新
  Future<void> calculateAndUpdatePayments(String eventId) async {
    try {
      AppLogger.info('支払い金額計算開始: $eventId', name: 'PaymentService');

      final eventDoc = await _firestore.collection('events').doc(eventId).get();
      if (!eventDoc.exists) {
        throw const AppValidationException('イベントが見つかりません');
      }

      final eventData = eventDoc.data()!;
      eventData['id'] = eventDoc.id;

      late final EventModel event;
      try {
        event = EventModel.fromJson(eventData);
      } catch (e) {
        AppLogger.error(
          'イベントデータの変換エラー: $eventId',
          name: 'PaymentService',
          error: e,
        );
        throw const AppValidationException('イベント情報の形式が不正です');
      }

      final participantsSnapshot = await _firestore
          .collection('events')
          .doc(eventId)
          .collection('participants')
          .get();

      // 不正な参加者データがあっても全体を止めないように変更
      final participants = <ParticipantModel>[];
      for (final doc in participantsSnapshot.docs) {
        try {
          final data = doc.data();
          data['id'] = doc.id;
          participants.add(ParticipantModel.fromJson(data));
        } catch (e) {
          AppLogger.warning(
            '参加者データの変換スキップ: ${doc.id}',
            name: 'PaymentService',
            error: e,
          );
          // スキップするが、ログに残す
        }
      }

      if (participants.isEmpty) {
        // 誰もいない場合は計算不要（エラーにはしない）
        AppLogger.info('計算対象の参加者がいません: $eventId', name: 'PaymentService');
        return;
      }

      AppLogger.info(
        '支払い計算実行: $eventId, 参加者数: ${participants.length}, 合計金額: ${event.totalAmount}',
        name: 'PaymentService',
      );

      // Hybrid Calculation Model (全てのパターンを統合)
      await _calculateHybridSplit(
        eventId: eventId,
        totalAmount: event.totalAmount,
        participants: participants,
        paymentType: event.paymentType,
      );

      AppLogger.info('支払い金額計算完了: $eventId', name: 'PaymentService');
    } catch (e) {
      AppLogger.error('支払い金額計算エラー: $eventId', name: 'PaymentService', error: e);
      // 再スローして呼び出し元（EventService）でもログが出るようにする
      if (e is AppException) rethrow;
      throw AppUnknownException('支払い金額の計算に失敗しました', e);
    }
  }

  /// ハイブリッド割り勘計算 (Hybrid Calculation Model)
  ///
  /// 固定額(Fixed)の設定がある場合はそれを優先し、
  /// 残りの金額を変動(Calculated)メンバーで、係数に基づいて分配します。
  /// [paymentType] が [PaymentType.equal] の場合、係数の自動計算は 1.0 固定となります。
  Future<void> _calculateHybridSplit({
    required String eventId,
    required double totalAmount,
    required List<ParticipantModel> participants,
    required PaymentType paymentType,
  }) async {
    // 1. 固定(Fixed)と変動(Calculated)に分離
    double fixedTotalAmount = 0;
    final fixedParticipants = <ParticipantModel>[];
    final calculatedParticipants = <ParticipantModel>[];

    for (final participant in participants) {
      if (participant.paymentMethod == PaymentMethod.fixed) {
        fixedTotalAmount += participant.manualAmount;
        fixedParticipants.add(participant);
      } else {
        calculatedParticipants.add(participant);
      }
    }

    // 2. 変動グループで割るべき残りの金額を算出
    double remainingAmount = totalAmount - fixedTotalAmount;
    if (remainingAmount < 0) {
      // 固定額の合計が全体を超えている場合、残りは0とする
      remainingAmount = 0;
    }

    // 3. 係数(Multiplier)の算出 (変動グループのみ)
    final effectiveMultipliers = <String, double>{};
    double totalWeight = 0;

    for (final participant in calculatedParticipants) {
      double multiplier;

      if (participant.customMultiplier != null) {
        // A. 手動係数が設定されている場合
        multiplier = participant.customMultiplier!;
      } else {
        // B. 自動計算 (PaymentTypeに基づく)
        if (paymentType == PaymentType.equal) {
          multiplier = 1.0;
        } else {
          // Proportional (Smart)
          multiplier = participant.calculateMultiplier();
        }
      }

      effectiveMultipliers[participant.id] = multiplier;
      totalWeight += multiplier;
    }

    AppLogger.info(
      'Hybrid計算: 合計=$totalAmount, 固定計=$fixedTotalAmount, 残金=$remainingAmount, 重み計=$totalWeight',
      name: 'PaymentService',
    );

    // 4. 更新データをバッチ作成
    final batch = _firestore.batch();
    final participantsCollection = _firestore
        .collection('events')
        .doc(eventId)
        .collection('participants');

    // A. 固定グループの更新
    for (final participant in fixedParticipants) {
      batch.update(participantsCollection.doc(participant.id), {
        'amountToPay': participant.manualAmount.toDouble(),
        'multiplier': 0.0, // 固定のため係数は0扱い
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    // B. 変動グループの更新
    for (final participant in calculatedParticipants) {
      final weight = effectiveMultipliers[participant.id]!;
      double amount = 0.0;

      if (totalWeight > 0) {
        amount = (weight / totalWeight) * remainingAmount;
      }

      // 端数処理 (floor)
      amount = amount.floorToDouble();

      batch.update(participantsCollection.doc(participant.id), {
        'amountToPay': amount,
        'multiplier': weight, // 計算に使用した係数を保存
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
        throw const AppAuthException('ログインしていません', code: 'not_logged_in');
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
      if (e is AppException) rethrow;
      throw AppUnknownException('支払いステータスの更新に失敗しました', e);
    }
  }
}

/// PaymentServiceプロバイダー
final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});
