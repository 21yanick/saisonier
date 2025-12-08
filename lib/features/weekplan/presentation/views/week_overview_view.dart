import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/date_utils.dart';
import '../state/weekplan_controller.dart';
import '../widgets/day_tile.dart';
import '../widgets/week_stats_bar.dart';

/// Week overview showing all 7 days as tiles with stats
class WeekOverviewView extends ConsumerWidget {
  final DateTime weekStart;
  final List<PlannedMeal> meals;
  final void Function(DateTime date) onDayTap;

  const WeekOverviewView({
    super.key,
    required this.weekStart,
    required this.meals,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);

    // Split week into two rows: Mo-Fr and Sa-So
    final weekdays = List.generate(5, (i) => weekStart.add(Duration(days: i)));
    final weekend = List.generate(2, (i) => weekStart.add(Duration(days: 5 + i)));

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Week header with navigation
          _WeekNavigationHeader(weekStart: weekStart),
          const SizedBox(height: 24),
          // Weekdays row (Mo-Fr)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: weekdays.map((date) {
              return _buildDayTile(date, todayNormalized);
            }).toList(),
          ),
          const SizedBox(height: 16),
          // Weekend row (Sa-So)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 16),
              ...weekend.map((date) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _buildDayTile(date, todayNormalized),
                );
              }),
            ],
          ),
          const SizedBox(height: 32),
          // Week stats
          WeekStatsBar(meals: meals),
          const SizedBox(height: 100), // Space for navigation pill
        ],
      ),
    );
  }

  Widget _buildDayTile(DateTime date, DateTime todayNormalized) {
    final isToday = date.year == todayNormalized.year &&
        date.month == todayNormalized.month &&
        date.day == todayNormalized.day;
    final isPast = date.isBefore(todayNormalized);

    final dayMeals = meals.where((m) =>
        m.date.year == date.year &&
        m.date.month == date.month &&
        m.date.day == date.day).toList();

    return DayTile(
      date: date,
      meals: dayMeals,
      isToday: isToday,
      isPast: isPast,
      onTap: () => onDayTap(date),
    );
  }
}

class _WeekNavigationHeader extends ConsumerWidget {
  final DateTime weekStart;

  const _WeekNavigationHeader({required this.weekStart});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            ref.read(selectedWeekStartProvider.notifier).previousWeek();
          },
        ),
        const SizedBox(width: 8),
        Text(
          WeekplanDateUtils.formatWeekRange(weekStart),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            ref.read(selectedWeekStartProvider.notifier).nextWeek();
          },
        ),
      ],
    );
  }
}
