// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfileDto _$UserProfileDtoFromJson(Map<String, dynamic> json) {
  return _UserProfileDto.fromJson(json);
}

/// @nodoc
mixin _$UserProfileDto {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'household_size')
  int get householdSize => throw _privateConstructorUsedError;
  @JsonKey(name: 'children_count')
  int get childrenCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'children_ages')
  List<int>? get childrenAges => throw _privateConstructorUsedError;
  @JsonKey(name: 'allergens')
  List<String>? get allergens => throw _privateConstructorUsedError;
  @JsonKey(name: 'diet')
  String get diet => throw _privateConstructorUsedError;
  @JsonKey(name: 'dislikes')
  List<String>? get dislikes => throw _privateConstructorUsedError;
  @JsonKey(name: 'skill')
  String get skill => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_cooking_time_min')
  int get maxCookingTimeMin => throw _privateConstructorUsedError;
  @JsonKey(name: 'bring_email')
  String? get bringEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'bring_list_uuid')
  String? get bringListUuid => throw _privateConstructorUsedError;

  /// Serializes this UserProfileDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileDtoCopyWith<UserProfileDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileDtoCopyWith<$Res> {
  factory $UserProfileDtoCopyWith(
          UserProfileDto value, $Res Function(UserProfileDto) then) =
      _$UserProfileDtoCopyWithImpl<$Res, UserProfileDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'household_size') int householdSize,
      @JsonKey(name: 'children_count') int childrenCount,
      @JsonKey(name: 'children_ages') List<int>? childrenAges,
      @JsonKey(name: 'allergens') List<String>? allergens,
      @JsonKey(name: 'diet') String diet,
      @JsonKey(name: 'dislikes') List<String>? dislikes,
      @JsonKey(name: 'skill') String skill,
      @JsonKey(name: 'max_cooking_time_min') int maxCookingTimeMin,
      @JsonKey(name: 'bring_email') String? bringEmail,
      @JsonKey(name: 'bring_list_uuid') String? bringListUuid});
}

/// @nodoc
class _$UserProfileDtoCopyWithImpl<$Res, $Val extends UserProfileDto>
    implements $UserProfileDtoCopyWith<$Res> {
  _$UserProfileDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? householdSize = null,
    Object? childrenCount = null,
    Object? childrenAges = freezed,
    Object? allergens = freezed,
    Object? diet = null,
    Object? dislikes = freezed,
    Object? skill = null,
    Object? maxCookingTimeMin = null,
    Object? bringEmail = freezed,
    Object? bringListUuid = freezed,
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
      householdSize: null == householdSize
          ? _value.householdSize
          : householdSize // ignore: cast_nullable_to_non_nullable
              as int,
      childrenCount: null == childrenCount
          ? _value.childrenCount
          : childrenCount // ignore: cast_nullable_to_non_nullable
              as int,
      childrenAges: freezed == childrenAges
          ? _value.childrenAges
          : childrenAges // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      allergens: freezed == allergens
          ? _value.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      diet: null == diet
          ? _value.diet
          : diet // ignore: cast_nullable_to_non_nullable
              as String,
      dislikes: freezed == dislikes
          ? _value.dislikes
          : dislikes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      skill: null == skill
          ? _value.skill
          : skill // ignore: cast_nullable_to_non_nullable
              as String,
      maxCookingTimeMin: null == maxCookingTimeMin
          ? _value.maxCookingTimeMin
          : maxCookingTimeMin // ignore: cast_nullable_to_non_nullable
              as int,
      bringEmail: freezed == bringEmail
          ? _value.bringEmail
          : bringEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      bringListUuid: freezed == bringListUuid
          ? _value.bringListUuid
          : bringListUuid // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileDtoImplCopyWith<$Res>
    implements $UserProfileDtoCopyWith<$Res> {
  factory _$$UserProfileDtoImplCopyWith(_$UserProfileDtoImpl value,
          $Res Function(_$UserProfileDtoImpl) then) =
      __$$UserProfileDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'household_size') int householdSize,
      @JsonKey(name: 'children_count') int childrenCount,
      @JsonKey(name: 'children_ages') List<int>? childrenAges,
      @JsonKey(name: 'allergens') List<String>? allergens,
      @JsonKey(name: 'diet') String diet,
      @JsonKey(name: 'dislikes') List<String>? dislikes,
      @JsonKey(name: 'skill') String skill,
      @JsonKey(name: 'max_cooking_time_min') int maxCookingTimeMin,
      @JsonKey(name: 'bring_email') String? bringEmail,
      @JsonKey(name: 'bring_list_uuid') String? bringListUuid});
}

