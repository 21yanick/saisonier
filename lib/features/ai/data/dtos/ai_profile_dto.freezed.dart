// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_profile_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AIProfileDto _$AIProfileDtoFromJson(Map<String, dynamic> json) {
  return _AIProfileDto.fromJson(json);
}

/// @nodoc
mixin _$AIProfileDto {
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId =>
      throw _privateConstructorUsedError; // Culinary Preferences (JSON arrays stored as List<String>)
  @JsonKey(name: 'cuisine_preferences')
  List<String>? get cuisinePreferences => throw _privateConstructorUsedError;
  @JsonKey(name: 'flavor_profile')
  List<String>? get flavorProfile => throw _privateConstructorUsedError;
  @JsonKey(name: 'likes')
  List<String>? get likes => throw _privateConstructorUsedError;
  @JsonKey(name: 'protein_preferences')
  List<String>? get proteinPreferences =>
      throw _privateConstructorUsedError; // Lifestyle
  @JsonKey(name: 'budget_level')
  String? get budgetLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'meal_prep_style')
  String? get mealPrepStyle => throw _privateConstructorUsedError;
  @JsonKey(name: 'cooking_days_per_week')
  int? get cookingDaysPerWeek => throw _privateConstructorUsedError; // Goals
  @JsonKey(name: 'health_goals')
  List<String>? get healthGoals => throw _privateConstructorUsedError;
  @JsonKey(name: 'nutrition_focus')
  String? get nutritionFocus => throw _privateConstructorUsedError; // Equipment
  @JsonKey(name: 'equipment')
  List<String>? get equipment =>
      throw _privateConstructorUsedError; // Learning Context (JSON object)
  @JsonKey(name: 'learning_context')
  Map<String, dynamic>? get learningContext =>
      throw _privateConstructorUsedError; // Meta
  @JsonKey(name: 'onboarding_completed')
  bool? get onboardingCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'created')
  String? get created => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated')
  String? get updated => throw _privateConstructorUsedError;

  /// Serializes this AIProfileDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIProfileDtoCopyWith<AIProfileDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIProfileDtoCopyWith<$Res> {
  factory $AIProfileDtoCopyWith(
          AIProfileDto value, $Res Function(AIProfileDto) then) =
      _$AIProfileDtoCopyWithImpl<$Res, AIProfileDto>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'cuisine_preferences') List<String>? cuisinePreferences,
      @JsonKey(name: 'flavor_profile') List<String>? flavorProfile,
      @JsonKey(name: 'likes') List<String>? likes,
      @JsonKey(name: 'protein_preferences') List<String>? proteinPreferences,
      @JsonKey(name: 'budget_level') String? budgetLevel,
      @JsonKey(name: 'meal_prep_style') String? mealPrepStyle,
      @JsonKey(name: 'cooking_days_per_week') int? cookingDaysPerWeek,
      @JsonKey(name: 'health_goals') List<String>? healthGoals,
      @JsonKey(name: 'nutrition_focus') String? nutritionFocus,
      @JsonKey(name: 'equipment') List<String>? equipment,
      @JsonKey(name: 'learning_context') Map<String, dynamic>? learningContext,
      @JsonKey(name: 'onboarding_completed') bool? onboardingCompleted,
      @JsonKey(name: 'created') String? created,
      @JsonKey(name: 'updated') String? updated});
}

