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
  eventTitle: json['eventTitle'] as String?,
  createdAt: const TimestampConverter().fromJson(json['createdAt'] as Object),
  readAt: _$JsonConverterFromJson<Object, DateTime>(
    json['readAt'],
    const TimestampConverter().fromJson,
  ),
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
  'eventTitle': instance.eventTitle,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'readAt': _$JsonConverterToJson<Object, DateTime>(
    instance.readAt,
    const TimestampConverter().toJson,
  ),
};

const _$NotificationTypeEnumMap = {
  NotificationType.eventInvite: 'event_invite',
  NotificationType.paymentReminder: 'payment_reminder',
  NotificationType.eventUpdate: 'event_update',
  NotificationType.system: 'system',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