/// @nodoc
class __$$UserProfileDtoImplCopyWithImpl<$Res>
    extends _$UserProfileDtoCopyWithImpl<$Res, _$UserProfileDtoImpl>
    implements _$$UserProfileDtoImplCopyWith<$Res> {
  __$$UserProfileDtoImplCopyWithImpl(
      _$UserProfileDtoImpl _value, $Res Function(_$UserProfileDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? householdSize = null,
    Object? childrenCount = null,
    Object? childrenAges = freezed,
    Object? allergens = freezed,
    Object? diet = null,
    Object? dislikes = freezed,
    Object? skill = null,
    Object? maxCookingTimeMin = null,
    Object? bringEmail = freezed,
    Object? bringListUuid = freezed,
  }) {
    return _then(_$UserProfileDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      householdSize: null == householdSize
          ? _value.householdSize
          : householdSize // ignore: cast_nullable_to_non_nullable
              as int,
      childrenCount: null == childrenCount
          ? _value.childrenCount
          : childrenCount // ignore: cast_nullable_to_non_nullable
              as int,
      childrenAges: freezed == childrenAges
          ? _value._childrenAges
          : childrenAges // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      allergens: freezed == allergens
          ? _value._allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      diet: null == diet
          ? _value.diet
          : diet // ignore: cast_nullable_to_non_nullable
              as String,
      dislikes: freezed == dislikes
          ? _value._dislikes
          : dislikes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      skill: null == skill
          ? _value.skill
          : skill // ignore: cast_nullable_to_non_nullable
              as String,
      maxCookingTimeMin: null == maxCookingTimeMin
          ? _value.maxCookingTimeMin
          : maxCookingTimeMin // ignore: cast_nullable_to_non_nullable
              as int,
      bringEmail: freezed == bringEmail
          ? _value.bringEmail
          : bringEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      bringListUuid: freezed == bringListUuid
          ? _value.bringListUuid
          : bringListUuid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileDtoImpl extends _UserProfileDto {
  const _$UserProfileDtoImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'household_size') required this.householdSize,
      @JsonKey(name: 'children_count') required this.childrenCount,
      @JsonKey(name: 'children_ages') final List<int>? childrenAges,
      @JsonKey(name: 'allergens') final List<String>? allergens,
      @JsonKey(name: 'diet') required this.diet,
      @JsonKey(name: 'dislikes') final List<String>? dislikes,
      @JsonKey(name: 'skill') required this.skill,
      @JsonKey(name: 'max_cooking_time_min') required this.maxCookingTimeMin,
      @JsonKey(name: 'bring_email') this.bringEmail,
      @JsonKey(name: 'bring_list_uuid') this.bringListUuid})
      : _childrenAges = childrenAges,
        _allergens = allergens,
        _dislikes = dislikes,
        super._();

  factory _$UserProfileDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileDtoImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'household_size')
  final int householdSize;
  @override
  @JsonKey(name: 'children_count')
  final int childrenCount;
  final List<int>? _childrenAges;
  @override
  @JsonKey(name: 'children_ages')
  List<int>? get childrenAges {
    final value = _childrenAges;
    if (value == null) return null;
    if (_childrenAges is EqualUnmodifiableListView) return _childrenAges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _allergens;
  @override
  @JsonKey(name: 'allergens')
  List<String>? get allergens {
    final value = _allergens;
    if (value == null) return null;
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'diet')
  final String diet;
  final List<String>? _dislikes;
  @override
  @JsonKey(name: 'dislikes')
  List<String>? get dislikes {
    final value = _dislikes;
    if (value == null) return null;
    if (_dislikes is EqualUnmodifiableListView) return _dislikes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'skill')
  final String skill;
  @override
  @JsonKey(name: 'max_cooking_time_min')
  final int maxCookingTimeMin;
  @override
  @JsonKey(name: 'bring_email')
  final String? bringEmail;
  @override
  @JsonKey(name: 'bring_list_uuid')
  final String? bringListUuid;

  @override
  String toString() {
    return 'UserProfileDto(id: $id, userId: $userId, householdSize: $householdSize, childrenCount: $childrenCount, childrenAges: $childrenAges, allergens: $allergens, diet: $diet, dislikes: $dislikes, skill: $skill, maxCookingTimeMin: $maxCookingTimeMin, bringEmail: $bringEmail, bringListUuid: $bringListUuid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.householdSize, householdSize) ||
                other.householdSize == householdSize) &&
            (identical(other.childrenCount, childrenCount) ||
                other.childrenCount == childrenCount) &&
            const DeepCollectionEquality()
                .equals(other._childrenAges, _childrenAges) &&
            const DeepCollectionEquality()
                .equals(other._allergens, _allergens) &&
            (identical(other.diet, diet) || other.diet == diet) &&
            const DeepCollectionEquality().equals(other._dislikes, _dislikes) &&
            (identical(other.skill, skill) || other.skill == skill) &&
            (identical(other.maxCookingTimeMin, maxCookingTimeMin) ||
                other.maxCookingTimeMin == maxCookingTimeMin) &&
            (identical(other.bringEmail, bringEmail) ||
                other.bringEmail == bringEmail) &&
            (identical(other.bringListUuid, bringListUuid) ||
                other.bringListUuid == bringListUuid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      householdSize,
      childrenCount,
      const DeepCollectionEquality().hash(_childrenAges),
      const DeepCollectionEquality().hash(_allergens),
      diet,
      const DeepCollectionEquality().hash(_dislikes),
      skill,
      maxCookingTimeMin,
      bringEmail,
      bringListUuid);

  /// Create a copy of UserProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileDtoImplCopyWith<_$UserProfileDtoImpl> get copyWith =>
      __$$UserProfileDtoImplCopyWithImpl<_$UserProfileDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileDtoImplToJson(
      this,
    );
  }
}

