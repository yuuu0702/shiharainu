// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParticipantModelImpl _$$ParticipantModelImplFromJson(
  Map<String, dynamic> json,
) => _$ParticipantModelImpl(
  id: json['id'] as String,
  eventId: json['eventId'] as String,
  userId: json['userId'] as String,
  displayName: json['displayName'] as String,
  role:
      $enumDecodeNullable(_$ParticipantRoleEnumMap, json['role']) ??
      ParticipantRole.participant,
  age: (json['age'] as num?)?.toInt(),
  gender:
      $enumDecodeNullable(_$ParticipantGenderEnumMap, json['gender']) ??
      ParticipantGender.other,
  multiplier: (json['multiplier'] as num?)?.toDouble() ?? 1.0,
  amountToPay: (json['amountToPay'] as num?)?.toDouble() ?? 0.0,
  paymentStatus:
      $enumDecodeNullable(_$PaymentStatusEnumMap, json['paymentStatus']) ??
      PaymentStatus.unpaid,
  joinedAt: const TimestampConverter().fromJson(json['joinedAt'] as Object),
);

Map<String, dynamic> _$$ParticipantModelImplToJson(
  _$ParticipantModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'eventId': instance.eventId,
  'userId': instance.userId,
  'displayName': instance.displayName,
  'role': _$ParticipantRoleEnumMap[instance.role]!,
  'age': instance.age,
  'gender': _$ParticipantGenderEnumMap[instance.gender]!,
  'multiplier': instance.multiplier,
  'amountToPay': instance.amountToPay,
  'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
  'joinedAt': const TimestampConverter().toJson(instance.joinedAt),
};

const _$ParticipantRoleEnumMap = {
  ParticipantRole.organizer: 'organizer',
  ParticipantRole.participant: 'participant',
};

const _$ParticipantGenderEnumMap = {
  ParticipantGender.male: 'male',
  ParticipantGender.female: 'female',
  ParticipantGender.other: 'other',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.paid: 'paid',
  PaymentStatus.pending: 'pending',
  PaymentStatus.unpaid: 'unpaid',
};
