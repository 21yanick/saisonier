// AI-specific enums for Premium user preferences.
// Used in ai_profiles collection and AI context building.

enum Cuisine {
  italian,
  asian,
  swiss,
  mexican,
  indian,
  mediterranean,
  middleEastern,
  french,
  american;

  String get label {
    switch (this) {
      case Cuisine.italian:
        return 'Italienisch';
      case Cuisine.asian:
        return 'Asiatisch';
      case Cuisine.swiss:
        return 'Schweizer';
      case Cuisine.mexican:
        return 'Mexikanisch';
      case Cuisine.indian:
        return 'Indisch';
      case Cuisine.mediterranean:
        return 'Mediterran';
      case Cuisine.middleEastern:
        return 'Nahöstlich';
      case Cuisine.french:
        return 'Französisch';
      case Cuisine.american:
        return 'Amerikanisch';
    }
  }
}

enum FlavorProfile {
  spicy,
  mild,
  creamy,
  crispy,
  hearty,
  fresh,
  umami;

  String get label {
    switch (this) {
      case FlavorProfile.spicy:
        return 'Würzig';
      case FlavorProfile.mild:
        return 'Mild';
      case FlavorProfile.creamy:
        return 'Cremig';
      case FlavorProfile.crispy:
        return 'Knusprig';
      case FlavorProfile.hearty:
        return 'Herzhaft';
      case FlavorProfile.fresh:
        return 'Frisch';
      case FlavorProfile.umami:
        return 'Umami';
    }
  }
}

enum Protein {
  chicken,
  beef,
  pork,
  fish,
  seafood,
  tofu,
  legumes,
  eggs;

  String get label {
    switch (this) {
      case Protein.chicken:
        return 'Poulet';
      case Protein.beef:
        return 'Rind';
      case Protein.pork:
        return 'Schwein';
      case Protein.fish:
        return 'Fisch';
      case Protein.seafood:
        return 'Meeresfrüchte';
      case Protein.tofu:
        return 'Tofu';
      case Protein.legumes:
        return 'Hülsenfrüchte';
      case Protein.eggs:
        return 'Eier';
    }
  }
}

enum BudgetLevel {
  budget,
  normal,
  premium;

  String get label {
    switch (this) {
      case BudgetLevel.budget:
        return 'Sparsam';
      case BudgetLevel.normal:
        return 'Normal';
      case BudgetLevel.premium:
        return 'Premium';
    }
  }
}

enum MealPrepStyle {
  daily,
  mealPrep,
  mixed;

  String get label {
    switch (this) {
      case MealPrepStyle.daily:
        return 'Täglich frisch';
      case MealPrepStyle.mealPrep:
        return 'Meal Prep';
      case MealPrepStyle.mixed:
        return 'Mix';
    }
  }
}

enum HealthGoal {
  loseWeight,
  gainMuscle,
  moreEnergy,
  eatHealthy,
  moreVegetables,
  immuneSystem,
  betterDigestion,
  none;

  String get label {
    switch (this) {
      case HealthGoal.loseWeight:
        return 'Abnehmen';
      case HealthGoal.gainMuscle:
        return 'Muskelaufbau';
      case HealthGoal.moreEnergy:
        return 'Mehr Energie';
      case HealthGoal.eatHealthy:
        return 'Gesund essen';
      case HealthGoal.moreVegetables:
        return 'Mehr Gemüse essen';
      case HealthGoal.immuneSystem:
        return 'Immunsystem stärken';
      case HealthGoal.betterDigestion:
        return 'Bessere Verdauung';
      case HealthGoal.none:
        return 'Keine';
    }
  }
}

enum NutritionFocus {
  highProtein,
  lowCarb,
  balanced,
  vegetableFocus,
  lowSugar,
  wholesome;

  String get label {
    switch (this) {
      case NutritionFocus.highProtein:
        return 'High Protein';
      case NutritionFocus.lowCarb:
        return 'Low Carb';
      case NutritionFocus.balanced:
        return 'Ausgewogen';
      case NutritionFocus.vegetableFocus:
        return 'Viel Gemüse';
      case NutritionFocus.lowSugar:
        return 'Wenig Zucker';
      case NutritionFocus.wholesome:
        return 'Vollwertig';
    }
  }
}

