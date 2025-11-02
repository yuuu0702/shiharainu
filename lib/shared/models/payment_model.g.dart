// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentModelImpl _$$PaymentModelImplFromJson(Map<String, dynamic> json) =>
    _$PaymentModelImpl(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      participantId: json['participantId'] as String,
      amount: (json['amount'] as num).toDouble(),
      paidAt: const TimestampConverter().fromJson(json['paidAt'] as Object),
      paymentMethod:
          $enumDecodeNullable(_$PaymentMethodEnumMap, json['paymentMethod']) ??
          PaymentMethod.cash,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$PaymentModelImplToJson(_$PaymentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'participantId': instance.participantId,
      'amount': instance.amount,
      'paidAt': const TimestampConverter().toJson(instance.paidAt),
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'note': instance.note,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.card: 'card',
  PaymentMethod.transfer: 'transfer',
  PaymentMethod.other: 'other',
};
