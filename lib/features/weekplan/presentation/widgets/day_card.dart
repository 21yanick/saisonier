import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/date_utils.dart';
import '../../domain/enums.dart';

/// Card displaying a single day in the horizontal scroll calendar.
/// Shows date, weekday, and meal slot indicators with names or "+" for empty.
class DayCard extends StatelessWidget {
  final DateTime date;
  final List<PlannedMeal> meals;
  final Map<String, String> recipeTitles; // recipeId -> title
  final bool isToday;
  final bool isPast;
  final bool isWeekend;
  final VoidCallback onTap;
  final void Function(MealSlot slot)? onAddMeal;

  // Layout constants - large cards to fill screen
  static const double width = 140;
  static const double height = 340;
  static const double _borderRadius = 16;
  static const double _padding = 12;

  const DayCard({
    super.key,
    required this.date,
    required this.meals,
    this.recipeTitles = const {},
    required this.isToday,
    required this.isPast,
    required this.isWeekend,
    required this.onTap,
    this.onAddMeal,
  });

  PlannedMeal? _getMealForSlot(MealSlot slot) {
    return meals.cast<PlannedMeal?>().firstWhere(
          (m) => m?.slot == slot.name,
          orElse: () => null,
        );
  }

  String _getMealTitle(PlannedMeal meal) {
    // Custom entry
    if (meal.customTitle != null && meal.customTitle!.isNotEmpty) {
      return meal.customTitle!;
    }
    // Recipe - lookup title from map
    if (meal.recipeId != null && meal.recipeId!.isNotEmpty) {
      return recipeTitles[meal.recipeId] ?? '...';
    }
    return '...';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isPast ? 0.5 : 1.0,
        child: Container(
          // Width fixed, height from parent (SizedBox)
          decoration: _buildDecoration(primaryColor),
          child: Padding(
            padding: const EdgeInsets.all(_padding),
            child: Column(
              children: [
                _buildHeader(primaryColor),
                const SizedBox(height: 8),
                Expanded(child: _buildMealSlots(primaryColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(Color primaryColor) {
    if (isToday) {
      return BoxDecoration(
        color: primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: primaryColor, width: 2),
      );
    }

    if (isPast) {
      return BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      );
    }

    if (isWeekend) {
      return BoxDecoration(
        color: const Color(0xFFFFFBF5), // Light cream for weekend
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      );
    }

    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(_borderRadius),
      border: Border.all(color: Colors.grey[200]!, width: 1),
    );
  }

  Widget _buildHeader(Color primaryColor) {
    final weekdayName = WeekplanDateUtils.weekdayNamesFull[date.weekday - 1];
    final textColor = isToday ? primaryColor : Colors.grey[800];

    return Column(
      children: [
        // Weekday or "HEUTE" label
        Text(
          isToday ? '★ HEUTE ★' : weekdayName,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
            color: isToday ? primaryColor : Colors.grey[500],
            letterSpacing: isToday ? 0.5 : 0,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        // Day number
        Text(
          '${date.day}',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textColor,
            height: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildMealSlots(Color primaryColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: MealSlot.values.map((slot) {
        return _buildSlotRow(slot, primaryColor);
      }).toList(),
    );
  }

  Widget _buildSlotRow(MealSlot slot, Color primaryColor) {
    final meal = _getMealForSlot(slot);
    final hasMeal = meal != null;
    final canAdd = !isPast && onAddMeal != null;

    return GestureDetector(
      onTap: !hasMeal && canAdd ? () => onAddMeal!(slot) : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: hasMeal
              ? (isToday ? primaryColor.withValues(alpha: 0.08) : Colors.grey[50])
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: !hasMeal && canAdd
              ? Border.all(color: Colors.grey[300]!, width: 1, strokeAlign: BorderSide.strokeAlignInside)
              : null,
        ),
        child: Row(
          children: [
            // Slot icon
            Icon(
              slot.icon,
              size: 16,
              color: hasMeal
                  ? (isToday ? primaryColor : Colors.grey[600])
                  : Colors.grey[400],
            ),
            const SizedBox(width: 8),
            // Meal name or "+" or "—"
            Expanded(
              child: Text(
                hasMeal
                    ? _getMealTitle(meal)
                    : (isPast ? '—' : '+'),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: hasMeal ? FontWeight.w500 : FontWeight.normal,
                  color: hasMeal
                      ? (isToday ? primaryColor : Colors.grey[700])
                      : Colors.grey[400],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
