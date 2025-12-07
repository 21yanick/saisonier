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
}