abstract class _UserProfileDto extends UserProfileDto {
  const factory _UserProfileDto(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'user_id') required final String userId,
          @JsonKey(name: 'household_size') required final int householdSize,
          @JsonKey(name: 'children_count') required final int childrenCount,
          @JsonKey(name: 'children_ages') final List<int>? childrenAges,
          @JsonKey(name: 'allergens') final List<String>? allergens,
          @JsonKey(name: 'diet') required final String diet,
          @JsonKey(name: 'dislikes') final List<String>? dislikes,
          @JsonKey(name: 'skill') required final String skill,
          @JsonKey(name: 'max_cooking_time_min')
          required final int maxCookingTimeMin,
          @JsonKey(name: 'bring_email') final String? bringEmail,
          @JsonKey(name: 'bring_list_uuid') final String? bringListUuid}) =
      _$UserProfileDtoImpl;
  const _UserProfileDto._() : super._();

  factory _UserProfileDto.fromJson(Map<String, dynamic> json) =
      _$UserProfileDtoImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'household_size')
  int get householdSize;
  @override
  @JsonKey(name: 'children_count')
  int get childrenCount;
  @override
  @JsonKey(name: 'children_ages')
  List<int>? get childrenAges;
  @override
  @JsonKey(name: 'allergens')
  List<String>? get allergens;
  @override
  @JsonKey(name: 'diet')
  String get diet;
  @override
  @JsonKey(name: 'dislikes')
  List<String>? get dislikes;
  @override
  @JsonKey(name: 'skill')
  String get skill;
  @override
  @JsonKey(name: 'max_cooking_time_min')
  int get maxCookingTimeMin;
  @override
  @JsonKey(name: 'bring_email')
  String? get bringEmail;
  @override
  @JsonKey(name: 'bring_list_uuid')
  String? get bringListUuid;

  /// Create a copy of UserProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileDtoImplCopyWith<_$UserProfileDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
