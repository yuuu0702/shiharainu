// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventModel _$EventModelFromJson(Map<String, dynamic> json) {
  return _EventModel.fromJson(json);
}

/// @nodoc
mixin _$EventModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get organizerId => throw _privateConstructorUsedError;
  double get totalAmount => throw _privateConstructorUsedError;
  DateTime get eventDate => throw _privateConstructorUsedError;
  DateTime get paymentDeadline => throw _privateConstructorUsedError;
  String get venue => throw _privateConstructorUsedError;
  ProportionalPattern get proportionalPattern =>
      throw _privateConstructorUsedError;
  List<String> get participantIds => throw _privateConstructorUsedError;
  EventStatus get status => throw _privateConstructorUsedError;
  String? get qrCode => throw _privateConstructorUsedError;
  String? get shareUrl => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this EventModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventModelCopyWith<EventModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventModelCopyWith<$Res> {
  factory $EventModelCopyWith(
          EventModel value, $Res Function(EventModel) then) =
      _$EventModelCopyWithImpl<$Res, EventModel>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String organizerId,
      double totalAmount,
      DateTime eventDate,
      DateTime paymentDeadline,
      String venue,
      ProportionalPattern proportionalPattern,
      List<String> participantIds,
      EventStatus status,
      String? qrCode,
      String? shareUrl,
      DateTime? createdAt,
      DateTime? updatedAt});

  $ProportionalPatternCopyWith<$Res> get proportionalPattern;
}

