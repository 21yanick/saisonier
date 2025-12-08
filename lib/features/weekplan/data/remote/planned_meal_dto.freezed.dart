// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'planned_meal_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlannedMealDto _$PlannedMealDtoFromJson(Map<String, dynamic> json) {
  return _PlannedMealDto.fromJson(json);
}

/// @nodoc
mixin _$PlannedMealDto {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get slot =>
      throw _privateConstructorUsedError; // 'breakfast', 'lunch', 'dinner'
  @JsonKey(name: 'recipe_id')
  String? get recipeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'custom_title')
  String? get customTitle => throw _privateConstructorUsedError;
  int get servings => throw _privateConstructorUsedError;

  /// Serializes this PlannedMealDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlannedMealDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlannedMealDtoCopyWith<PlannedMealDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlannedMealDtoCopyWith<$Res> {
  factory $PlannedMealDtoCopyWith(
          PlannedMealDto value, $Res Function(PlannedMealDto) then) =
      _$PlannedMealDtoCopyWithImpl<$Res, PlannedMealDto>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      DateTime date,
      String slot,
      @JsonKey(name: 'recipe_id') String? recipeId,
      @JsonKey(name: 'custom_title') String? customTitle,
      int servings});
}

/// @nodoc
class _$PlannedMealDtoCopyWithImpl<$Res, $Val extends PlannedMealDto>
    implements $PlannedMealDtoCopyWith<$Res> {
  _$PlannedMealDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlannedMealDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? slot = null,
    Object? recipeId = freezed,
    Object? customTitle = freezed,
    Object? servings = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      slot: null == slot
          ? _value.slot
          : slot // ignore: cast_nullable_to_non_nullable
              as String,
      recipeId: freezed == recipeId
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as String?,
      customTitle: freezed == customTitle
          ? _value.customTitle
          : customTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      servings: null == servings
          ? _value.servings
          : servings // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlannedMealDtoImplCopyWith<$Res>
    implements $PlannedMealDtoCopyWith<$Res> {
  factory _$$PlannedMealDtoImplCopyWith(_$PlannedMealDtoImpl value,
          $Res Function(_$PlannedMealDtoImpl) then) =
      __$$PlannedMealDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      DateTime date,
      String slot,
      @JsonKey(name: 'recipe_id') String? recipeId,
      @JsonKey(name: 'custom_title') String? customTitle,
      int servings});
}

/// @nodoc
class __$$PlannedMealDtoImplCopyWithImpl<$Res>
    extends _$PlannedMealDtoCopyWithImpl<$Res, _$PlannedMealDtoImpl>
    implements _$$PlannedMealDtoImplCopyWith<$Res> {
  __$$PlannedMealDtoImplCopyWithImpl(
      _$PlannedMealDtoImpl _value, $Res Function(_$PlannedMealDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlannedMealDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? slot = null,
    Object? recipeId = freezed,
    Object? customTitle = freezed,
    Object? servings = null,
  }) {
    return _then(_$PlannedMealDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      slot: null == slot
          ? _value.slot
          : slot // ignore: cast_nullable_to_non_nullable
              as String,
      recipeId: freezed == recipeId
          ? _value.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as String?,
      customTitle: freezed == customTitle
          ? _value.customTitle
          : customTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      servings: null == servings
          ? _value.servings
          : servings // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlannedMealDtoImpl implements _PlannedMealDto {
  const _$PlannedMealDtoImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.date,
      required this.slot,
      @JsonKey(name: 'recipe_id') this.recipeId,
      @JsonKey(name: 'custom_title') this.customTitle,
      this.servings = 2});

  factory _$PlannedMealDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlannedMealDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final DateTime date;
  @override
  final String slot;
// 'breakfast', 'lunch', 'dinner'
  @override
  @JsonKey(name: 'recipe_id')
  final String? recipeId;
  @override
  @JsonKey(name: 'custom_title')
  final String? customTitle;
  @override
  @JsonKey()
  final int servings;

  @override
  String toString() {
    return 'PlannedMealDto(id: $id, userId: $userId, date: $date, slot: $slot, recipeId: $recipeId, customTitle: $customTitle, servings: $servings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlannedMealDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.slot, slot) || other.slot == slot) &&
            (identical(other.recipeId, recipeId) ||
                other.recipeId == recipeId) &&
            (identical(other.customTitle, customTitle) ||
                other.customTitle == customTitle) &&
            (identical(other.servings, servings) ||
                other.servings == servings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, userId, date, slot, recipeId, customTitle, servings);

  /// Create a copy of PlannedMealDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlannedMealDtoImplCopyWith<_$PlannedMealDtoImpl> get copyWith =>
      __$$PlannedMealDtoImplCopyWithImpl<_$PlannedMealDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlannedMealDtoImplToJson(
      this,
    );
  }
}

abstract class _PlannedMealDto implements PlannedMealDto {
  const factory _PlannedMealDto(
      {required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      required final DateTime date,
      required final String slot,
      @JsonKey(name: 'recipe_id') final String? recipeId,
      @JsonKey(name: 'custom_title') final String? customTitle,
      final int servings}) = _$PlannedMealDtoImpl;

  factory _PlannedMealDto.fromJson(Map<String, dynamic> json) =
      _$PlannedMealDtoImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  DateTime get date;
  @override
  String get slot; // 'breakfast', 'lunch', 'dinner'
  @override
  @JsonKey(name: 'recipe_id')
  String? get recipeId;
  @override
  @JsonKey(name: 'custom_title')
  String? get customTitle;
  @override
  int get servings;

  /// Create a copy of PlannedMealDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlannedMealDtoImplCopyWith<_$PlannedMealDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
