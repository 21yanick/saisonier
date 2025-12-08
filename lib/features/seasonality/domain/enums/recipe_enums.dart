/// Source of a recipe
enum RecipeSource {
  curated,
  user;

  String get label => switch (this) {
        RecipeSource.curated => 'Kuratiert',
        RecipeSource.user => 'Eigenes Rezept',
      };
}

/// Difficulty level of a recipe
enum RecipeDifficulty {
  easy,
  medium,
  hard;

  String get label => switch (this) {
        RecipeDifficulty.easy => 'Einfach',
        RecipeDifficulty.medium => 'Mittel',
        RecipeDifficulty.hard => 'Anspruchsvoll',
      };

  /// Farbe für Difficulty-Badge
  String get color => switch (this) {
        RecipeDifficulty.easy => '#4CAF50', // Grün
        RecipeDifficulty.medium => '#FF9800', // Orange
        RecipeDifficulty.hard => '#F44336', // Rot
      };
}

/// Category of a recipe
enum RecipeCategory {
  main('main', 'Hauptgericht'),
  side('side', 'Beilage'),
  dessert('dessert', 'Dessert'),
  snack('snack', 'Snack'),
  breakfast('breakfast', 'Frühstück'),
  soup('soup', 'Suppe'),
  salad('salad', 'Salat');

  final String value;
  final String label;
  const RecipeCategory(this.value, this.label);

  static RecipeCategory? fromValue(String? value) {
    if (value == null) return null;
    return RecipeCategory.values.cast<RecipeCategory?>().firstWhere(
          (e) => e?.value == value,
          orElse: () => null,
        );
  }
}

/// Verfügbare Tags für Rezepte
const availableTags = [
  'schnell',
  'günstig',
  'meal-prep',
  'one-pot',
  'kinderfreundlich',
  'party',
  'gesund',
  'comfort-food',
];