/// @nodoc
class _$EventModelCopyWithImpl<$Res, $Val extends EventModel>
    implements $EventModelCopyWith<$Res> {
  _$EventModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? organizerId = null,
    Object? totalAmount = null,
    Object? eventDate = null,
    Object? paymentDeadline = null,
    Object? venue = null,
    Object? proportionalPattern = null,
    Object? participantIds = null,
    Object? status = null,
    Object? qrCode = freezed,
    Object? shareUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      organizerId: null == organizerId
          ? _value.organizerId
          : organizerId // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      eventDate: null == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paymentDeadline: null == paymentDeadline
          ? _value.paymentDeadline
          : paymentDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      venue: null == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as String,
      proportionalPattern: null == proportionalPattern
          ? _value.proportionalPattern
          : proportionalPattern // ignore: cast_nullable_to_non_nullable
              as ProportionalPattern,
      participantIds: null == participantIds
          ? _value.participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatus,
      qrCode: freezed == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String?,
      shareUrl: freezed == shareUrl
          ? _value.shareUrl
          : shareUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of EventModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProportionalPatternCopyWith<$Res> get proportionalPattern {
    return $ProportionalPatternCopyWith<$Res>(_value.proportionalPattern,
        (value) {
      return _then(_value.copyWith(proportionalPattern: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$EventModelImplCopyWith<$Res>
    implements $EventModelCopyWith<$Res> {
  factory _$$EventModelImplCopyWith(
          _$EventModelImpl value, $Res Function(_$EventModelImpl) then) =
      __$$EventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String organizerId,
      double totalAmount,
      DateTime eventDate,
      DateTime paymentDeadline,
      String venue,
      ProportionalPattern proportionalPattern,
      List<String> participantIds,
      EventStatus status,
      String? qrCode,
      String? shareUrl,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $ProportionalPatternCopyWith<$Res> get proportionalPattern;
}

/// @nodoc
class __$$EventModelImplCopyWithImpl<$Res>
    extends _$EventModelCopyWithImpl<$Res, _$EventModelImpl>
    implements _$$EventModelImplCopyWith<$Res> {
  __$$EventModelImplCopyWithImpl(
      _$EventModelImpl _value, $Res Function(_$EventModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? organizerId = null,
    Object? totalAmount = null,
    Object? eventDate = null,
    Object? paymentDeadline = null,
    Object? venue = null,
    Object? proportionalPattern = null,
    Object? participantIds = null,
    Object? status = null,
    Object? qrCode = freezed,
    Object? shareUrl = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$EventModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      organizerId: null == organizerId
          ? _value.organizerId
          : organizerId // ignore: cast_nullable_to_non_nullable
              as String,
      totalAmount: null == totalAmount
          ? _value.totalAmount
          : totalAmount // ignore: cast_nullable_to_non_nullable
              as double,
      eventDate: null == eventDate
          ? _value.eventDate
          : eventDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      paymentDeadline: null == paymentDeadline
          ? _value.paymentDeadline
          : paymentDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      venue: null == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as String,
      proportionalPattern: null == proportionalPattern
          ? _value.proportionalPattern
          : proportionalPattern // ignore: cast_nullable_to_non_nullable
              as ProportionalPattern,
      participantIds: null == participantIds
          ? _value._participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as EventStatus,
      qrCode: freezed == qrCode
          ? _value.qrCode
          : qrCode // ignore: cast_nullable_to_non_nullable
              as String?,
      shareUrl: freezed == shareUrl
          ? _value.shareUrl
          : shareUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventModelImpl implements _EventModel {
  const _$EventModelImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.organizerId,
      required this.totalAmount,
      required this.eventDate,
      required this.paymentDeadline,
      required this.venue,
      required this.proportionalPattern,
      final List<String> participantIds = const [],
      this.status = EventStatus.active,
      this.qrCode,
      this.shareUrl,
      this.createdAt,
      this.updatedAt})
      : _participantIds = participantIds;

  factory _$EventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String organizerId;
  @override
  final double totalAmount;
  @override
  final DateTime eventDate;
  @override
  final DateTime paymentDeadline;
  @override
  final String venue;
  @override
  final ProportionalPattern proportionalPattern;
  final List<String> _participantIds;
  @override
  @JsonKey()
  List<String> get participantIds {
    if (_participantIds is EqualUnmodifiableListView) return _participantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantIds);
  }

  @override
  @JsonKey()
  final EventStatus status;
  @override
  final String? qrCode;
  @override
  final String? shareUrl;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'EventModel(id: $id, title: $title, description: $description, organizerId: $organizerId, totalAmount: $totalAmount, eventDate: $eventDate, paymentDeadline: $paymentDeadline, venue: $venue, proportionalPattern: $proportionalPattern, participantIds: $participantIds, status: $status, qrCode: $qrCode, shareUrl: $shareUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.organizerId, organizerId) ||
                other.organizerId == organizerId) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.paymentDeadline, paymentDeadline) ||
                other.paymentDeadline == paymentDeadline) &&
            (identical(other.venue, venue) || other.venue == venue) &&
            (identical(other.proportionalPattern, proportionalPattern) ||
                other.proportionalPattern == proportionalPattern) &&
            const DeepCollectionEquality()
                .equals(other._participantIds, _participantIds) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.qrCode, qrCode) || other.qrCode == qrCode) &&
            (identical(other.shareUrl, shareUrl) ||
                other.shareUrl == shareUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      organizerId,
      totalAmount,
      eventDate,
      paymentDeadline,
      venue,
      proportionalPattern,
      const DeepCollectionEquality().hash(_participantIds),
      status,
      qrCode,
      shareUrl,
      createdAt,
      updatedAt);

  /// Create a copy of EventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventModelImplCopyWith<_$EventModelImpl> get copyWith =>
      __$$EventModelImplCopyWithImpl<_$EventModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventModelImplToJson(
      this,
    );
  }
}

