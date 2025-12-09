// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AIProfile _$AIProfileFromJson(Map<String, dynamic> json) {
  return _AIProfile.fromJson(json);
}

/// @nodoc
mixin _$AIProfile {
  String get id => throw _privateConstructorUsedError;
  String get userId =>
      throw _privateConstructorUsedError; // === Culinary Preferences ===
  List<Cuisine> get cuisinePreferences => throw _privateConstructorUsedError;
  List<FlavorProfile> get flavorProfile => throw _privateConstructorUsedError;
  List<String> get likes => throw _privateConstructorUsedError;
  List<Protein> get proteinPreferences =>
      throw _privateConstructorUsedError; // === Lifestyle ===
  BudgetLevel get budgetLevel => throw _privateConstructorUsedError;
  MealPrepStyle get mealPrepStyle => throw _privateConstructorUsedError;
  int get cookingDaysPerWeek =>
      throw _privateConstructorUsedError; // === Goals (optional) ===
  List<HealthGoal> get healthGoals => throw _privateConstructorUsedError;
  NutritionFocus get nutritionFocus =>
      throw _privateConstructorUsedError; // === Equipment (optional) ===
  List<KitchenEquipment> get equipment =>
      throw _privateConstructorUsedError; // === AI Learning Context (implicit, updated by system) ===
  AILearningContext get learningContext =>
      throw _privateConstructorUsedError; // === Meta ===
  bool get onboardingCompleted => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AIProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIProfileCopyWith<AIProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIProfileCopyWith<$Res> {
  factory $AIProfileCopyWith(AIProfile value, $Res Function(AIProfile) then) =
      _$AIProfileCopyWithImpl<$Res, AIProfile>;
  @useResult
  $Res call(
      {String id,
      String userId,
      List<Cuisine> cuisinePreferences,
      List<FlavorProfile> flavorProfile,
      List<String> likes,
      List<Protein> proteinPreferences,
      BudgetLevel budgetLevel,
      MealPrepStyle mealPrepStyle,
      int cookingDaysPerWeek,
      List<HealthGoal> healthGoals,
      NutritionFocus nutritionFocus,
      List<KitchenEquipment> equipment,
      AILearningContext learningContext,
      bool onboardingCompleted,
      DateTime? createdAt,
      DateTime? updatedAt});

  $AILearningContextCopyWith<$Res> get learningContext;
}

/// @nodoc
class _$AIProfileCopyWithImpl<$Res, $Val extends AIProfile>
    implements $AIProfileCopyWith<$Res> {
  _$AIProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? cuisinePreferences = null,
    Object? flavorProfile = null,
    Object? likes = null,
    Object? proteinPreferences = null,
    Object? budgetLevel = null,
    Object? mealPrepStyle = null,
    Object? cookingDaysPerWeek = null,
    Object? healthGoals = null,
    Object? nutritionFocus = null,
    Object? equipment = null,
    Object? learningContext = null,
    Object? onboardingCompleted = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      cuisinePreferences: null == cuisinePreferences
          ? _value.cuisinePreferences
          : cuisinePreferences // ignore: cast_nullable_to_non_nullable
              as List<Cuisine>,
      flavorProfile: null == flavorProfile
          ? _value.flavorProfile
          : flavorProfile // ignore: cast_nullable_to_non_nullable
              as List<FlavorProfile>,
      likes: null == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      proteinPreferences: null == proteinPreferences
          ? _value.proteinPreferences
          : proteinPreferences // ignore: cast_nullable_to_non_nullable
              as List<Protein>,
      budgetLevel: null == budgetLevel
          ? _value.budgetLevel
          : budgetLevel // ignore: cast_nullable_to_non_nullable
              as BudgetLevel,
      mealPrepStyle: null == mealPrepStyle
          ? _value.mealPrepStyle
          : mealPrepStyle // ignore: cast_nullable_to_non_nullable
              as MealPrepStyle,
      cookingDaysPerWeek: null == cookingDaysPerWeek
          ? _value.cookingDaysPerWeek
          : cookingDaysPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
      healthGoals: null == healthGoals
          ? _value.healthGoals
          : healthGoals // ignore: cast_nullable_to_non_nullable
              as List<HealthGoal>,
      nutritionFocus: null == nutritionFocus
          ? _value.nutritionFocus
          : nutritionFocus // ignore: cast_nullable_to_non_nullable
              as NutritionFocus,
      equipment: null == equipment
          ? _value.equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as List<KitchenEquipment>,
      learningContext: null == learningContext
          ? _value.learningContext
          : learningContext // ignore: cast_nullable_to_non_nullable
              as AILearningContext,
      onboardingCompleted: null == onboardingCompleted
          ? _value.onboardingCompleted
          : onboardingCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
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

  /// Create a copy of AIProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AILearningContextCopyWith<$Res> get learningContext {
    return $AILearningContextCopyWith<$Res>(_value.learningContext, (value) {
      return _then(_value.copyWith(learningContext: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AIProfileImplCopyWith<$Res>
    implements $AIProfileCopyWith<$Res> {
  factory _$$AIProfileImplCopyWith(
          _$AIProfileImpl value, $Res Function(_$AIProfileImpl) then) =
      __$$AIProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      List<Cuisine> cuisinePreferences,
      List<FlavorProfile> flavorProfile,
      List<String> likes,
      List<Protein> proteinPreferences,
      BudgetLevel budgetLevel,
      MealPrepStyle mealPrepStyle,
      int cookingDaysPerWeek,
      List<HealthGoal> healthGoals,
      NutritionFocus nutritionFocus,
      List<KitchenEquipment> equipment,
      AILearningContext learningContext,
      bool onboardingCompleted,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $AILearningContextCopyWith<$Res> get learningContext;
}

/// @nodoc
class __$$AIProfileImplCopyWithImpl<$Res>
    extends _$AIProfileCopyWithImpl<$Res, _$AIProfileImpl>
    implements _$$AIProfileImplCopyWith<$Res> {
  __$$AIProfileImplCopyWithImpl(
      _$AIProfileImpl _value, $Res Function(_$AIProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of AIProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? cuisinePreferences = null,
    Object? flavorProfile = null,
    Object? likes = null,
    Object? proteinPreferences = null,
    Object? budgetLevel = null,
    Object? mealPrepStyle = null,
    Object? cookingDaysPerWeek = null,
    Object? healthGoals = null,
    Object? nutritionFocus = null,
    Object? equipment = null,
    Object? learningContext = null,
    Object? onboardingCompleted = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$AIProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      cuisinePreferences: null == cuisinePreferences
          ? _value._cuisinePreferences
          : cuisinePreferences // ignore: cast_nullable_to_non_nullable
              as List<Cuisine>,
      flavorProfile: null == flavorProfile
          ? _value._flavorProfile
          : flavorProfile // ignore: cast_nullable_to_non_nullable
              as List<FlavorProfile>,
      likes: null == likes
          ? _value._likes
          : likes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      proteinPreferences: null == proteinPreferences
          ? _value._proteinPreferences
          : proteinPreferences // ignore: cast_nullable_to_non_nullable
              as List<Protein>,
      budgetLevel: null == budgetLevel
          ? _value.budgetLevel
          : budgetLevel // ignore: cast_nullable_to_non_nullable
              as BudgetLevel,
      mealPrepStyle: null == mealPrepStyle
          ? _value.mealPrepStyle
          : mealPrepStyle // ignore: cast_nullable_to_non_nullable
              as MealPrepStyle,
      cookingDaysPerWeek: null == cookingDaysPerWeek
          ? _value.cookingDaysPerWeek
          : cookingDaysPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
      healthGoals: null == healthGoals
          ? _value._healthGoals
          : healthGoals // ignore: cast_nullable_to_non_nullable
              as List<HealthGoal>,
      nutritionFocus: null == nutritionFocus
          ? _value.nutritionFocus
          : nutritionFocus // ignore: cast_nullable_to_non_nullable
              as NutritionFocus,
      equipment: null == equipment
          ? _value._equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as List<KitchenEquipment>,
      learningContext: null == learningContext
          ? _value.learningContext
          : learningContext // ignore: cast_nullable_to_non_nullable
              as AILearningContext,
      onboardingCompleted: null == onboardingCompleted
          ? _value.onboardingCompleted
          : onboardingCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$AIProfileImpl implements _AIProfile {
  const _$AIProfileImpl(
      {required this.id,
      required this.userId,
      final List<Cuisine> cuisinePreferences = const [],
      final List<FlavorProfile> flavorProfile = const [],
      final List<String> likes = const [],
      final List<Protein> proteinPreferences = const [],
      this.budgetLevel = BudgetLevel.normal,
      this.mealPrepStyle = MealPrepStyle.mixed,
      this.cookingDaysPerWeek = 4,
      final List<HealthGoal> healthGoals = const [],
      this.nutritionFocus = NutritionFocus.balanced,
      final List<KitchenEquipment> equipment = const [],
      this.learningContext = const AILearningContext(),
      this.onboardingCompleted = false,
      this.createdAt,
      this.updatedAt})
      : _cuisinePreferences = cuisinePreferences,
        _flavorProfile = flavorProfile,
        _likes = likes,
        _proteinPreferences = proteinPreferences,
        _healthGoals = healthGoals,
        _equipment = equipment;

  factory _$AIProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
// === Culinary Preferences ===
  final List<Cuisine> _cuisinePreferences;
// === Culinary Preferences ===
  @override
  @JsonKey()
  List<Cuisine> get cuisinePreferences {
    if (_cuisinePreferences is EqualUnmodifiableListView)
      return _cuisinePreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cuisinePreferences);
  }

  final List<FlavorProfile> _flavorProfile;
  @override
  @JsonKey()
  List<FlavorProfile> get flavorProfile {
    if (_flavorProfile is EqualUnmodifiableListView) return _flavorProfile;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_flavorProfile);
  }

  final List<String> _likes;
  @override
  @JsonKey()
  List<String> get likes {
    if (_likes is EqualUnmodifiableListView) return _likes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_likes);
  }

  final List<Protein> _proteinPreferences;
  @override
  @JsonKey()
  List<Protein> get proteinPreferences {
    if (_proteinPreferences is EqualUnmodifiableListView)
      return _proteinPreferences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_proteinPreferences);
  }

// === Lifestyle ===
  @override
  @JsonKey()
  final BudgetLevel budgetLevel;
  @override
  @JsonKey()
  final MealPrepStyle mealPrepStyle;
  @override
  @JsonKey()
  final int cookingDaysPerWeek;
// === Goals (optional) ===
  final List<HealthGoal> _healthGoals;
// === Goals (optional) ===
  @override
  @JsonKey()
  List<HealthGoal> get healthGoals {
    if (_healthGoals is EqualUnmodifiableListView) return _healthGoals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_healthGoals);
  }

  @override
  @JsonKey()
  final NutritionFocus nutritionFocus;
// === Equipment (optional) ===
  final List<KitchenEquipment> _equipment;
// === Equipment (optional) ===
  @override
  @JsonKey()
  List<KitchenEquipment> get equipment {
    if (_equipment is EqualUnmodifiableListView) return _equipment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equipment);
  }

// === AI Learning Context (implicit, updated by system) ===
  @override
  @JsonKey()
  final AILearningContext learningContext;
// === Meta ===
  @override
  @JsonKey()
  final bool onboardingCompleted;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'AIProfile(id: $id, userId: $userId, cuisinePreferences: $cuisinePreferences, flavorProfile: $flavorProfile, likes: $likes, proteinPreferences: $proteinPreferences, budgetLevel: $budgetLevel, mealPrepStyle: $mealPrepStyle, cookingDaysPerWeek: $cookingDaysPerWeek, healthGoals: $healthGoals, nutritionFocus: $nutritionFocus, equipment: $equipment, learningContext: $learningContext, onboardingCompleted: $onboardingCompleted, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIProfileImpl &&
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
            (identical(other.learningContext, learningContext) ||
                other.learningContext == learningContext) &&
            (identical(other.onboardingCompleted, onboardingCompleted) ||
                other.onboardingCompleted == onboardingCompleted) &&
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
      learningContext,
      onboardingCompleted,
      createdAt,
      updatedAt);

  /// Create a copy of AIProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIProfileImplCopyWith<_$AIProfileImpl> get copyWith =>
      __$$AIProfileImplCopyWithImpl<_$AIProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIProfileImplToJson(
      this,
    );
  }
}

abstract class _AIProfile implements AIProfile {
  const factory _AIProfile(
      {required final String id,
      required final String userId,
      final List<Cuisine> cuisinePreferences,
      final List<FlavorProfile> flavorProfile,
      final List<String> likes,
      final List<Protein> proteinPreferences,
      final BudgetLevel budgetLevel,
      final MealPrepStyle mealPrepStyle,
      final int cookingDaysPerWeek,
      final List<HealthGoal> healthGoals,
      final NutritionFocus nutritionFocus,
      final List<KitchenEquipment> equipment,
      final AILearningContext learningContext,
      final bool onboardingCompleted,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$AIProfileImpl;

  factory _AIProfile.fromJson(Map<String, dynamic> json) =
      _$AIProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get userId; // === Culinary Preferences ===
  @override
  List<Cuisine> get cuisinePreferences;
  @override
  List<FlavorProfile> get flavorProfile;
  @override
  List<String> get likes;
  @override
  List<Protein> get proteinPreferences; // === Lifestyle ===
  @override
  BudgetLevel get budgetLevel;
  @override
  MealPrepStyle get mealPrepStyle;
  @override
  int get cookingDaysPerWeek; // === Goals (optional) ===
  @override
  List<HealthGoal> get healthGoals;
  @override
  NutritionFocus get nutritionFocus; // === Equipment (optional) ===
  @override
  List<KitchenEquipment>
      get equipment; // === AI Learning Context (implicit, updated by system) ===
  @override
  AILearningContext get learningContext; // === Meta ===
  @override
  bool get onboardingCompleted;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of AIProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIProfileImplCopyWith<_$AIProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
