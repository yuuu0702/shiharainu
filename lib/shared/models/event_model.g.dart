// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventModelImpl _$$EventModelImplFromJson(
  Map<String, dynamic> json,
) => _$EventModelImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  eventType: json['eventType'] == null
      ? EventType.other
      : const EventTypeConverter().fromJson(json['eventType'] as String),
  date: const TimestampConverter().fromJson(json['date'] as Object),
  organizerIds: (json['organizerIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
  status:
      $enumDecodeNullable(_$EventStatusEnumMap, json['status']) ??
      EventStatus.planning,
  paymentType:
      $enumDecodeNullable(_$PaymentTypeEnumMap, json['paymentType']) ??
      PaymentType.equal,
  createdAt: const TimestampConverter().fromJson(json['createdAt'] as Object),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt'] as Object),
  inviteCode: json['inviteCode'] as String?,
  parentEventId: json['parentEventId'] as String?,
  childEventIds:
      (json['childEventIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  isAfterParty: json['isAfterParty'] as bool? ?? false,
);

Map<String, dynamic> _$$EventModelImplToJson(_$EventModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'eventType': const EventTypeConverter().toJson(instance.eventType),
      'date': const TimestampConverter().toJson(instance.date),
      'organizerIds': instance.organizerIds,
      'totalAmount': instance.totalAmount,
      'status': _$EventStatusEnumMap[instance.status]!,
      'paymentType': _$PaymentTypeEnumMap[instance.paymentType]!,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'inviteCode': instance.inviteCode,
      'parentEventId': instance.parentEventId,
      'childEventIds': instance.childEventIds,
      'isAfterParty': instance.isAfterParty,
    };

const _$EventStatusEnumMap = {
  EventStatus.planning: 'planning',
  EventStatus.active: 'active',
  EventStatus.completed: 'completed',
};

const _$PaymentTypeEnumMap = {
  PaymentType.equal: 'equal',
  PaymentType.proportional: 'proportional',
};