/// @nodoc
class _$AIProfileDtoCopyWithImpl<$Res, $Val extends AIProfileDto>
    implements $AIProfileDtoCopyWith<$Res> {
  _$AIProfileDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? cuisinePreferences = freezed,
    Object? flavorProfile = freezed,
    Object? likes = freezed,
    Object? proteinPreferences = freezed,
    Object? budgetLevel = freezed,
    Object? mealPrepStyle = freezed,
    Object? cookingDaysPerWeek = freezed,
    Object? healthGoals = freezed,
    Object? nutritionFocus = freezed,
    Object? equipment = freezed,
    Object? learningContext = freezed,
    Object? onboardingCompleted = freezed,
    Object? created = freezed,
    Object? updated = freezed,
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
      cuisinePreferences: freezed == cuisinePreferences
          ? _value.cuisinePreferences
          : cuisinePreferences // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      flavorProfile: freezed == flavorProfile
          ? _value.flavorProfile
          : flavorProfile // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      likes: freezed == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      proteinPreferences: freezed == proteinPreferences
          ? _value.proteinPreferences
          : proteinPreferences // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      budgetLevel: freezed == budgetLevel
          ? _value.budgetLevel
          : budgetLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      mealPrepStyle: freezed == mealPrepStyle
          ? _value.mealPrepStyle
          : mealPrepStyle // ignore: cast_nullable_to_non_nullable
              as String?,
      cookingDaysPerWeek: freezed == cookingDaysPerWeek
          ? _value.cookingDaysPerWeek
          : cookingDaysPerWeek // ignore: cast_nullable_to_non_nullable
              as int?,
      healthGoals: freezed == healthGoals
          ? _value.healthGoals
          : healthGoals // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      nutritionFocus: freezed == nutritionFocus
          ? _value.nutritionFocus
          : nutritionFocus // ignore: cast_nullable_to_non_nullable
              as String?,
      equipment: freezed == equipment
          ? _value.equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      learningContext: freezed == learningContext
          ? _value.learningContext
          : learningContext // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      onboardingCompleted: freezed == onboardingCompleted
          ? _value.onboardingCompleted
          : onboardingCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      created: freezed == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as String?,
      updated: freezed == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIProfileDtoImplCopyWith<$Res>
    implements $AIProfileDtoCopyWith<$Res> {
  factory _$$AIProfileDtoImplCopyWith(
          _$AIProfileDtoImpl value, $Res Function(_$AIProfileDtoImpl) then) =
      __$$AIProfileDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'cuisine_preferences') List<String>? cuisinePreferences,
      @JsonKey(name: 'flavor_profile') List<String>? flavorProfile,
      @JsonKey(name: 'likes') List<String>? likes,
      @JsonKey(name: 'protein_preferences') List<String>? proteinPreferences,
      @JsonKey(name: 'budget_level') String? budgetLevel,
      @JsonKey(name: 'meal_prep_style') String? mealPrepStyle,
      @JsonKey(name: 'cooking_days_per_week') int? cookingDaysPerWeek,
      @JsonKey(name: 'health_goals') List<String>? healthGoals,
      @JsonKey(name: 'nutrition_focus') String? nutritionFocus,
      @JsonKey(name: 'equipment') List<String>? equipment,
      @JsonKey(name: 'learning_context') Map<String, dynamic>? learningContext,
      @JsonKey(name: 'onboarding_completed') bool? onboardingCompleted,
      @JsonKey(name: 'created') String? created,
      @JsonKey(name: 'updated') String? updated});
}

