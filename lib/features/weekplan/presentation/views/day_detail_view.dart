import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/date_utils.dart';
import '../../domain/enums.dart';
import '../screens/add_meal_sheet.dart';
import '../widgets/meal_card.dart';
import '../widgets/empty_meal_slot.dart';

/// Detail view for a single day with all meal slots
class DayDetailView extends ConsumerStatefulWidget {
  final DateTime weekStart;
  final int initialDayIndex;
  final List<PlannedMeal> meals;
  final VoidCallback onBack;

  const DayDetailView({
    super.key,
    required this.weekStart,
    required this.initialDayIndex,
    required this.meals,
    required this.onBack,
  });

  @override
  ConsumerState<DayDetailView> createState() => _DayDetailViewState();
}

class _DayDetailViewState extends ConsumerState<DayDetailView> {
  late PageController _pageController;
  late int _currentDayIndex;

  @override
  void initState() {
    super.initState();
    _currentDayIndex = widget.initialDayIndex;
    _pageController = PageController(initialPage: _currentDayIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToDay(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Day tabs
        _DayTabBar(
          weekStart: widget.weekStart,
          selectedIndex: _currentDayIndex,
          onDayTap: _goToDay,
        ),
        const Divider(height: 1),
        // Day pages
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentDayIndex = index);
            },
            itemCount: 7,
            itemBuilder: (context, index) {
              final date = widget.weekStart.add(Duration(days: index));
              return _DayContent(
                date: date,
                meals: widget.meals,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DayTabBar extends StatelessWidget {
  final DateTime weekStart;
  final int selectedIndex;
  final void Function(int index) onDayTap;

  const _DayTabBar({
    required this.weekStart,
    required this.selectedIndex,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          final date = weekStart.add(Duration(days: index));
          final isSelected = index == selectedIndex;
          final isToday = date.year == todayNormalized.year &&
              date.month == todayNormalized.month &&
              date.day == todayNormalized.day;

          return GestureDetector(
            onTap: () => onDayTap(index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  WeekplanDateUtils.weekdayNamesShort[date.weekday - 1],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : isToday
                            ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                            : Colors.transparent,
                    border: isToday && !isSelected
                        ? Border.all(color: Theme.of(context).primaryColor)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected || isToday
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? Colors.white
                            : isToday
                                ? Theme.of(context).primaryColor
                                : Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _DayContent extends StatelessWidget {
  final DateTime date;
  final List<PlannedMeal> meals;

  const _DayContent({
    required this.date,
    required this.meals,
  });

  List<PlannedMeal> get _dayMeals => meals
      .where((m) =>
          m.date.year == date.year &&
          m.date.month == date.month &&
          m.date.day == date.day)
      .toList();

  PlannedMeal? _getMealForSlot(MealSlot slot) {
    return _dayMeals.where((m) => m.slot == slot.name).firstOrNull;
  }

  String _formatFullDate(DateTime date) {
    final weekday = [
      'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag',
      'Freitag', 'Samstag', 'Sonntag'
    ][date.weekday - 1];
    final month = WeekplanDateUtils.monthNamesShort[date.month - 1];
    return '$weekday, ${date.day}. $month';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date header
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              _formatFullDate(date),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Meal slots
          ...MealSlot.values.map((slot) {
            return _MealSlotSection(
              slot: slot,
              meal: _getMealForSlot(slot),
              date: date,
            );
          }),
          // Extra space for navigation pill
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _MealSlotSection extends StatelessWidget {
  final MealSlot slot;
  final PlannedMeal? meal;
  final DateTime date;

  const _MealSlotSection({
    required this.slot,
    required this.meal,
    required this.date,
  });

  IconData get _slotIcon {
    switch (slot) {
      case MealSlot.breakfast:
        return Icons.wb_sunny_outlined;
      case MealSlot.lunch:
        return Icons.wb_sunny;
      case MealSlot.dinner:
        return Icons.nightlight_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Slot header
          Row(
            children: [
              Icon(_slotIcon, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                slot.displayName.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Meal card or empty slot
          if (meal != null)
            MealCard(meal: meal!)
          else
            EmptyMealSlot(
              onTap: () => _showAddMealSheet(context),
            ),
        ],
      ),
    );
  }

  void _showAddMealSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddMealSheet(date: date, slot: slot),
    );
  }
}
