import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../seasonality/data/repositories/recipe_repository.dart';
import '../../domain/date_utils.dart';
import '../../domain/enums.dart';
import 'day_card.dart';

/// Horizontal scrolling week calendar showing 28 days.
/// Displays meals per day with quick-add functionality.
class ScrollWeekCalendar extends ConsumerStatefulWidget {
  final List<PlannedMeal> meals;
  final void Function(DateTime date) onDayTap;
  final void Function(DateTime date, MealSlot slot) onAddMeal;

  const ScrollWeekCalendar({
    super.key,
    required this.meals,
    required this.onDayTap,
    required this.onAddMeal,
  });

  @override
  ConsumerState<ScrollWeekCalendar> createState() => _ScrollWeekCalendarState();
}

class _ScrollWeekCalendarState extends ConsumerState<ScrollWeekCalendar> {
  // Constants
  static const int _pastDays = 7;
  static const int _futureDays = 20;
  static const int _totalDays = _pastDays + 1 + _futureDays; // 28 days
  static const int _todayIndex = _pastDays; // Index 7 = today
  static const double _itemSpacing = 8;

  late final ScrollController _scrollController;
  late final DateTime _startDate;
  late final DateTime _today;
  int _currentMonthIndex = 0;

  @override
  void initState() {
    super.initState();

    // Calculate start date (7 days ago)
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _startDate = _today.subtract(const Duration(days: _pastDays));

    // Calculate initial scroll offset to center today
    // We want today (index 7) to be roughly centered
    final screenWidth = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width /
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    final initialOffset = (_todayIndex * (DayCard.width + _itemSpacing)) -
        (screenWidth / 2) + (DayCard.width / 2);

    _scrollController = ScrollController(
      initialScrollOffset: initialOffset.clamp(0, double.infinity),
    );
    _scrollController.addListener(_onScroll);

    // Set initial month
    _currentMonthIndex = _today.month;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Update month header based on first visible date
    final offset = _scrollController.offset;
    final firstVisibleIndex = (offset / (DayCard.width + _itemSpacing)).floor();
    final clampedIndex = firstVisibleIndex.clamp(0, _totalDays - 1);
    final firstVisibleDate = _startDate.add(Duration(days: clampedIndex));

    if (firstVisibleDate.month != _currentMonthIndex) {
      setState(() => _currentMonthIndex = firstVisibleDate.month);
    }
  }

  void _scrollToToday() {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetOffset = (_todayIndex * (DayCard.width + _itemSpacing)) -
        (screenWidth / 2) + (DayCard.width / 2);

    _scrollController.animateTo(
      targetOffset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollByDays(int days) {
    final currentOffset = _scrollController.offset;
    final delta = days * (DayCard.width + _itemSpacing);

    _scrollController.animateTo(
      (currentOffset + delta).clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  List<PlannedMeal> _getMealsForDate(DateTime date) {
    return widget.meals.where((m) =>
        m.date.year == date.year &&
        m.date.month == date.month &&
        m.date.day == date.day).toList();
  }

  Map<String, String> _buildRecipeTitles(List<Recipe> recipes) {
    return {for (final r in recipes) r.id: r.title};
  }

  @override
  Widget build(BuildContext context) {
    final recipesAsync = ref.watch(allRecipesProvider);
    final recipeTitles = recipesAsync.maybeWhen(
      data: _buildRecipeTitles,
      orElse: () => <String, String>{},
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context),
        const SizedBox(height: 12),
        Expanded(child: _buildCalendar(recipeTitles)),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final monthName = WeekplanDateUtils.monthNamesShort[_currentMonthIndex - 1];
    final todayDate = _startDate.add(const Duration(days: _todayIndex));
    final year = todayDate.year;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Previous week button
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _scrollByDays(-7),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 4),
          // Month and year
          Text(
            '$monthName $year',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          // Next week button
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _scrollByDays(7),
            visualDensity: VisualDensity.compact,
          ),
          const Spacer(),
          // Today button
          TextButton(
            onPressed: _scrollToToday,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Heute',
              style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(Map<String, String> recipeTitles) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use available height, with min/max bounds
        final cardHeight = constraints.maxHeight.clamp(200.0, 500.0);

        return ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          itemCount: _totalDays,
          itemBuilder: (context, index) {
            final date = _startDate.add(Duration(days: index));
            final isToday = date.year == _today.year &&
                date.month == _today.month &&
                date.day == _today.day;
            final isPast = date.isBefore(_today);
            final isWeekend = date.weekday == DateTime.saturday ||
                date.weekday == DateTime.sunday;
            final meals = _getMealsForDate(date);

            return Padding(
              padding: EdgeInsets.only(
                right: index < _totalDays - 1 ? _itemSpacing : 0,
              ),
              child: SizedBox(
                width: DayCard.width,
                height: cardHeight - 8, // Leave a bit of margin
                child: DayCard(
                  date: date,
                  meals: meals,
                  recipeTitles: recipeTitles,
                  isToday: isToday,
                  isPast: isPast,
                  isWeekend: isWeekend,
                  onTap: () => widget.onDayTap(date),
                  onAddMeal: isPast ? null : (slot) => widget.onAddMeal(date, slot),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
