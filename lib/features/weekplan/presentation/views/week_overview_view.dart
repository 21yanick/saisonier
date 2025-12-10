import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/enums.dart';
import '../widgets/scroll_week_calendar.dart';
import '../widgets/week_stats_bar.dart';

/// Week overview with horizontal scroll calendar and stats.
class WeekOverviewView extends ConsumerWidget {
  final List<PlannedMeal> meals;
  final void Function(DateTime date) onDayTap;
  final void Function(DateTime date, MealSlot slot) onAddMeal;

  const WeekOverviewView({
    super.key,
    required this.meals,
    required this.onDayTap,
    required this.onAddMeal,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Calculate stats for current week only
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final weekStart = todayNormalized.subtract(Duration(days: todayNormalized.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));

    final weekMeals = meals.where((m) =>
        !m.date.isBefore(weekStart) && m.date.isBefore(weekEnd)).toList();

    return Column(
      children: [
        // Horizontal scroll calendar - takes most of the space
        Expanded(
          child: ScrollWeekCalendar(
            meals: meals,
            onDayTap: onDayTap,
            onAddMeal: onAddMeal,
          ),
        ),
        // Week stats (current week only) - compact at bottom
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
          child: WeekStatsBar(meals: weekMeals),
        ),
      ],
    );
  }
}
