import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/date_utils.dart';
import '../../domain/enums.dart';
import '../screens/add_meal_sheet.dart';
import '../state/weekplan_controller.dart';
import 'meal_card.dart';
import 'empty_meal_slot.dart';

/// Bottom sheet showing day detail with meal slots.
/// Supports swiping between days.
/// Watches meals reactively for live updates.
class DayDetailSheet extends ConsumerStatefulWidget {
  final DateTime initialDate;

  const DayDetailSheet({
    super.key,
    required this.initialDate,
  });

  @override
  ConsumerState<DayDetailSheet> createState() => _DayDetailSheetState();
}

class _DayDetailSheetState extends ConsumerState<DayDetailSheet> {
  // Same range as ScrollWeekCalendar
  static const int _pastDays = 7;
  static const int _totalDays = 28;

  late final PageController _pageController;
  late final DateTime _startDate;
  late final DateTime _today;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _startDate = _today.subtract(const Duration(days: _pastDays));

    // Calculate initial index based on initialDate
    final initialDateNormalized = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      widget.initialDate.day,
    );
    _currentIndex = initialDateNormalized.difference(_startDate).inDays.clamp(0, _totalDays - 1);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  DateTime _dateAtIndex(int index) => _startDate.add(Duration(days: index));

  bool _isToday(DateTime date) =>
      date.year == _today.year &&
      date.month == _today.month &&
      date.day == _today.day;

  void _goToDay(int delta) {
    final newIndex = (_currentIndex + delta).clamp(0, _totalDays - 1);
    _pageController.animateToPage(
      newIndex,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch meals reactively - updates automatically on changes
    final mealsAsync = ref.watch(scrollCalendarMealsProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle
              _buildDragHandle(),
              // Day navigation header
              _buildHeader(),
              const Divider(height: 1),
              // Day pages
              Expanded(
                child: mealsAsync.when(
                  data: (meals) => PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentIndex = index),
                    itemCount: _totalDays,
                    itemBuilder: (context, index) {
                      final date = _dateAtIndex(index);
                      return _DayContent(
                        date: date,
                        meals: meals,
                        isToday: _isToday(date),
                        scrollController: scrollController,
                      );
                    },
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Fehler: $e')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final currentDate = _dateAtIndex(_currentIndex);
    final isToday = _isToday(currentDate);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          // Previous day
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentIndex > 0 ? () => _goToDay(-1) : null,
          ),
          // Date display
          Expanded(
            child: Column(
              children: [
                Text(
                  _formatFullDate(currentDate),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isToday ? theme.primaryColor : null,
                  ),
                ),
                if (isToday)
                  Text(
                    '★ Heute',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryColor,
                    ),
                  ),
              ],
            ),
          ),
          // Next day
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _currentIndex < _totalDays - 1 ? () => _goToDay(1) : null,
          ),
        ],
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    final weekday = WeekplanDateUtils.weekdayNamesFull[date.weekday - 1];
    final month = WeekplanDateUtils.monthNamesShort[date.month - 1];
    return '$weekday, ${date.day}. $month';
  }
}

/// Content for a single day showing all meal slots.
class _DayContent extends StatelessWidget {
  final DateTime date;
  final List<PlannedMeal> meals;
  final bool isToday;
  final ScrollController scrollController;

  const _DayContent({
    required this.date,
    required this.meals,
    required this.isToday,
    required this.scrollController,
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      children: [
        // Meal slots
        ...MealSlot.values.map((slot) {
          return _MealSlotSection(
            slot: slot,
            meal: _getMealForSlot(slot),
            date: date,
          );
        }),
        // Extra bottom padding
        const SizedBox(height: 20),
      ],
    );
  }
}

/// Section for a single meal slot (breakfast/lunch/dinner).
class _MealSlotSection extends StatelessWidget {
  final MealSlot slot;
  final PlannedMeal? meal;
  final DateTime date;

  const _MealSlotSection({
    required this.slot,
    required this.meal,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Slot header with icon
          Row(
            children: [
              Icon(slot.icon, size: 18, color: Colors.grey[600]),
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
