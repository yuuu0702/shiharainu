// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentModelImpl _$$PaymentModelImplFromJson(
  Map<String, dynamic> json,
) => _$PaymentModelImpl(
  id: json['id'] as String,
  eventId: json['eventId'] as String,
  participantId: json['participantId'] as String,
  userId: json['userId'] as String,
  amount: (json['amount'] as num).toDouble(),
  status:
      $enumDecodeNullable(_$PaymentRecordStatusEnumMap, json['status']) ??
      PaymentRecordStatus.pending,
  paidAt: _$JsonConverterFromJson<Object, DateTime>(
    json['paidAt'],
    const TimestampConverter().fromJson,
  ),
  paymentMethod:
      $enumDecodeNullable(_$PaymentMethodEnumMap, json['paymentMethod']) ??
      PaymentMethod.cash,
  confirmedBy: json['confirmedBy'] as String?,
  note: json['note'] as String?,
  createdAt: const TimestampConverter().fromJson(json['createdAt'] as Object),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt'] as Object),
);

Map<String, dynamic> _$$PaymentModelImplToJson(_$PaymentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'participantId': instance.participantId,
      'userId': instance.userId,
      'amount': instance.amount,
      'status': _$PaymentRecordStatusEnumMap[instance.status]!,
      'paidAt': _$JsonConverterToJson<Object, DateTime>(
        instance.paidAt,
        const TimestampConverter().toJson,
      ),
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'confirmedBy': instance.confirmedBy,
      'note': instance.note,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

const _$PaymentRecordStatusEnumMap = {
  PaymentRecordStatus.pending: 'pending',
  PaymentRecordStatus.completed: 'completed',
  PaymentRecordStatus.cancelled: 'cancelled',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.card: 'card',
  PaymentMethod.transfer: 'transfer',
  PaymentMethod.other: 'other',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
