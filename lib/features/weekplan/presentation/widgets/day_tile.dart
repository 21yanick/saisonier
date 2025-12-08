import 'package:flutter/material.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/date_utils.dart';
import '../../domain/enums.dart';

/// Compact day tile for week overview
/// Shows day number and meal slot indicators (●○○)
class DayTile extends StatelessWidget {
  final DateTime date;
  final List<PlannedMeal> meals;
  final bool isToday;
  final bool isPast;
  final VoidCallback onTap;

  const DayTile({
    super.key,
    required this.date,
    required this.meals,
    required this.isToday,
    required this.isPast,
    required this.onTap,
  });

  bool _hasSlotFilled(MealSlot slot) {
    return meals.any((m) => m.slot == slot.name);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Day tile card
          Container(
            width: 56,
            height: 72,
            decoration: BoxDecoration(
              color: isToday ? primaryColor.withValues(alpha: 0.1) : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isToday ? primaryColor : Colors.grey[200]!,
                width: isToday ? 2 : 1,
              ),
            ),
            child: Opacity(
              opacity: isPast ? 0.5 : 1.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Day number
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isToday ? primaryColor : Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Meal slot indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: MealSlot.values.map((slot) {
                      final filled = _hasSlotFilled(slot);
                      return Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: filled
                              ? (isToday ? primaryColor : Colors.grey[700])
                              : Colors.transparent,
                          border: Border.all(
                            color: isToday ? primaryColor : Colors.grey[400]!,
                            width: 1.5,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Weekday label
          Text(
            WeekplanDateUtils.weekdayNamesShort[date.weekday - 1],
            style: TextStyle(
              fontSize: 11,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: isToday ? primaryColor : Colors.grey[600],
            ),
          ),
          // "Heute" label
          if (isToday)
            Text(
              'Heute',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
