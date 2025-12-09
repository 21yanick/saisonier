import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_learning_context.freezed.dart';
part 'ai_learning_context.g.dart';

/// Automatically tracked user behavior for AI personalization.
/// Updated implicitly by the system based on user actions.
@freezed
class AILearningContext with _$AILearningContext {
  const factory AILearningContext({
    /// Derived from favorites & usage - most used ingredients
    @Default([]) List<String> topIngredients,

    /// Category usage frequency: {"Suppe": 5, "Pasta": 8}
    @Default({}) Map<String, int> categoryUsage,

    /// Ingredients/recipes the user accepted from AI suggestions
    @Default([]) List<String> acceptedSuggestions,

    /// Ingredients/recipes the user rejected or regenerated
    @Default([]) List<String> rejectedSuggestions,

    /// Days user typically cooks: [1,2,3,5] = Mo,Di,Mi,Fr
    @Default([]) List<int> activeCookingDays,

    /// Average servings per meal
    @Default(2.0) double avgServings,

    /// Total AI requests made
    @Default(0) int totalAIRequests,

    /// Last AI interaction timestamp
    DateTime? lastAIInteraction,
  }) = _AILearningContext;

  factory AILearningContext.fromJson(Map<String, dynamic> json) =>
      _$AILearningContextFromJson(json);
}
