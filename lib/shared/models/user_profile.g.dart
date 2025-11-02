// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      position: json['position'] as String,
      email: json['email'] as String,
      gender: $enumDecodeNullable(_$ParticipantGenderEnumMap, json['gender']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'position': instance.position,
      'email': instance.email,
      'gender': _$ParticipantGenderEnumMap[instance.gender],
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ParticipantGenderEnumMap = {
  ParticipantGender.male: 'male',
  ParticipantGender.female: 'female',
  ParticipantGender.other: 'other',
};

_$CreateUserProfileRequestImpl _$$CreateUserProfileRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateUserProfileRequestImpl(
  name: json['name'] as String,
  age: (json['age'] as num).toInt(),
  position: json['position'] as String,
);

Map<String, dynamic> _$$CreateUserProfileRequestImplToJson(
  _$CreateUserProfileRequestImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'age': instance.age,
  'position': instance.position,
};
