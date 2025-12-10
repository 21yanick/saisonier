/// A recipe that the user wants to fix for specific days/slots.
/// The AI will not plan for these slots - they are already decided.
class FixedRecipe {
  final String recipeId;
  final String recipeTitle;
  final String slot; // 'breakfast', 'lunch', 'dinner'
  final bool everySelectedDay;
  final Set<DateTime>? specificDays; // only used if !everySelectedDay
  final int? cookTimeMin;
  final List<String> allergenWarnings;

  const FixedRecipe({
    required this.recipeId,
    required this.recipeTitle,
    required this.slot,
    this.everySelectedDay = true,
    this.specificDays,
    this.cookTimeMin,
    this.allergenWarnings = const [],
  });

  /// Convert to JSON for API request.
  Map<String, dynamic> toJson(List<DateTime> selectedDates) {
    final dates = everySelectedDay
        ? selectedDates
        : (specificDays?.toList() ?? []);

    return {
      'recipe_id': recipeId,
      'recipe_title': recipeTitle,
      'slot': slot,
      'dates': dates
          .map((d) =>
              '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}')
          .toList(),
    };
  }

  FixedRecipe copyWith({
    String? recipeId,
    String? recipeTitle,
    String? slot,
    bool? everySelectedDay,
    Set<DateTime>? specificDays,
    int? cookTimeMin,
    List<String>? allergenWarnings,
  }) {
    return FixedRecipe(
      recipeId: recipeId ?? this.recipeId,
      recipeTitle: recipeTitle ?? this.recipeTitle,
      slot: slot ?? this.slot,
      everySelectedDay: everySelectedDay ?? this.everySelectedDay,
      specificDays: specificDays ?? this.specificDays,
      cookTimeMin: cookTimeMin ?? this.cookTimeMin,
      allergenWarnings: allergenWarnings ?? this.allergenWarnings,
    );
  }
}