abstract class _EventModel implements EventModel {
  const factory _EventModel(
      {required final String id,
      required final String title,
      required final String description,
      required final String organizerId,
      required final double totalAmount,
      required final DateTime eventDate,
      required final DateTime paymentDeadline,
      required final String venue,
      required final ProportionalPattern proportionalPattern,
      final List<String> participantIds,
      final EventStatus status,
      final String? qrCode,
      final String? shareUrl,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$EventModelImpl;

  factory _EventModel.fromJson(Map<String, dynamic> json) =
      _$EventModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String get organizerId;
  @override
  double get totalAmount;
  @override
  DateTime get eventDate;
  @override
  DateTime get paymentDeadline;
  @override
  String get venue;
  @override
  ProportionalPattern get proportionalPattern;
  @override
  List<String> get participantIds;
  @override
  EventStatus get status;
  @override
  String? get qrCode;
  @override
  String? get shareUrl;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of EventModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventModelImplCopyWith<_$EventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProportionalPattern _$ProportionalPatternFromJson(Map<String, dynamic> json) {
  return _ProportionalPattern.fromJson(json);
}

/// @nodoc
mixin _$ProportionalPattern {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  Map<String, double> get roleMultipliers => throw _privateConstructorUsedError;
  Map<String, double> get ageMultipliers => throw _privateConstructorUsedError;
  Map<String, double> get genderMultipliers =>
      throw _privateConstructorUsedError;
  double get drinkingMultiplier => throw _privateConstructorUsedError;
  double get nonDrinkingMultiplier => throw _privateConstructorUsedError;
  bool get isCustom => throw _privateConstructorUsedError;

  /// Serializes this ProportionalPattern to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProportionalPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProportionalPatternCopyWith<ProportionalPattern> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProportionalPatternCopyWith<$Res> {
  factory $ProportionalPatternCopyWith(
          ProportionalPattern value, $Res Function(ProportionalPattern) then) =
      _$ProportionalPatternCopyWithImpl<$Res, ProportionalPattern>;
  @useResult
  $Res call(
      {String id,
      String name,
      Map<String, double> roleMultipliers,
      Map<String, double> ageMultipliers,
      Map<String, double> genderMultipliers,
      double drinkingMultiplier,
      double nonDrinkingMultiplier,
      bool isCustom});
}

/// @nodoc
class _$ProportionalPatternCopyWithImpl<$Res, $Val extends ProportionalPattern>
    implements $ProportionalPatternCopyWith<$Res> {
  _$ProportionalPatternCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProportionalPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? roleMultipliers = null,
    Object? ageMultipliers = null,
    Object? genderMultipliers = null,
    Object? drinkingMultiplier = null,
    Object? nonDrinkingMultiplier = null,
    Object? isCustom = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      roleMultipliers: null == roleMultipliers
          ? _value.roleMultipliers
          : roleMultipliers // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      ageMultipliers: null == ageMultipliers
          ? _value.ageMultipliers
          : ageMultipliers // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      genderMultipliers: null == genderMultipliers
          ? _value.genderMultipliers
          : genderMultipliers // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      drinkingMultiplier: null == drinkingMultiplier
          ? _value.drinkingMultiplier
          : drinkingMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      nonDrinkingMultiplier: null == nonDrinkingMultiplier
          ? _value.nonDrinkingMultiplier
          : nonDrinkingMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      isCustom: null == isCustom
          ? _value.isCustom
          : isCustom // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProportionalPatternImplCopyWith<$Res>
    implements $ProportionalPatternCopyWith<$Res> {
  factory _$$ProportionalPatternImplCopyWith(_$ProportionalPatternImpl value,
          $Res Function(_$ProportionalPatternImpl) then) =
      __$$ProportionalPatternImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      Map<String, double> roleMultipliers,
      Map<String, double> ageMultipliers,
      Map<String, double> genderMultipliers,
      double drinkingMultiplier,
      double nonDrinkingMultiplier,
      bool isCustom});
}

/// @nodoc
class __$$ProportionalPatternImplCopyWithImpl<$Res>
    extends _$ProportionalPatternCopyWithImpl<$Res, _$ProportionalPatternImpl>
    implements _$$ProportionalPatternImplCopyWith<$Res> {
  __$$ProportionalPatternImplCopyWithImpl(_$ProportionalPatternImpl _value,
      $Res Function(_$ProportionalPatternImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProportionalPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? roleMultipliers = null,
    Object? ageMultipliers = null,
    Object? genderMultipliers = null,
    Object? drinkingMultiplier = null,
    Object? nonDrinkingMultiplier = null,
    Object? isCustom = null,
  }) {
    return _then(_$ProportionalPatternImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      roleMultipliers: null == roleMultipliers
          ? _value._roleMultipliers
          : roleMultipliers // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      ageMultipliers: null == ageMultipliers
          ? _value._ageMultipliers
          : ageMultipliers // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      genderMultipliers: null == genderMultipliers
          ? _value._genderMultipliers
          : genderMultipliers // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      drinkingMultiplier: null == drinkingMultiplier
          ? _value.drinkingMultiplier
          : drinkingMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      nonDrinkingMultiplier: null == nonDrinkingMultiplier
          ? _value.nonDrinkingMultiplier
          : nonDrinkingMultiplier // ignore: cast_nullable_to_non_nullable
              as double,
      isCustom: null == isCustom
          ? _value.isCustom
          : isCustom // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProportionalPatternImpl implements _ProportionalPattern {
  const _$ProportionalPatternImpl(
      {required this.id,
      required this.name,
      required final Map<String, double> roleMultipliers,
      required final Map<String, double> ageMultipliers,
      required final Map<String, double> genderMultipliers,
      required this.drinkingMultiplier,
      required this.nonDrinkingMultiplier,
      this.isCustom = false})
      : _roleMultipliers = roleMultipliers,
        _ageMultipliers = ageMultipliers,
        _genderMultipliers = genderMultipliers;

  factory _$ProportionalPatternImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProportionalPatternImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  final Map<String, double> _roleMultipliers;
  @override
  Map<String, double> get roleMultipliers {
    if (_roleMultipliers is EqualUnmodifiableMapView) return _roleMultipliers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_roleMultipliers);
  }

  final Map<String, double> _ageMultipliers;
  @override
  Map<String, double> get ageMultipliers {
    if (_ageMultipliers is EqualUnmodifiableMapView) return _ageMultipliers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_ageMultipliers);
  }

  final Map<String, double> _genderMultipliers;
  @override
  Map<String, double> get genderMultipliers {
    if (_genderMultipliers is EqualUnmodifiableMapView)
      return _genderMultipliers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_genderMultipliers);
  }

  @override
  final double drinkingMultiplier;
  @override
  final double nonDrinkingMultiplier;
  @override
  @JsonKey()
  final bool isCustom;

  @override
  String toString() {
    return 'ProportionalPattern(id: $id, name: $name, roleMultipliers: $roleMultipliers, ageMultipliers: $ageMultipliers, genderMultipliers: $genderMultipliers, drinkingMultiplier: $drinkingMultiplier, nonDrinkingMultiplier: $nonDrinkingMultiplier, isCustom: $isCustom)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProportionalPatternImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._roleMultipliers, _roleMultipliers) &&
            const DeepCollectionEquality()
                .equals(other._ageMultipliers, _ageMultipliers) &&
            const DeepCollectionEquality()
                .equals(other._genderMultipliers, _genderMultipliers) &&
            (identical(other.drinkingMultiplier, drinkingMultiplier) ||
                other.drinkingMultiplier == drinkingMultiplier) &&
            (identical(other.nonDrinkingMultiplier, nonDrinkingMultiplier) ||
                other.nonDrinkingMultiplier == nonDrinkingMultiplier) &&
            (identical(other.isCustom, isCustom) ||
                other.isCustom == isCustom));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      const DeepCollectionEquality().hash(_roleMultipliers),
      const DeepCollectionEquality().hash(_ageMultipliers),
      const DeepCollectionEquality().hash(_genderMultipliers),
      drinkingMultiplier,
      nonDrinkingMultiplier,
      isCustom);

  /// Create a copy of ProportionalPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProportionalPatternImplCopyWith<_$ProportionalPatternImpl> get copyWith =>
      __$$ProportionalPatternImplCopyWithImpl<_$ProportionalPatternImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProportionalPatternImplToJson(
      this,
    );
  }
}

abstract class _ProportionalPattern implements ProportionalPattern {
  const factory _ProportionalPattern(
      {required final String id,
      required final String name,
      required final Map<String, double> roleMultipliers,
      required final Map<String, double> ageMultipliers,
      required final Map<String, double> genderMultipliers,
      required final double drinkingMultiplier,
      required final double nonDrinkingMultiplier,
      final bool isCustom}) = _$ProportionalPatternImpl;

  factory _ProportionalPattern.fromJson(Map<String, dynamic> json) =
      _$ProportionalPatternImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  Map<String, double> get roleMultipliers;
  @override
  Map<String, double> get ageMultipliers;
  @override
  Map<String, double> get genderMultipliers;
  @override
  double get drinkingMultiplier;
  @override
  double get nonDrinkingMultiplier;
  @override
  bool get isCustom;

  /// Create a copy of ProportionalPattern
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProportionalPatternImplCopyWith<_$ProportionalPatternImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