enum KitchenEquipment {
  oven,
  mixer,
  airfryer,
  steamCooker,
  instantPot,
  grill,
  thermomix,
  wok,
  slowCooker,
  raclette,
  fondue;

  String get label {
    switch (this) {
      case KitchenEquipment.oven:
        return 'Backofen';
      case KitchenEquipment.mixer:
        return 'Standmixer';
      case KitchenEquipment.airfryer:
        return 'Airfryer';
      case KitchenEquipment.steamCooker:
        return 'Dampfgarer';
      case KitchenEquipment.instantPot:
        return 'Instant Pot';
      case KitchenEquipment.grill:
        return 'Grill';
      case KitchenEquipment.thermomix:
        return 'Thermomix';
      case KitchenEquipment.wok:
        return 'Wok';
      case KitchenEquipment.slowCooker:
        return 'Slow Cooker';
      case KitchenEquipment.raclette:
        return 'Raclette';
      case KitchenEquipment.fondue:
        return 'Fondue-Set';
    }
  }
}

/// Recipe style for AI generation.
enum RecipeStyle {
  comfort,
  quick,
  healthy,
  festive,
  onePot,
  budget;

  String get label {
    switch (this) {
      case RecipeStyle.comfort:
        return 'Comfort Food';
      case RecipeStyle.quick:
        return 'Schnell & Einfach';
      case RecipeStyle.healthy:
        return 'Gesund & Leicht';
      case RecipeStyle.festive:
        return 'Festlich';
      case RecipeStyle.onePot:
        return 'One-Pot';
      case RecipeStyle.budget:
        return 'Budget-freundlich';
    }
  }

  String get emoji {
    switch (this) {
      case RecipeStyle.comfort:
        return '🍲';
      case RecipeStyle.quick:
        return '⚡';
      case RecipeStyle.healthy:
        return '🥗';
      case RecipeStyle.festive:
        return '🎉';
      case RecipeStyle.onePot:
        return '🍳';
      case RecipeStyle.budget:
        return '💰';
    }
  }

  String get description {
    switch (this) {
      case RecipeStyle.comfort:
        return 'Herzhaft & wärmend';
      case RecipeStyle.quick:
        return 'Max. 30 Minuten';
      case RecipeStyle.healthy:
        return 'Kalorienarm & frisch';
      case RecipeStyle.festive:
        return 'Für besondere Anlässe';
      case RecipeStyle.onePot:
        return 'Wenig Abwasch';
      case RecipeStyle.budget:
        return 'Günstige Zutaten';
    }
  }
}

/// Recipe category for AI generation.
enum RecipeCategory {
  main,
  side,
  soup,
  salad,
  dessert,
  snack;

  String get label {
    switch (this) {
      case RecipeCategory.main:
        return 'Hauptgericht';
      case RecipeCategory.side:
        return 'Beilage';
      case RecipeCategory.soup:
        return 'Suppe';
      case RecipeCategory.salad:
        return 'Salat';
      case RecipeCategory.dessert:
        return 'Dessert';
      case RecipeCategory.snack:
        return 'Snack';
    }
  }
}

/// Inspiration chip options for quick recipe generation.
enum RecipeInspiration {
  surprise,
  quick,
  onePot,
  kidFriendly,
  forGuests;

  String get label {
    switch (this) {
      case RecipeInspiration.surprise:
        return 'Überrasch mich';
      case RecipeInspiration.quick:
        return 'Schnell';
      case RecipeInspiration.onePot:
        return 'One-Pot';
      case RecipeInspiration.kidFriendly:
        return 'Kinderfreundlich';
      case RecipeInspiration.forGuests:
        return 'Für Gäste';
    }
  }

  String get emoji {
    switch (this) {
      case RecipeInspiration.surprise:
        return '🎲';
      case RecipeInspiration.quick:
        return '⚡';
      case RecipeInspiration.onePot:
        return '🍲';
      case RecipeInspiration.kidFriendly:
        return '👶';
      case RecipeInspiration.forGuests:
        return '🎉';
    }
  }
}
