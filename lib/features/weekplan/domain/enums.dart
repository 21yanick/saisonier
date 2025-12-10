import 'package:flutter/material.dart';

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

  /// Material icon for this slot
  IconData get icon {
    switch (this) {
      case MealSlot.breakfast:
        return Icons.wb_twilight_outlined;
      case MealSlot.lunch:
        return Icons.light_mode_outlined;
      case MealSlot.dinner:
        return Icons.dark_mode_outlined;
    }
  }
}
