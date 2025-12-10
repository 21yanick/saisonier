import 'package:freezed_annotation/freezed_annotation.dart';

part 'refine_meal_response.freezed.dart';
part 'refine_meal_response.g.dart';

/// Response from meal refinement conversation.
@freezed
class RefineMealResponse with _$RefineMealResponse {
  const factory RefineMealResponse({
    required String response,
    required List<MealSuggestion> suggestions,
  }) = _RefineMealResponse;

  factory RefineMealResponse.fromJson(Map<String, dynamic> json) =>
      _$RefineMealResponseFromJson(json);
}

/// A single meal suggestion from refinement.
@freezed
class MealSuggestion with _$MealSuggestion {
  const factory MealSuggestion({
    String? recipeId,
    required String title,
    required String reasoning,
    int? cookTimeMin,
    Map<String, dynamic>? recipe,
  }) = _MealSuggestion;

  factory MealSuggestion.fromJson(Map<String, dynamic> json) =>
      _$MealSuggestionFromJson(json);
}
