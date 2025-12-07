
enum Allergen {
  gluten,
  lactose,
  nuts,
  eggs,
  soy,
  shellfish,
  fish;

  String get label {
    switch (this) {
      case Allergen.gluten:
        return 'Gluten';
      case Allergen.lactose:
        return 'Laktose';
      case Allergen.nuts:
        return 'Nüsse';
      case Allergen.eggs:
        return 'Eier';
      case Allergen.soy:
        return 'Soja';
      case Allergen.shellfish:
        return 'Krustentiere';
      case Allergen.fish:
        return 'Fisch';
    }
  }
}

enum DietType {
  omnivore,
  vegetarian,
  vegan,
  pescatarian,
  flexitarian;

  String get label {
    switch (this) {
      case DietType.omnivore:
        return 'Allesesser';
      case DietType.vegetarian:
        return 'Vegetarisch';
      case DietType.vegan:
        return 'Vegan';
      case DietType.pescatarian:
        return 'Pescetarisch';
      case DietType.flexitarian:
        return 'Flexitarisch';
    }
  }
}

enum CookingSkill {
  beginner,
  intermediate,
  advanced;

  String get label {
    switch (this) {
      case CookingSkill.beginner:
        return 'Anfänger';
      case CookingSkill.intermediate:
        return 'Fortgeschritten';
      case CookingSkill.advanced:
        return 'Profi';
    }
  }
}
