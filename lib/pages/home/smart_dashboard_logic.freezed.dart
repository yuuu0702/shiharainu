// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smart_dashboard_logic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SmartAction {
  SmartActionType get type => throw _privateConstructorUsedError;
  String? get eventId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get subTitle => throw _privateConstructorUsedError;
  DateTime? get eventDate => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;

  /// Create a copy of SmartAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SmartActionCopyWith<SmartAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SmartActionCopyWith<$Res> {
  factory $SmartActionCopyWith(
    SmartAction value,
    $Res Function(SmartAction) then,
  ) = _$SmartActionCopyWithImpl<$Res, SmartAction>;
  @useResult
  $Res call({
    SmartActionType type,
    String? eventId,
    String? title,
    String? subTitle,
    DateTime? eventDate,
    int priority,
  });
}

/// @nodoc
class _$SmartActionCopyWithImpl<$Res, $Val extends SmartAction>
    implements $SmartActionCopyWith<$Res> {
  _$SmartActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SmartAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? eventId = freezed,
    Object? title = freezed,
    Object? subTitle = freezed,
    Object? eventDate = freezed,
    Object? priority = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as SmartActionType,
            eventId: freezed == eventId
                ? _value.eventId
                : eventId // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            subTitle: freezed == subTitle
                ? _value.subTitle
                : subTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            eventDate: freezed == eventDate
                ? _value.eventDate
                : eventDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SmartActionImplCopyWith<$Res>
    implements $SmartActionCopyWith<$Res> {
  factory _$$SmartActionImplCopyWith(
    _$SmartActionImpl value,
    $Res Function(_$SmartActionImpl) then,
  ) = __$$SmartActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    SmartActionType type,
    String? eventId,
    String? title,
    String? subTitle,
    DateTime? eventDate,
    int priority,
  });
}

/// @nodoc
class __$$SmartActionImplCopyWithImpl<$Res>
    extends _$SmartActionCopyWithImpl<$Res, _$SmartActionImpl>
    implements _$$SmartActionImplCopyWith<$Res> {
  __$$SmartActionImplCopyWithImpl(
    _$SmartActionImpl _value,
    $Res Function(_$SmartActionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SmartAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? eventId = freezed,
    Object? title = freezed,
    Object? subTitle = freezed,
    Object? eventDate = freezed,
    Object? priority = null,
  }) {
    return _then(
      _$SmartActionImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as SmartActionType,
        eventId: freezed == eventId
            ? _value.eventId
            : eventId // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        subTitle: freezed == subTitle
            ? _value.subTitle
            : subTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        eventDate: freezed == eventDate
            ? _value.eventDate
            : eventDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$SmartActionImpl implements _SmartAction {
  const _$SmartActionImpl({
    required this.type,
    this.eventId,
    this.title,
    this.subTitle,
    this.eventDate,
    required this.priority,
  });

  @override
  final SmartActionType type;
  @override
  final String? eventId;
  @override
  final String? title;
  @override
  final String? subTitle;
  @override
  final DateTime? eventDate;
  @override
  final int priority;

  @override
  String toString() {
    return 'SmartAction(type: $type, eventId: $eventId, title: $title, subTitle: $subTitle, eventDate: $eventDate, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SmartActionImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.subTitle, subTitle) ||
                other.subTitle == subTitle) &&
            (identical(other.eventDate, eventDate) ||
                other.eventDate == eventDate) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    eventId,
    title,
    subTitle,
    eventDate,
    priority,
  );

  /// Create a copy of SmartAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SmartActionImplCopyWith<_$SmartActionImpl> get copyWith =>
      __$$SmartActionImplCopyWithImpl<_$SmartActionImpl>(this, _$identity);
}

abstract class _SmartAction implements SmartAction {
  const factory _SmartAction({
    required final SmartActionType type,
    final String? eventId,
    final String? title,
    final String? subTitle,
    final DateTime? eventDate,
    required final int priority,
  }) = _$SmartActionImpl;

  @override
  SmartActionType get type;
  @override
  String? get eventId;
  @override
  String? get title;
  @override
  String? get subTitle;
  @override
  DateTime? get eventDate;
  @override
  int get priority;

  /// Create a copy of SmartAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SmartActionImplCopyWith<_$SmartActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
