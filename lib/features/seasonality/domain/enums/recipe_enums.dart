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
  main('main', 'Hauptgericht', 'restaurant', '#5C6BC0'),
  side('side', 'Beilage', 'rice_bowl', '#26A69A'),
  dessert('dessert', 'Dessert', 'cake', '#EC407A'),
  snack('snack', 'Snack', 'cookie', '#FFA726'),
  breakfast('breakfast', 'Frühstück', 'free_breakfast', '#42A5F5'),
  soup('soup', 'Suppe', 'soup_kitchen', '#8D6E63'),
  salad('salad', 'Salat', 'eco', '#66BB6A');

  final String value;
  final String label;
  final String iconName;
  final String color;
  const RecipeCategory(this.value, this.label, this.iconName, this.color);

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
