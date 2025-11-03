import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shiharainu/shared/models/event_model.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

/// 通知タイプ
enum NotificationType {
  @JsonValue('event_invite')
  eventInvite, // イベント招待
  @JsonValue('payment_reminder')
  paymentReminder, // 支払いリマインダー
  @JsonValue('event_update')
  eventUpdate, // イベント更新
  @JsonValue('system')
  system, // システム通知
}

/// 通知モデル
@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String userId,
    required String title,
    required String message,
    @Default(NotificationType.system) NotificationType type,
    @Default(false) bool isRead,
    String? relatedEventId, // 関連イベントID（オプション）
    String? eventTitle, // イベント名（オプション）
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() DateTime? readAt, // 既読日時（オプション）
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  /// Firestoreドキュメントから作成
  factory NotificationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data()!;
    data['id'] = snapshot.id;
    return NotificationModel.fromJson(data);
  }

  /// Firestore保存用のMapに変換（idを除外）
  static Map<String, dynamic> toFirestore(NotificationModel notification) {
    final json = notification.toJson();
    json.remove('id'); // Firestoreのドキュメント IDは別管理
    return json;
  }
}
