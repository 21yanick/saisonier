// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIProfileImpl _$$AIProfileImplFromJson(Map<String, dynamic> json) =>
    _$AIProfileImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      cuisinePreferences: (json['cuisinePreferences'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$CuisineEnumMap, e))
              .toList() ??
          const [],
      flavorProfile: (json['flavorProfile'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$FlavorProfileEnumMap, e))
              .toList() ??
          const [],
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      proteinPreferences: (json['proteinPreferences'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ProteinEnumMap, e))
              .toList() ??
          const [],
      budgetLevel:
          $enumDecodeNullable(_$BudgetLevelEnumMap, json['budgetLevel']) ??
              BudgetLevel.normal,
      mealPrepStyle:
          $enumDecodeNullable(_$MealPrepStyleEnumMap, json['mealPrepStyle']) ??
              MealPrepStyle.mixed,
      cookingDaysPerWeek: (json['cookingDaysPerWeek'] as num?)?.toInt() ?? 4,
      healthGoals: (json['healthGoals'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$HealthGoalEnumMap, e))
              .toList() ??
          const [],
      nutritionFocus: $enumDecodeNullable(
              _$NutritionFocusEnumMap, json['nutritionFocus']) ??
          NutritionFocus.balanced,
      equipment: (json['equipment'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$KitchenEquipmentEnumMap, e))
              .toList() ??
          const [],
      learningContext: json['learningContext'] == null
          ? const AILearningContext()
          : AILearningContext.fromJson(
              json['learningContext'] as Map<String, dynamic>),
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$AIProfileImplToJson(_$AIProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'cuisinePreferences':
          instance.cuisinePreferences.map((e) => _$CuisineEnumMap[e]!).toList(),
      'flavorProfile': instance.flavorProfile
          .map((e) => _$FlavorProfileEnumMap[e]!)
          .toList(),
      'likes': instance.likes,
      'proteinPreferences':
          instance.proteinPreferences.map((e) => _$ProteinEnumMap[e]!).toList(),
      'budgetLevel': _$BudgetLevelEnumMap[instance.budgetLevel]!,
      'mealPrepStyle': _$MealPrepStyleEnumMap[instance.mealPrepStyle]!,
      'cookingDaysPerWeek': instance.cookingDaysPerWeek,
      'healthGoals':
          instance.healthGoals.map((e) => _$HealthGoalEnumMap[e]!).toList(),
      'nutritionFocus': _$NutritionFocusEnumMap[instance.nutritionFocus]!,
      'equipment':
          instance.equipment.map((e) => _$KitchenEquipmentEnumMap[e]!).toList(),
      'learningContext': instance.learningContext,
      'onboardingCompleted': instance.onboardingCompleted,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$CuisineEnumMap = {
  Cuisine.italian: 'italian',
  Cuisine.asian: 'asian',
  Cuisine.swiss: 'swiss',
  Cuisine.mexican: 'mexican',
  Cuisine.indian: 'indian',
  Cuisine.mediterranean: 'mediterranean',
  Cuisine.middleEastern: 'middleEastern',
  Cuisine.french: 'french',
  Cuisine.american: 'american',
};

const _$FlavorProfileEnumMap = {
  FlavorProfile.spicy: 'spicy',
  FlavorProfile.mild: 'mild',
  FlavorProfile.creamy: 'creamy',
  FlavorProfile.crispy: 'crispy',
  FlavorProfile.hearty: 'hearty',
  FlavorProfile.fresh: 'fresh',
  FlavorProfile.umami: 'umami',
};

const _$ProteinEnumMap = {
  Protein.chicken: 'chicken',
  Protein.beef: 'beef',
  Protein.pork: 'pork',
  Protein.fish: 'fish',
  Protein.seafood: 'seafood',
  Protein.tofu: 'tofu',
  Protein.legumes: 'legumes',
  Protein.eggs: 'eggs',
};

const _$BudgetLevelEnumMap = {
  BudgetLevel.budget: 'budget',
  BudgetLevel.normal: 'normal',
  BudgetLevel.premium: 'premium',
};

const _$MealPrepStyleEnumMap = {
  MealPrepStyle.daily: 'daily',
  MealPrepStyle.mealPrep: 'mealPrep',
  MealPrepStyle.mixed: 'mixed',
};

const _$HealthGoalEnumMap = {
  HealthGoal.loseWeight: 'loseWeight',
  HealthGoal.gainMuscle: 'gainMuscle',
  HealthGoal.moreEnergy: 'moreEnergy',
  HealthGoal.eatHealthy: 'eatHealthy',
  HealthGoal.moreVegetables: 'moreVegetables',
  HealthGoal.immuneSystem: 'immuneSystem',
  HealthGoal.betterDigestion: 'betterDigestion',
  HealthGoal.none: 'none',
};

const _$NutritionFocusEnumMap = {
  NutritionFocus.highProtein: 'highProtein',
  NutritionFocus.lowCarb: 'lowCarb',
  NutritionFocus.balanced: 'balanced',
  NutritionFocus.vegetableFocus: 'vegetableFocus',
  NutritionFocus.lowSugar: 'lowSugar',
  NutritionFocus.wholesome: 'wholesome',
};

const _$KitchenEquipmentEnumMap = {
  KitchenEquipment.oven: 'oven',
  KitchenEquipment.mixer: 'mixer',
  KitchenEquipment.airfryer: 'airfryer',
  KitchenEquipment.steamCooker: 'steamCooker',
  KitchenEquipment.instantPot: 'instantPot',
  KitchenEquipment.grill: 'grill',
  KitchenEquipment.thermomix: 'thermomix',
  KitchenEquipment.wok: 'wok',
  KitchenEquipment.slowCooker: 'slowCooker',
  KitchenEquipment.raclette: 'raclette',
  KitchenEquipment.fondue: 'fondue',
};
