import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shiharainu/shared/models/participant_model.dart';
import 'package:shiharainu/shared/utils/app_logger.dart';
import 'package:shiharainu/shared/exceptions/app_exception.dart';

import 'package:shiharainu/shared/services/payment_service.dart';

/// 参加者サービス
/// 参加者の追加、編集、削除、役割変更などの操作を提供
class ParticipantService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final PaymentService _paymentService;

  ParticipantService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    required PaymentService paymentService,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _paymentService = paymentService;

  /// 参加者情報を更新
  Future<void> updateParticipant({
    required String eventId,
    required String participantId,
    String? displayName,
    int? age,
    String? position,
    ParticipantGender? gender,
    bool? isDrinker,
    // Hybrid Payment Fields
    PaymentMethod? paymentMethod,
    int? manualAmount,
    double? customMultiplier,
  }) async {
    try {
      AppLogger.info('参加者情報更新: $participantId', name: 'ParticipantService');

      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (displayName != null) updates['displayName'] = displayName;
      if (age != null) updates['age'] = age;
      if (position != null) updates['position'] = position;
      if (gender != null) updates['gender'] = gender.name;
      if (isDrinker != null) updates['isDrinker'] = isDrinker;

      // Hybrid Payment Fields
      if (paymentMethod != null)
        updates['paymentMethod'] = paymentMethod.name; // Enum name
      if (manualAmount != null) updates['manualAmount'] = manualAmount;
      // customMultiplier can be set to null, so we need a way to clear it?
      // For now, if passed, update it. If we want to clear, maybe pass a specific value or separate method.
      // Assuming UI passes null only when not updating, but we might want to unset it.
      // Let's assume if it is explicitly passed as null, we ignore?
      // Standard pattern: pass value to set.
      // How to unset? Maybe add a separate `clearCustomMultiplier` flag?
      // Or if customMultiplier is passed, set it.
      if (customMultiplier != null) {
        updates['customMultiplier'] = customMultiplier;
      }
      // NOTE: Firestore update simply merges. To delete a field use FieldValue.delete().
      // If we want to allow unsetting customMultiplier, we might need logic.
      // For now, let's assume valid values only.

      await _firestore
          .collection('events')
          .doc(eventId)
          .collection('participants')
          .doc(participantId)
          .update(updates);

      // 変更があった場合、支払いを再計算
      // ※表示名だけの変更なら不要だが、区別が面倒なので一律再計算する安易な実装とする
      await _paymentService.calculateAndUpdatePayments(eventId);

      AppLogger.info('参加者情報更新完了: $participantId', name: 'ParticipantService');
    } catch (e) {
      AppLogger.error(
        '参加者情報更新エラー: $participantId',
        name: 'ParticipantService',
        error: e,
      );
      if (e is AppException) rethrow;
      throw AppUnknownException('参加者情報の更新に失敗しました', e);
    }
  }

  /// 参加者の役割を変更（主催者⇔参加者）
  Future<void> updateParticipantRole({
    required String eventId,
    required String participantId,
    required ParticipantRole newRole,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const AppAuthException('ログインしていません', code: 'not_logged_in');
      }

      AppLogger.info(
        '参加者役割変更: $participantId -> $newRole',
        name: 'ParticipantService',
      );

      // イベントドキュメントと参加者ドキュメントを同時に更新
      final eventRef = _firestore.collection('events').doc(eventId);
      final participantRef = eventRef
          .collection('participants')
          .doc(participantId);

      await _firestore.runTransaction((transaction) async {
        final participantDoc = await transaction.get(participantRef);
        if (!participantDoc.exists) {
          throw const AppValidationException('参加者が見つかりません');
        }

        final participant = ParticipantModel.fromJson({
          ...participantDoc.data()!,
          'id': participantDoc.id,
        });

        // 参加者の役割を更新
        transaction.update(participantRef, {
          'role': newRole.name,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // イベントのorganizerIdsを更新
        final eventDoc = await transaction.get(eventRef);
        if (!eventDoc.exists) {
          throw const AppValidationException('イベントが見つかりません');
        }

        final currentOrganizerIds = List<String>.from(
          eventDoc.data()?['organizerIds'] ?? [],
        );

        if (newRole == ParticipantRole.organizer) {
          // 主催者に追加
          if (!currentOrganizerIds.contains(participant.userId)) {
            currentOrganizerIds.add(participant.userId);
            transaction.update(eventRef, {
              'organizerIds': currentOrganizerIds,
              'updatedAt': FieldValue.serverTimestamp(),
            });
          }
        } else {
          // 主催者から削除
          if (currentOrganizerIds.contains(participant.userId)) {
            // 最後の主催者は削除できない
            if (currentOrganizerIds.length <= 1) {
              throw const AppValidationException('最後の主催者を削除することはできません');
            }
            currentOrganizerIds.remove(participant.userId);
            transaction.update(eventRef, {
              'organizerIds': currentOrganizerIds,
              'updatedAt': FieldValue.serverTimestamp(),
            });
          }
        }
      });

      AppLogger.info('参加者役割変更完了: $participantId', name: 'ParticipantService');
    } catch (e) {
      AppLogger.error(
        '参加者役割変更エラー: $participantId',
        name: 'ParticipantService',
        error: e,
      );
      if (e is AppException) rethrow;
      throw AppUnknownException('参加者の役割変更に失敗しました', e);
    }
  }

  /// 参加者を削除
  Future<void> removeParticipant({
    required String eventId,
    required String participantId,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const AppAuthException('ログインしていません', code: 'not_logged_in');
      }

      AppLogger.info('参加者削除: $participantId', name: 'ParticipantService');

      final eventRef = _firestore.collection('events').doc(eventId);
      final participantRef = eventRef
          .collection('participants')
          .doc(participantId);

      await _firestore.runTransaction((transaction) async {
        final participantDoc = await transaction.get(participantRef);
        if (!participantDoc.exists) {
          throw const AppValidationException('参加者が見つかりません');
        }

        final participant = ParticipantModel.fromJson({
          ...participantDoc.data()!,
          'id': participantDoc.id,
        });

        // 主催者の場合、最後の主催者でないことを確認
        if (participant.role == ParticipantRole.organizer) {
          final eventDoc = await transaction.get(eventRef);
          if (eventDoc.exists) {
            final organizerIds = List<String>.from(
              eventDoc.data()?['organizerIds'] ?? [],
            );
            if (organizerIds.length <= 1) {
              throw const AppValidationException('最後の主催者を削除することはできません');
            }

            // 主催者リストから削除
            organizerIds.remove(participant.userId);
            transaction.update(eventRef, {
              'organizerIds': organizerIds,
              'updatedAt': FieldValue.serverTimestamp(),
            });
          }
        }

        // 参加者を削除
        transaction.delete(participantRef);
      });

      AppLogger.info('参加者削除完了: $participantId', name: 'ParticipantService');
    } catch (e) {
      AppLogger.error(
        '参加者削除エラー: $participantId',
        name: 'ParticipantService',
        error: e,
      );
      if (e is AppException) rethrow;
      throw AppUnknownException('参加者の削除に失敗しました', e);
    }
  }
}

/// ParticipantServiceプロバイダー
/// ParticipantServiceプロバイダー
final participantServiceProvider = Provider<ParticipantService>((ref) {
  final paymentService = ref.watch(paymentServiceProvider);
  return ParticipantService(paymentService: paymentService);
});
