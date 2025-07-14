// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventModelImpl _$$EventModelImplFromJson(Map<String, dynamic> json) =>
    _$EventModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      organizerId: json['organizerId'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      eventDate: DateTime.parse(json['eventDate'] as String),
      paymentDeadline: DateTime.parse(json['paymentDeadline'] as String),
      venue: json['venue'] as String,
      proportionalPattern: ProportionalPattern.fromJson(
          json['proportionalPattern'] as Map<String, dynamic>),
      participantIds: (json['participantIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      status: $enumDecodeNullable(_$EventStatusEnumMap, json['status']) ??
          EventStatus.active,
      qrCode: json['qrCode'] as String?,
      shareUrl: json['shareUrl'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$EventModelImplToJson(_$EventModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'organizerId': instance.organizerId,
      'totalAmount': instance.totalAmount,
      'eventDate': instance.eventDate.toIso8601String(),
      'paymentDeadline': instance.paymentDeadline.toIso8601String(),
      'venue': instance.venue,
      'proportionalPattern': instance.proportionalPattern.toJson(),
      'participantIds': instance.participantIds,
      'status': _$EventStatusEnumMap[instance.status]!,
      if (instance.qrCode case final value?) 'qrCode': value,
      if (instance.shareUrl case final value?) 'shareUrl': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updatedAt': value,
    };

const _$EventStatusEnumMap = {
  EventStatus.active: 'active',
  EventStatus.completed: 'completed',
  EventStatus.cancelled: 'cancelled',
};

_$ProportionalPatternImpl _$$ProportionalPatternImplFromJson(
        Map<String, dynamic> json) =>
    _$ProportionalPatternImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      roleMultipliers: (json['roleMultipliers'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      ageMultipliers: (json['ageMultipliers'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      genderMultipliers:
          (json['genderMultipliers'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      drinkingMultiplier: (json['drinkingMultiplier'] as num).toDouble(),
      nonDrinkingMultiplier: (json['nonDrinkingMultiplier'] as num).toDouble(),
      isCustom: json['isCustom'] as bool? ?? false,
    );

Map<String, dynamic> _$$ProportionalPatternImplToJson(
        _$ProportionalPatternImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'roleMultipliers': instance.roleMultipliers,
      'ageMultipliers': instance.ageMultipliers,
      'genderMultipliers': instance.genderMultipliers,
      'drinkingMultiplier': instance.drinkingMultiplier,
      'nonDrinkingMultiplier': instance.nonDrinkingMultiplier,
      'isCustom': instance.isCustom,
    };
