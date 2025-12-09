import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:saisonier/features/ai/domain/enums/ai_enums.dart';
import 'package:saisonier/features/ai/domain/models/ai_learning_context.dart';

part 'ai_profile.freezed.dart';
part 'ai_profile.g.dart';

/// Extended profile for AI personalization.
/// Only exists for Premium/Pro users.
/// Created during Premium Onboarding flow.
@freezed
class AIProfile with _$AIProfile {
  const factory AIProfile({
    required String id,
    required String userId,

    // === Culinary Preferences ===
    @Default([]) List<Cuisine> cuisinePreferences,
    @Default([]) List<FlavorProfile> flavorProfile,
    @Default([]) List<String> likes,
    @Default([]) List<Protein> proteinPreferences,

    // === Lifestyle ===
    @Default(BudgetLevel.normal) BudgetLevel budgetLevel,
    @Default(MealPrepStyle.mixed) MealPrepStyle mealPrepStyle,
    @Default(4) int cookingDaysPerWeek,

    // === Goals (optional) ===
    @Default([]) List<HealthGoal> healthGoals,
    @Default(NutritionFocus.balanced) NutritionFocus nutritionFocus,

    // === Equipment (optional) ===
    @Default([]) List<KitchenEquipment> equipment,

    // === AI Learning Context (implicit, updated by system) ===
    @Default(AILearningContext()) AILearningContext learningContext,

    // === Meta ===
    @Default(false) bool onboardingCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AIProfile;

  factory AIProfile.fromJson(Map<String, dynamic> json) =>
      _$AIProfileFromJson(json);
}