/// @nodoc
class __$$AIProfileDtoImplCopyWithImpl<$Res>
    extends _$AIProfileDtoCopyWithImpl<$Res, _$AIProfileDtoImpl>
    implements _$$AIProfileDtoImplCopyWith<$Res> {
  __$$AIProfileDtoImplCopyWithImpl(
      _$AIProfileDtoImpl _value, $Res Function(_$AIProfileDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of AIProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? cuisinePreferences = freezed,
    Object? flavorProfile = freezed,
    Object? likes = freezed,
    Object? proteinPreferences = freezed,
    Object? budgetLevel = freezed,
    Object? mealPrepStyle = freezed,
    Object? cookingDaysPerWeek = freezed,
    Object? healthGoals = freezed,
    Object? nutritionFocus = freezed,
    Object? equipment = freezed,
    Object? learningContext = freezed,
    Object? onboardingCompleted = freezed,
    Object? created = freezed,
    Object? updated = freezed,
  }) {
    return _then(_$AIProfileDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      cuisinePreferences: freezed == cuisinePreferences
          ? _value._cuisinePreferences
          : cuisinePreferences // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      flavorProfile: freezed == flavorProfile
          ? _value._flavorProfile
          : flavorProfile // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      likes: freezed == likes
          ? _value._likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      proteinPreferences: freezed == proteinPreferences
          ? _value._proteinPreferences
          : proteinPreferences // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      budgetLevel: freezed == budgetLevel
          ? _value.budgetLevel
          : budgetLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      mealPrepStyle: freezed == mealPrepStyle
          ? _value.mealPrepStyle
          : mealPrepStyle // ignore: cast_nullable_to_non_nullable
              as String?,
      cookingDaysPerWeek: freezed == cookingDaysPerWeek
          ? _value.cookingDaysPerWeek
          : cookingDaysPerWeek // ignore: cast_nullable_to_non_nullable
              as int?,
      healthGoals: freezed == healthGoals
          ? _value._healthGoals
          : healthGoals // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      nutritionFocus: freezed == nutritionFocus
          ? _value.nutritionFocus
          : nutritionFocus // ignore: cast_nullable_to_non_nullable
              as String?,
      equipment: freezed == equipment
          ? _value._equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      learningContext: freezed == learningContext
          ? _value._learningContext
          : learningContext // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      onboardingCompleted: freezed == onboardingCompleted
          ? _value.onboardingCompleted
          : onboardingCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      created: freezed == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as String?,
      updated: freezed == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AIProfileDtoImpl extends _AIProfileDto {
  const _$AIProfileDtoImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'cuisine_preferences')
      final List<String>? cuisinePreferences,
      @JsonKey(name: 'flavor_profile') final List<String>? flavorProfile,
      @JsonKey(name: 'likes') final List<String>? likes,
      @JsonKey(name: 'protein_preferences')
      final List<String>? proteinPreferences,
      @JsonKey(name: 'budget_level') this.budgetLevel,
      @JsonKey(name: 'meal_prep_style') this.mealPrepStyle,
      @JsonKey(name: 'cooking_days_per_week') this.cookingDaysPerWeek,
      @JsonKey(name: 'health_goals') final List<String>? healthGoals,
      @JsonKey(name: 'nutrition_focus') this.nutritionFocus,
      @JsonKey(name: 'equipment') final List<String>? equipment,
      @JsonKey(name: 'learning_context')
      final Map<String, dynamic>? learningContext,
      @JsonKey(name: 'onboarding_completed') this.onboardingCompleted,
      @JsonKey(name: 'created') this.created,
      @JsonKey(name: 'updated') this.updated})
      : _cuisinePreferences = cuisinePreferences,
        _flavorProfile = flavorProfile,
        _likes = likes,
        _proteinPreferences = proteinPreferences,
        _healthGoals = healthGoals,
        _equipment = equipment,
        _learningContext = learningContext,
        super._();

  factory _$AIProfileDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIProfileDtoImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
// Culinary Preferences (JSON arrays stored as List<String>)
  final List<String>? _cuisinePreferences;
// Culinary Preferences (JSON arrays stored as List<String>)
  @override
  @JsonKey(name: 'cuisine_preferences')
  List<String>? get cuisinePreferences {
    final value = _cuisinePreferences;
    if (value == null) return null;
    if (_cuisinePreferences is EqualUnmodifiableListView)
      return _cuisinePreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _flavorProfile;
  @override
  @JsonKey(name: 'flavor_profile')
  List<String>? get flavorProfile {
    final value = _flavorProfile;
    if (value == null) return null;
    if (_flavorProfile is EqualUnmodifiableListView) return _flavorProfile;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _likes;
  @override
  @JsonKey(name: 'likes')
  List<String>? get likes {
    final value = _likes;
    if (value == null) return null;
    if (_likes is EqualUnmodifiableListView) return _likes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _proteinPreferences;
  @override
  @JsonKey(name: 'protein_preferences')
  List<String>? get proteinPreferences {
    final value = _proteinPreferences;
    if (value == null) return null;
    if (_proteinPreferences is EqualUnmodifiableListView)
      return _proteinPreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Lifestyle
  @override
  @JsonKey(name: 'budget_level')
  final String? budgetLevel;
  @override
  @JsonKey(name: 'meal_prep_style')
  final String? mealPrepStyle;
  @override
  @JsonKey(name: 'cooking_days_per_week')
  final int? cookingDaysPerWeek;
// Goals
  final List<String>? _healthGoals;
// Goals
  @override
  @JsonKey(name: 'health_goals')
  List<String>? get healthGoals {
    final value = _healthGoals;
    if (value == null) return null;
    if (_healthGoals is EqualUnmodifiableListView) return _healthGoals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'nutrition_focus')
  final String? nutritionFocus;
// Equipment
  final List<String>? _equipment;
// Equipment
  @override
  @JsonKey(name: 'equipment')
  List<String>? get equipment {
    final value = _equipment;
    if (value == null) return null;
    if (_equipment is EqualUnmodifiableListView) return _equipment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Learning Context (JSON object)
  final Map<String, dynamic>? _learningContext;
// Learning Context (JSON object)
  @override
  @JsonKey(name: 'learning_context')
  Map<String, dynamic>? get learningContext {
    final value = _learningContext;
    if (value == null) return null;
    if (_learningContext is EqualUnmodifiableMapView) return _learningContext;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Meta
  @override
  @JsonKey(name: 'onboarding_completed')
  final bool? onboardingCompleted;
  @override
  @JsonKey(name: 'created')
  final String? created;
  @override
  @JsonKey(name: 'updated')
  final String? updated;

  @override
  String toString() {
    return 'AIProfileDto(id: $id, userId: $userId, cuisinePreferences: $cuisinePreferences, flavorProfile: $flavorProfile, likes: $likes, proteinPreferences: $proteinPreferences, budgetLevel: $budgetLevel, mealPrepStyle: $mealPrepStyle, cookingDaysPerWeek: $cookingDaysPerWeek, healthGoals: $healthGoals, nutritionFocus: $nutritionFocus, equipment: $equipment, learningContext: $learningContext, onboardingCompleted: $onboardingCompleted, created: $created, updated: $updated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIProfileDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality()
                .equals(other._cuisinePreferences, _cuisinePreferences) &&
            const DeepCollectionEquality()
                .equals(other._flavorProfile, _flavorProfile) &&
            const DeepCollectionEquality().equals(other._likes, _likes) &&
            const DeepCollectionEquality()
                .equals(other._proteinPreferences, _proteinPreferences) &&
            (identical(other.budgetLevel, budgetLevel) ||
                other.budgetLevel == budgetLevel) &&
            (identical(other.mealPrepStyle, mealPrepStyle) ||
                other.mealPrepStyle == mealPrepStyle) &&
            (identical(other.cookingDaysPerWeek, cookingDaysPerWeek) ||
                other.cookingDaysPerWeek == cookingDaysPerWeek) &&
            const DeepCollectionEquality()
                .equals(other._healthGoals, _healthGoals) &&
            (identical(other.nutritionFocus, nutritionFocus) ||
                other.nutritionFocus == nutritionFocus) &&
            const DeepCollectionEquality()
                .equals(other._equipment, _equipment) &&
            const DeepCollectionEquality()
                .equals(other._learningContext, _learningContext) &&
            (identical(other.onboardingCompleted, onboardingCompleted) ||
                other.onboardingCompleted == onboardingCompleted) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.updated, updated) || other.updated == updated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      const DeepCollectionEquality().hash(_cuisinePreferences),
      const DeepCollectionEquality().hash(_flavorProfile),
      const DeepCollectionEquality().hash(_likes),
      const DeepCollectionEquality().hash(_proteinPreferences),
      budgetLevel,
      mealPrepStyle,
      cookingDaysPerWeek,
      const DeepCollectionEquality().hash(_healthGoals),
      nutritionFocus,
      const DeepCollectionEquality().hash(_equipment),
      const DeepCollectionEquality().hash(_learningContext),
      onboardingCompleted,
      created,
      updated);

  /// Create a copy of AIProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIProfileDtoImplCopyWith<_$AIProfileDtoImpl> get copyWith =>
      __$$AIProfileDtoImplCopyWithImpl<_$AIProfileDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIProfileDtoImplToJson(
      this,
    );
  }
}

abstract class _AIProfileDto extends AIProfileDto {
  const factory _AIProfileDto(
      {@JsonKey(name: 'id') required final String id,
      @JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'cuisine_preferences')
      final List<String>? cuisinePreferences,
      @JsonKey(name: 'flavor_profile') final List<String>? flavorProfile,
      @JsonKey(name: 'likes') final List<String>? likes,
      @JsonKey(name: 'protein_preferences')
      final List<String>? proteinPreferences,
      @JsonKey(name: 'budget_level') final String? budgetLevel,
      @JsonKey(name: 'meal_prep_style') final String? mealPrepStyle,
      @JsonKey(name: 'cooking_days_per_week') final int? cookingDaysPerWeek,
      @JsonKey(name: 'health_goals') final List<String>? healthGoals,
      @JsonKey(name: 'nutrition_focus') final String? nutritionFocus,
      @JsonKey(name: 'equipment') final List<String>? equipment,
      @JsonKey(name: 'learning_context')
      final Map<String, dynamic>? learningContext,
      @JsonKey(name: 'onboarding_completed') final bool? onboardingCompleted,
      @JsonKey(name: 'created') final String? created,
      @JsonKey(name: 'updated') final String? updated}) = _$AIProfileDtoImpl;
  const _AIProfileDto._() : super._();

  factory _AIProfileDto.fromJson(Map<String, dynamic> json) =
      _$AIProfileDtoImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String
      get userId; // Culinary Preferences (JSON arrays stored as List<String>)
  @override
  @JsonKey(name: 'cuisine_preferences')
  List<String>? get cuisinePreferences;
  @override
  @JsonKey(name: 'flavor_profile')
  List<String>? get flavorProfile;
  @override
  @JsonKey(name: 'likes')
  List<String>? get likes;
  @override
  @JsonKey(name: 'protein_preferences')
  List<String>? get proteinPreferences; // Lifestyle
  @override
  @JsonKey(name: 'budget_level')
  String? get budgetLevel;
  @override
  @JsonKey(name: 'meal_prep_style')
  String? get mealPrepStyle;
  @override
  @JsonKey(name: 'cooking_days_per_week')
  int? get cookingDaysPerWeek; // Goals
  @override
  @JsonKey(name: 'health_goals')
  List<String>? get healthGoals;
  @override
  @JsonKey(name: 'nutrition_focus')
  String? get nutritionFocus; // Equipment
  @override
  @JsonKey(name: 'equipment')
  List<String>? get equipment; // Learning Context (JSON object)
  @override
  @JsonKey(name: 'learning_context')
  Map<String, dynamic>? get learningContext; // Meta
  @override
  @JsonKey(name: 'onboarding_completed')
  bool? get onboardingCompleted;
  @override
  @JsonKey(name: 'created')
  String? get created;
  @override
  @JsonKey(name: 'updated')
  String? get updated;

  /// Create a copy of AIProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIProfileDtoImplCopyWith<_$AIProfileDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
