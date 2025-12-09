// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIProfileDtoImpl _$$AIProfileDtoImplFromJson(Map<String, dynamic> json) =>
    _$AIProfileDtoImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      cuisinePreferences: (json['cuisine_preferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      flavorProfile: (json['flavor_profile'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      likes:
          (json['likes'] as List<dynamic>?)?.map((e) => e as String).toList(),
      proteinPreferences: (json['protein_preferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      budgetLevel: json['budget_level'] as String?,
      mealPrepStyle: json['meal_prep_style'] as String?,
      cookingDaysPerWeek: (json['cooking_days_per_week'] as num?)?.toInt(),
      healthGoals: (json['health_goals'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      nutritionFocus: json['nutrition_focus'] as String?,
      equipment: (json['equipment'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      learningContext: json['learning_context'] as Map<String, dynamic>?,
      onboardingCompleted: json['onboarding_completed'] as bool?,
      created: json['created'] as String?,
      updated: json['updated'] as String?,
    );

Map<String, dynamic> _$$AIProfileDtoImplToJson(_$AIProfileDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'cuisine_preferences': instance.cuisinePreferences,
      'flavor_profile': instance.flavorProfile,
      'likes': instance.likes,
      'protein_preferences': instance.proteinPreferences,
      'budget_level': instance.budgetLevel,
      'meal_prep_style': instance.mealPrepStyle,
      'cooking_days_per_week': instance.cookingDaysPerWeek,
      'health_goals': instance.healthGoals,
      'nutrition_focus': instance.nutritionFocus,
      'equipment': instance.equipment,
      'learning_context': instance.learningContext,
      'onboarding_completed': instance.onboardingCompleted,
      'created': instance.created,
      'updated': instance.updated,
    };
