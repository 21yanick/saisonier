import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'ai_profile_dto.freezed.dart';
part 'ai_profile_dto.g.dart';

/// DTO for ai_profiles PocketBase collection.
/// Maps snake_case PocketBase fields to camelCase Dart fields.
@freezed
class AIProfileDto with _$AIProfileDto {
  const AIProfileDto._();

  const factory AIProfileDto({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'user_id') required String userId,

    // Culinary Preferences (JSON arrays stored as List<String>)
    @JsonKey(name: 'cuisine_preferences') List<String>? cuisinePreferences,
    @JsonKey(name: 'flavor_profile') List<String>? flavorProfile,
    @JsonKey(name: 'likes') List<String>? likes,
    @JsonKey(name: 'protein_preferences') List<String>? proteinPreferences,

    // Lifestyle
    @JsonKey(name: 'budget_level') String? budgetLevel,
    @JsonKey(name: 'meal_prep_style') String? mealPrepStyle,
    @JsonKey(name: 'cooking_days_per_week') int? cookingDaysPerWeek,

    // Goals
    @JsonKey(name: 'health_goals') List<String>? healthGoals,
    @JsonKey(name: 'nutrition_focus') String? nutritionFocus,

    // Equipment
    @JsonKey(name: 'equipment') List<String>? equipment,

    // Learning Context (JSON object)
    @JsonKey(name: 'learning_context') Map<String, dynamic>? learningContext,

    // Meta
    @JsonKey(name: 'onboarding_completed') bool? onboardingCompleted,
    @JsonKey(name: 'created') String? created,
    @JsonKey(name: 'updated') String? updated,
  }) = _AIProfileDto;

  factory AIProfileDto.fromJson(Map<String, dynamic> json) =>
      _$AIProfileDtoFromJson(json);

  factory AIProfileDto.fromRecord(RecordModel record) {
    return AIProfileDto.fromJson(record.toJson());
  }
}
