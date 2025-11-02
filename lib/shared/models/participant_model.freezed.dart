// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'participant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ParticipantModel _$ParticipantModelFromJson(Map<String, dynamic> json) {
  return _ParticipantModel.fromJson(json);
}

/// @nodoc
mixin _$ParticipantModel {
  String get id => throw _privateConstructorUsedError;
  String get eventId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  ParticipantRole get role => throw _privateConstructorUsedError;
  int? get age => throw _privateConstructorUsedError; // 年齢（オプション）
  ParticipantGender get gender => throw _privateConstructorUsedError;
  double get multiplier =>
      throw _privateConstructorUsedError; // 支払い比率の重み付け（デフォルト1.0）
  double get amountToPay => throw _privateConstructorUsedError; // 支払い額
  PaymentStatus get paymentStatus =>
      throw _privateConstructorUsedError; // 支払いステータス
  @TimestampConverter()
  DateTime get joinedAt => throw _privateConstructorUsedError;

  /// Serializes this ParticipantModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParticipantModelCopyWith<ParticipantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticipantModelCopyWith<$Res> {
  factory $ParticipantModelCopyWith(
    ParticipantModel value,
    $Res Function(ParticipantModel) then,
  ) = _$ParticipantModelCopyWithImpl<$Res, ParticipantModel>;
  @useResult
  $Res call({
    String id,
    String eventId,
    String userId,
    String displayName,
    ParticipantRole role,
    int? age,
    ParticipantGender gender,
    double multiplier,
    double amountToPay,
    PaymentStatus paymentStatus,
    @TimestampConverter() DateTime joinedAt,
  });
}

/// @nodoc
class _$ParticipantModelCopyWithImpl<$Res, $Val extends ParticipantModel>
    implements $ParticipantModelCopyWith<$Res> {
  _$ParticipantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? displayName = null,
    Object? role = null,
    Object? age = freezed,
    Object? gender = null,
    Object? multiplier = null,
    Object? amountToPay = null,
    Object? paymentStatus = null,
    Object? joinedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            eventId: null == eventId
                ? _value.eventId
                : eventId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            displayName: null == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as ParticipantRole,
            age: freezed == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                      as int?,
            gender: null == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as ParticipantGender,
            multiplier: null == multiplier
                ? _value.multiplier
                : multiplier // ignore: cast_nullable_to_non_nullable
                      as double,
            amountToPay: null == amountToPay
                ? _value.amountToPay
                : amountToPay // ignore: cast_nullable_to_non_nullable
                      as double,
            paymentStatus: null == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as PaymentStatus,
            joinedAt: null == joinedAt
                ? _value.joinedAt
                : joinedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ParticipantModelImplCopyWith<$Res>
    implements $ParticipantModelCopyWith<$Res> {
  factory _$$ParticipantModelImplCopyWith(
    _$ParticipantModelImpl value,
    $Res Function(_$ParticipantModelImpl) then,
  ) = __$$ParticipantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String eventId,
    String userId,
    String displayName,
    ParticipantRole role,
    int? age,
    ParticipantGender gender,
    double multiplier,
    double amountToPay,
    PaymentStatus paymentStatus,
    @TimestampConverter() DateTime joinedAt,
  });
}

/// @nodoc
class __$$ParticipantModelImplCopyWithImpl<$Res>
    extends _$ParticipantModelCopyWithImpl<$Res, _$ParticipantModelImpl>
    implements _$$ParticipantModelImplCopyWith<$Res> {
  __$$ParticipantModelImplCopyWithImpl(
    _$ParticipantModelImpl _value,
    $Res Function(_$ParticipantModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? userId = null,
    Object? displayName = null,
    Object? role = null,
    Object? age = freezed,
    Object? gender = null,
    Object? multiplier = null,
    Object? amountToPay = null,
    Object? paymentStatus = null,
    Object? joinedAt = null,
  }) {
    return _then(
      _$ParticipantModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        eventId: null == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as ParticipantRole,
        age: freezed == age
            ? _value.age
            : age // ignore: cast_nullable_to_non_nullable
                  as int?,
        gender: null == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as ParticipantGender,
        multiplier: null == multiplier
            ? _value.multiplier
            : multiplier // ignore: cast_nullable_to_non_nullable
                  as double,
        amountToPay: null == amountToPay
            ? _value.amountToPay
            : amountToPay // ignore: cast_nullable_to_non_nullable
                  as double,
        paymentStatus: null == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as PaymentStatus,
        joinedAt: null == joinedAt
            ? _value.joinedAt
            : joinedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ParticipantModelImpl implements _ParticipantModel {
  const _$ParticipantModelImpl({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.displayName,
    this.role = ParticipantRole.participant,
    this.age,
    this.gender = ParticipantGender.other,
    this.multiplier = 1.0,
    this.amountToPay = 0.0,
    this.paymentStatus = PaymentStatus.unpaid,
    @TimestampConverter() required this.joinedAt,
  });

  factory _$ParticipantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParticipantModelImplFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String userId;
  @override
  final String displayName;
  @override
  @JsonKey()
  final ParticipantRole role;
  @override
  final int? age;
  // 年齢（オプション）
  @override
  @JsonKey()
  final ParticipantGender gender;
  @override
  @JsonKey()
  final double multiplier;
  // 支払い比率の重み付け（デフォルト1.0）
  @override
  @JsonKey()
  final double amountToPay;
  // 支払い額
  @override
  @JsonKey()
  final PaymentStatus paymentStatus;
  // 支払いステータス
  @override
  @TimestampConverter()
  final DateTime joinedAt;

  @override
  String toString() {
    return 'ParticipantModel(id: $id, eventId: $eventId, userId: $userId, displayName: $displayName, role: $role, age: $age, gender: $gender, multiplier: $multiplier, amountToPay: $amountToPay, paymentStatus: $paymentStatus, joinedAt: $joinedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParticipantModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.multiplier, multiplier) ||
                other.multiplier == multiplier) &&
            (identical(other.amountToPay, amountToPay) ||
                other.amountToPay == amountToPay) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    eventId,
    userId,
    displayName,
    role,
    age,
    gender,
    multiplier,
    amountToPay,
    paymentStatus,
    joinedAt,
  );

  /// Create a copy of ParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParticipantModelImplCopyWith<_$ParticipantModelImpl> get copyWith =>
      __$$ParticipantModelImplCopyWithImpl<_$ParticipantModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ParticipantModelImplToJson(this);
  }
}

abstract class _ParticipantModel implements ParticipantModel {
  const factory _ParticipantModel({
    required final String id,
    required final String eventId,
    required final String userId,
    required final String displayName,
    final ParticipantRole role,
    final int? age,
    final ParticipantGender gender,
    final double multiplier,
    final double amountToPay,
    final PaymentStatus paymentStatus,
    @TimestampConverter() required final DateTime joinedAt,
  }) = _$ParticipantModelImpl;

  factory _ParticipantModel.fromJson(Map<String, dynamic> json) =
      _$ParticipantModelImpl.fromJson;

  @override
  String get id;
  @override
  String get eventId;
  @override
  String get userId;
  @override
  String get displayName;
  @override
  ParticipantRole get role;
  @override
  int? get age; // 年齢（オプション）
  @override
  ParticipantGender get gender;
  @override
  double get multiplier; // 支払い比率の重み付け（デフォルト1.0）
  @override
  double get amountToPay; // 支払い額
  @override
  PaymentStatus get paymentStatus; // 支払いステータス
  @override
  @TimestampConverter()
  DateTime get joinedAt;

  /// Create a copy of ParticipantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParticipantModelImplCopyWith<_$ParticipantModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
