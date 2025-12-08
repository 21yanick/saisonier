/// Meal slots for daily planning
enum MealSlot {
  breakfast,
  lunch,
  dinner;

  String get displayName {
    switch (this) {
      case MealSlot.breakfast:
        return 'Frühstück';
      case MealSlot.lunch:
        return 'Mittag';
      case MealSlot.dinner:
        return 'Abend';
    }
  }

  String get shortName {
    switch (this) {
      case MealSlot.breakfast:
        return 'Früh';
      case MealSlot.lunch:
        return 'Mittag';
      case MealSlot.dinner:
        return 'Abend';
    }
  }
}
