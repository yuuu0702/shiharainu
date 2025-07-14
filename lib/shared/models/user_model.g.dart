// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      position: json['position'] as String?,
      branch: json['branch'] as String?,
      accountNumber: json['accountNumber'] as String?,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      age: json['age'] as String?,
      gender: json['gender'] as String?,
      isDrinking: json['isDrinking'] as bool? ?? false,
      isGuest: json['isGuest'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      if (instance.position case final value?) 'position': value,
      if (instance.branch case final value?) 'branch': value,
      if (instance.accountNumber case final value?) 'accountNumber': value,
      'role': _$UserRoleEnumMap[instance.role]!,
      if (instance.age case final value?) 'age': value,
      if (instance.gender case final value?) 'gender': value,
      'isDrinking': instance.isDrinking,
      'isGuest': instance.isGuest,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updatedAt': value,
    };

const _$UserRoleEnumMap = {
  UserRole.organizer: 'organizer',
  UserRole.participant: 'participant',
  UserRole.guest: 'guest',
};
