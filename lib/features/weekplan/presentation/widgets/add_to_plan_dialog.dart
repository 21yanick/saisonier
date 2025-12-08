import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/date_utils.dart';
import '../../domain/enums.dart';
import '../state/weekplan_controller.dart';

/// Dialog to add a recipe to the week plan
class AddToPlanDialog extends ConsumerStatefulWidget {
  final String recipeId;
  final String recipeTitle;
  final int defaultServings;

  const AddToPlanDialog({
    super.key,
    required this.recipeId,
    required this.recipeTitle,
    required this.defaultServings,
  });

  @override
  ConsumerState<AddToPlanDialog> createState() => _AddToPlanDialogState();
}

class _AddToPlanDialogState extends ConsumerState<AddToPlanDialog> {
  // Constants
  static const _dayCount = 21;
  static const _dayCardWidth = 52.0;
  static const _dayCardSpacing = 8.0;

  // State
  late DateTime _selectedDate;
  late ScrollController _scrollController;
  MealSlot _selectedSlot = MealSlot.dinner;
  late int _servings;
  bool _isLoading = false;

  // Cached days list
  late final List<DateTime> _days;
  late final DateTime _today;

  @override
  void initState() {
    super.initState();
    _today = _normalizeDate(DateTime.now());
    _selectedDate = _today;
    _servings = widget.defaultServings;
    _days = _generateDays();
    _scrollController = ScrollController();

    // Scroll to center "today" after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Generate list of days starting from today
  List<DateTime> _generateDays() {
    return List.generate(_dayCount, (i) => _today.add(Duration(days: i)));
  }

  /// Normalize DateTime to midnight (remove time component)
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Check if two dates are the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Scroll to beginning (today is at index 0)
  void _scrollToToday() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).valueOrNull;

    return AlertDialog(
      title: const Text('Zum Plan hinzufügen'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe name
            Text(
              widget.recipeTitle,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // Date selection - horizontal calendar
            _buildDatePicker(context),

            const SizedBox(height: 20),

            // Slot selection
            const Text('Mahlzeit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: MealSlot.values.map((slot) {
                return ChoiceChip(
                  label: Text(slot.displayName),
                  selected: _selectedSlot == slot,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedSlot = slot);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Servings
            Row(
              children: [
                const Text('Portionen:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: _servings > 1
                      ? () => setState(() => _servings--)
                      : null,
                ),
                Text(
                  '$_servings',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => setState(() => _servings++),
                ),
              ],
            ),

            if (user == null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Melde dich an, um deinen Wochenplan zu speichern.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: user == null || _isLoading ? null : _addToPlan,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Hinzufügen'),
        ),
      ],
    );
  }

  /// Build the horizontal date picker section
  Widget _buildDatePicker(BuildContext context) {
    final theme = Theme.of(context);
    final selectedMonth = WeekplanDateUtils.monthNamesShort[_selectedDate.month - 1];
    final selectedYear = _selectedDate.year;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: "Tag" + Month indicator
        Row(
          children: [
            const Text('Tag', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const Spacer(),
            Text(
              '$selectedMonth $selectedYear',
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Horizontal scrolling day cards
        SizedBox(
          height: 72,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: _days.length,
            separatorBuilder: (_, __) => const SizedBox(width: _dayCardSpacing),
            itemBuilder: (context, index) {
              final date = _days[index];
              final isSelected = _isSameDay(date, _selectedDate);
              final isToday = _isSameDay(date, _today);
              return _buildDayCard(context, date, isSelected, isToday);
            },
          ),
        ),
      ],
    );
  }

  /// Build a single day card
  Widget _buildDayCard(BuildContext context, DateTime date, bool isSelected, bool isToday) {
    final theme = Theme.of(context);
    final weekday = WeekplanDateUtils.weekdayNamesShort[date.weekday - 1];

    // Colors based on state
    final backgroundColor = isSelected
        ? theme.colorScheme.primary
        : Colors.grey[100];
    final textColor = isSelected
        ? Colors.white
        : Colors.black87;
    final weekdayColor = isSelected
        ? Colors.white70
        : Colors.grey[600];

    return GestureDetector(
      onTap: () => setState(() => _selectedDate = date),
      child: Container(
        width: _dayCardWidth,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Weekday (Mo, Di, Mi...)
            Text(
              weekday,
              style: TextStyle(
                fontSize: 12,
                color: weekdayColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            // Day number
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            // Today indicator
            if (isToday) ...[
              const SizedBox(height: 4),
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.white : theme.colorScheme.primary,
                ),
              ),
            ] else ...[
              const SizedBox(height: 10), // Placeholder for alignment
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _addToPlan() async {
    setState(() => _isLoading = true);

    final success =
        await ref.read(weekplanControllerProvider.notifier).addRecipeToSlot(
              date: _selectedDate,
              slot: _selectedSlot,
              recipeId: widget.recipeId,
              servings: _servings,
            );

    if (mounted) {
      Navigator.pop(context, success);
    }
  }
}
