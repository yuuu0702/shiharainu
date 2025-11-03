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
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EventModel _$EventModelFromJson(Map<String, dynamic> json) {
  return _EventModel.fromJson(json);
}

/// @nodoc
mixin _$EventModel {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get date => throw _privateConstructorUsedError;
  List<String> get organizerIds =>
      throw _privateConstructorUsedError; // 複数の主催者をサポート
  double get totalAmount => throw _privateConstructorUsedError;
  EventStatus get status => throw _privateConstructorUsedError;
  PaymentType get paymentType => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get inviteCode => throw _privateConstructorUsedError; // 招待コード（オプション）
  String? get parentEventId =>
      throw _privateConstructorUsedError; // 親イベントID（二次会の場合のみ）
  List<String> get childEventIds =>
      throw _privateConstructorUsedError; // 子イベントID配列（二次会リスト）
  bool get isAfterParty => throw _privateConstructorUsedError;

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
    EventModel value,
    $Res Function(EventModel) then,
  ) = _$EventModelCopyWithImpl<$Res, EventModel>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    @TimestampConverter() DateTime date,
    List<String> organizerIds,
    double totalAmount,
    EventStatus status,
    PaymentType paymentType,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
    String? inviteCode,
    String? parentEventId,
    List<String> childEventIds,
    bool isAfterParty,
  });
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
    Object? date = null,
    Object? organizerIds = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? paymentType = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? inviteCode = freezed,
    Object? parentEventId = freezed,
    Object? childEventIds = null,
    Object? isAfterParty = null,
  }) {
    return _then(
      _value.copyWith(
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
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            organizerIds: null == organizerIds
                ? _value.organizerIds
                : organizerIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            totalAmount: null == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as EventStatus,
            paymentType: null == paymentType
                ? _value.paymentType
                : paymentType // ignore: cast_nullable_to_non_nullable
                      as PaymentType,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            inviteCode: freezed == inviteCode
                ? _value.inviteCode
                : inviteCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            parentEventId: freezed == parentEventId
                ? _value.parentEventId
                : parentEventId // ignore: cast_nullable_to_non_nullable
                      as String?,
            childEventIds: null == childEventIds
                ? _value.childEventIds
                : childEventIds // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isAfterParty: null == isAfterParty
                ? _value.isAfterParty
                : isAfterParty // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EventModelImplCopyWith<$Res>
    implements $EventModelCopyWith<$Res> {
  factory _$$EventModelImplCopyWith(
    _$EventModelImpl value,
    $Res Function(_$EventModelImpl) then,
  ) = __$$EventModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    @TimestampConverter() DateTime date,
    List<String> organizerIds,
    double totalAmount,
    EventStatus status,
    PaymentType paymentType,
    @TimestampConverter() DateTime createdAt,
    @TimestampConverter() DateTime updatedAt,
    String? inviteCode,
    String? parentEventId,
    List<String> childEventIds,
    bool isAfterParty,
  });
}

/// @nodoc
class __$$EventModelImplCopyWithImpl<$Res>
    extends _$EventModelCopyWithImpl<$Res, _$EventModelImpl>
    implements _$$EventModelImplCopyWith<$Res> {
  __$$EventModelImplCopyWithImpl(
    _$EventModelImpl _value,
    $Res Function(_$EventModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? date = null,
    Object? organizerIds = null,
    Object? totalAmount = null,
    Object? status = null,
    Object? paymentType = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? inviteCode = freezed,
    Object? parentEventId = freezed,
    Object? childEventIds = null,
    Object? isAfterParty = null,
  }) {
    return _then(
      _$EventModelImpl(
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
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        organizerIds: null == organizerIds
            ? _value._organizerIds
            : organizerIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        totalAmount: null == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as EventStatus,
        paymentType: null == paymentType
            ? _value.paymentType
            : paymentType // ignore: cast_nullable_to_non_nullable
                  as PaymentType,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        inviteCode: freezed == inviteCode
            ? _value.inviteCode
            : inviteCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        parentEventId: freezed == parentEventId
            ? _value.parentEventId
            : parentEventId // ignore: cast_nullable_to_non_nullable
                  as String?,
        childEventIds: null == childEventIds
            ? _value._childEventIds
            : childEventIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isAfterParty: null == isAfterParty
            ? _value.isAfterParty
            : isAfterParty // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EventModelImpl implements _EventModel {
  const _$EventModelImpl({
    required this.id,
    required this.title,
    required this.description,
    @TimestampConverter() required this.date,
    required final List<String> organizerIds,
    this.totalAmount = 0.0,
    this.status = EventStatus.planning,
    this.paymentType = PaymentType.equal,
    @TimestampConverter() required this.createdAt,
    @TimestampConverter() required this.updatedAt,
    this.inviteCode,
    this.parentEventId,
    final List<String> childEventIds = const [],
    this.isAfterParty = false,
  }) : _organizerIds = organizerIds,
       _childEventIds = childEventIds;

  factory _$EventModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventModelImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  @TimestampConverter()
  final DateTime date;
  final List<String> _organizerIds;
  @override
  List<String> get organizerIds {
    if (_organizerIds is EqualUnmodifiableListView) return _organizerIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_organizerIds);
  }

  // 複数の主催者をサポート
  @override
  @JsonKey()
  final double totalAmount;
  @override
  @JsonKey()
  final EventStatus status;
  @override
  @JsonKey()
  final PaymentType paymentType;
  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;
  @override
  final String? inviteCode;
  // 招待コード（オプション）
  @override
  final String? parentEventId;
  // 親イベントID（二次会の場合のみ）
  final List<String> _childEventIds;
  // 親イベントID（二次会の場合のみ）
  @override
  @JsonKey()
  List<String> get childEventIds {
    if (_childEventIds is EqualUnmodifiableListView) return _childEventIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_childEventIds);
  }

  // 子イベントID配列（二次会リスト）
  @override
  @JsonKey()
  final bool isAfterParty;

  @override
  String toString() {
    return 'EventModel(id: $id, title: $title, description: $description, date: $date, organizerIds: $organizerIds, totalAmount: $totalAmount, status: $status, paymentType: $paymentType, createdAt: $createdAt, updatedAt: $updatedAt, inviteCode: $inviteCode, parentEventId: $parentEventId, childEventIds: $childEventIds, isAfterParty: $isAfterParty)';
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
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality().equals(
              other._organizerIds,
              _organizerIds,
            ) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentType, paymentType) ||
                other.paymentType == paymentType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            (identical(other.parentEventId, parentEventId) ||
                other.parentEventId == parentEventId) &&
            const DeepCollectionEquality().equals(
              other._childEventIds,
              _childEventIds,
            ) &&
            (identical(other.isAfterParty, isAfterParty) ||
                other.isAfterParty == isAfterParty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    date,
    const DeepCollectionEquality().hash(_organizerIds),
    totalAmount,
    status,
    paymentType,
    createdAt,
    updatedAt,
    inviteCode,
    parentEventId,
    const DeepCollectionEquality().hash(_childEventIds),
    isAfterParty,
  );

  /// Create a copy of EventModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventModelImplCopyWith<_$EventModelImpl> get copyWith =>
      __$$EventModelImplCopyWithImpl<_$EventModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventModelImplToJson(this);
  }
}

abstract class _EventModel implements EventModel {
  const factory _EventModel({
    required final String id,
    required final String title,
    required final String description,
    @TimestampConverter() required final DateTime date,
    required final List<String> organizerIds,
    final double totalAmount,
    final EventStatus status,
    final PaymentType paymentType,
    @TimestampConverter() required final DateTime createdAt,
    @TimestampConverter() required final DateTime updatedAt,
    final String? inviteCode,
    final String? parentEventId,
    final List<String> childEventIds,
    final bool isAfterParty,
  }) = _$EventModelImpl;

  factory _EventModel.fromJson(Map<String, dynamic> json) =
      _$EventModelImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  @TimestampConverter()
  DateTime get date;
  @override
  List<String> get organizerIds; // 複数の主催者をサポート
  @override
  double get totalAmount;
  @override
  EventStatus get status;
  @override
  PaymentType get paymentType;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;
  @override
  String? get inviteCode; // 招待コード（オプション）
  @override
  String? get parentEventId; // 親イベントID（二次会の場合のみ）
  @override
  List<String> get childEventIds; // 子イベントID配列（二次会リスト）
  @override
  bool get isAfterParty;

  /// Create a copy of EventModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventModelImplCopyWith<_$EventModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
