// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  String get userId => throw _privateConstructorUsedError; // Household
  int get householdSize => throw _privateConstructorUsedError;
  int get childrenCount => throw _privateConstructorUsedError;
  List<int>? get childrenAges =>
      throw _privateConstructorUsedError; // Nutrition
  List<Allergen> get allergens => throw _privateConstructorUsedError;
  DietType get diet => throw _privateConstructorUsedError;
  List<String> get dislikes => throw _privateConstructorUsedError; // Cooking
  CookingSkill get skill => throw _privateConstructorUsedError;
  int get maxCookingTimeMin =>
      throw _privateConstructorUsedError; // External Services
  String? get bringEmail => throw _privateConstructorUsedError;
  String? get bringListUuid => throw _privateConstructorUsedError;

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {String userId,
      int householdSize,
      int childrenCount,
      List<int>? childrenAges,
      List<Allergen> allergens,
      DietType diet,
      List<String> dislikes,
      CookingSkill skill,
      int maxCookingTimeMin,
      String? bringEmail,
      String? bringListUuid});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? householdSize = null,
    Object? childrenCount = null,
    Object? childrenAges = freezed,
    Object? allergens = null,
    Object? diet = null,
    Object? dislikes = null,
    Object? skill = null,
    Object? maxCookingTimeMin = null,
    Object? bringEmail = freezed,
    Object? bringListUuid = freezed,
  }) {
    return _then(_value.copyWith(
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
      allergens: null == allergens
          ? _value.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<Allergen>,
      diet: null == diet
          ? _value.diet
          : diet // ignore: cast_nullable_to_non_nullable
              as DietType,
      dislikes: null == dislikes
          ? _value.dislikes
          : dislikes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      skill: null == skill
          ? _value.skill
          : skill // ignore: cast_nullable_to_non_nullable
              as CookingSkill,
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
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      int householdSize,
      int childrenCount,
      List<int>? childrenAges,
      List<Allergen> allergens,
      DietType diet,
      List<String> dislikes,
      CookingSkill skill,
      int maxCookingTimeMin,
      String? bringEmail,
      String? bringListUuid});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? householdSize = null,
    Object? childrenCount = null,
    Object? childrenAges = freezed,
    Object? allergens = null,
    Object? diet = null,
    Object? dislikes = null,
    Object? skill = null,
    Object? maxCookingTimeMin = null,
    Object? bringEmail = freezed,
    Object? bringListUuid = freezed,
  }) {
    return _then(_$UserProfileImpl(
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
      allergens: null == allergens
          ? _value._allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<Allergen>,
      diet: null == diet
          ? _value.diet
          : diet // ignore: cast_nullable_to_non_nullable
              as DietType,
      dislikes: null == dislikes
          ? _value._dislikes
          : dislikes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      skill: null == skill
          ? _value.skill
          : skill // ignore: cast_nullable_to_non_nullable
              as CookingSkill,
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
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {required this.userId,
      this.householdSize = 1,
      this.childrenCount = 0,
      final List<int>? childrenAges,
      final List<Allergen> allergens = const [],
      this.diet = DietType.omnivore,
      final List<String> dislikes = const [],
      this.skill = CookingSkill.beginner,
      this.maxCookingTimeMin = 30,
      this.bringEmail,
      this.bringListUuid})
      : _childrenAges = childrenAges,
        _allergens = allergens,
        _dislikes = dislikes;

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  final String userId;
// Household
  @override
  @JsonKey()
  final int householdSize;
  @override
  @JsonKey()
  final int childrenCount;
  final List<int>? _childrenAges;
  @override
  List<int>? get childrenAges {
    final value = _childrenAges;
    if (value == null) return null;
    if (_childrenAges is EqualUnmodifiableListView) return _childrenAges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Nutrition
  final List<Allergen> _allergens;
// Nutrition
  @override
  @JsonKey()
  List<Allergen> get allergens {
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergens);
  }

  @override
  @JsonKey()
  final DietType diet;
  final List<String> _dislikes;
  @override
  @JsonKey()
  List<String> get dislikes {
    if (_dislikes is EqualUnmodifiableListView) return _dislikes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dislikes);
  }

// Cooking
  @override
  @JsonKey()
  final CookingSkill skill;
  @override
  @JsonKey()
  final int maxCookingTimeMin;
// External Services
  @override
  final String? bringEmail;
  @override
  final String? bringListUuid;

  @override
  String toString() {
    return 'UserProfile(userId: $userId, householdSize: $householdSize, childrenCount: $childrenCount, childrenAges: $childrenAges, allergens: $allergens, diet: $diet, dislikes: $dislikes, skill: $skill, maxCookingTimeMin: $maxCookingTimeMin, bringEmail: $bringEmail, bringListUuid: $bringListUuid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
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

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {required final String userId,
      final int householdSize,
      final int childrenCount,
      final List<int>? childrenAges,
      final List<Allergen> allergens,
      final DietType diet,
      final List<String> dislikes,
      final CookingSkill skill,
      final int maxCookingTimeMin,
      final String? bringEmail,
      final String? bringListUuid}) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  String get userId; // Household
  @override
  int get householdSize;
  @override
  int get childrenCount;
  @override
  List<int>? get childrenAges; // Nutrition
  @override
  List<Allergen> get allergens;
  @override
  DietType get diet;
  @override
  List<String> get dislikes; // Cooking
  @override
  CookingSkill get skill;
  @override
  int get maxCookingTimeMin; // External Services
  @override
  String? get bringEmail;
  @override
  String? get bringListUuid;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
