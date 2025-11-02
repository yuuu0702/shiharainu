// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  id: json['id'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  message: json['message'] as String,
  type:
      $enumDecodeNullable(_$NotificationTypeEnumMap, json['type']) ??
      NotificationType.system,
  isRead: json['isRead'] as bool? ?? false,
  relatedEventId: json['relatedEventId'] as String?,
  createdAt: const TimestampConverter().fromJson(json['createdAt'] as Object),
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'title': instance.title,
  'message': instance.message,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'isRead': instance.isRead,
  'relatedEventId': instance.relatedEventId,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
};

const _$NotificationTypeEnumMap = {
  NotificationType.eventInvite: 'event_invite',
  NotificationType.paymentReminder: 'payment_reminder',
  NotificationType.eventUpdate: 'event_update',
  NotificationType.system: 'system',
};
