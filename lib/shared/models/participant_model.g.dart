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
  email: json['email'] as String,
  role:
      $enumDecodeNullable(
        _$ParticipantRoleEnumMap,
        json['role'],
        unknownValue: ParticipantRole.other,
      ) ??
      ParticipantRole.participant,
  age: (json['age'] as num?)?.toInt(),
  position: json['position'] as String?,
  gender:
      $enumDecodeNullable(_$ParticipantGenderEnumMap, json['gender']) ??
      ParticipantGender.other,
  isDrinker: json['isDrinker'] as bool? ?? true,
  multiplier: (json['multiplier'] as num?)?.toDouble() ?? 1.0,
  paymentMethod:
      $enumDecodeNullable(_$PaymentMethodEnumMap, json['paymentMethod']) ??
      PaymentMethod.calculated,
  manualAmount: (json['manualAmount'] as num?)?.toInt() ?? 0,
  customMultiplier: (json['customMultiplier'] as num?)?.toDouble(),
  amountToPay: (json['amountToPay'] as num?)?.toDouble() ?? 0.0,
  paymentStatus:
      $enumDecodeNullable(_$PaymentStatusEnumMap, json['paymentStatus']) ??
      PaymentStatus.unpaid,
  joinedAt: const TimestampConverter().fromJson(json['joinedAt'] as Object),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt'] as Object),
);

Map<String, dynamic> _$$ParticipantModelImplToJson(
  _$ParticipantModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'eventId': instance.eventId,
  'userId': instance.userId,
  'displayName': instance.displayName,
  'email': instance.email,
  'role': _$ParticipantRoleEnumMap[instance.role]!,
  'age': instance.age,
  'position': instance.position,
  'gender': _$ParticipantGenderEnumMap[instance.gender]!,
  'isDrinker': instance.isDrinker,
  'multiplier': instance.multiplier,
  'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
  'manualAmount': instance.manualAmount,
  'customMultiplier': instance.customMultiplier,
  'amountToPay': instance.amountToPay,
  'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
  'joinedAt': const TimestampConverter().toJson(instance.joinedAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};

const _$ParticipantRoleEnumMap = {
  ParticipantRole.organizer: 'organizer',
  ParticipantRole.participant: 'participant',
  ParticipantRole.other: 'other',
};

const _$ParticipantGenderEnumMap = {
  ParticipantGender.male: 'male',
  ParticipantGender.female: 'female',
  ParticipantGender.other: 'other',
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.calculated: 'calculated',
  PaymentMethod.fixed: 'fixed',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.paid: 'paid',
  PaymentStatus.pending: 'pending',
  PaymentStatus.unpaid: 'unpaid',
};
