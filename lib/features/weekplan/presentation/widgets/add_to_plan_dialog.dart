import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../seasonality/data/repositories/recipe_repository.dart';
import '../../domain/date_utils.dart';
import '../../domain/enums.dart';
import '../state/weekplan_controller.dart';

/// Dialog to add a recipe to the week plan
/// Shows which days already have planned meals and warns before replacing
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

    // Scroll to beginning after first frame
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

  /// Get occupied slots for a specific date from the meals list
  Set<MealSlot> _getOccupiedSlots(List<PlannedMeal> meals, DateTime date) {
    return meals
        .where((m) => _isSameDay(m.date, date))
        .map((m) => MealSlot.values.firstWhere(
              (s) => s.name == m.slot,
              orElse: () => MealSlot.dinner,
            ))
        .toSet();
  }

  /// Get the meal for a specific date and slot
  PlannedMeal? _getMealForSlot(List<PlannedMeal> meals, DateTime date, MealSlot slot) {
    return meals
        .where((m) => _isSameDay(m.date, date) && m.slot == slot.name)
        .firstOrNull;
  }

  /// Get the display name of an existing meal (custom title or recipe title)
  String _getExistingMealName(PlannedMeal meal, List<Recipe> recipes) {
    // Custom entry - use custom title
    if (meal.customTitle != null && meal.customTitle!.isNotEmpty) {
      return meal.customTitle!;
    }
    // Recipe-based entry - find recipe title
    if (meal.recipeId != null && meal.recipeId!.isNotEmpty) {
      final recipe = recipes.where((r) => r.id == meal.recipeId).firstOrNull;
      if (recipe != null) {
        return recipe.title;
      }
    }
    return 'Geplante Mahlzeit';
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    final mealsAsync = ref.watch(dialogPlannedMealsProvider());
    final recipesAsync = ref.watch(allRecipesProvider);
    final recipes = recipesAsync.valueOrNull ?? [];

    return AlertDialog(
      title: const Text('Zum Plan hinzufügen'),
      content: SizedBox(
        width: double.maxFinite,
        child: mealsAsync.when(
          data: (meals) => _buildContent(context, user, meals, recipes),
          loading: () => const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, __) => _buildContent(context, user, [], recipes),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(
          onPressed: user == null || _isLoading
              ? null
              : () => _handleAddToPlan(
                    mealsAsync.valueOrNull ?? [],
                    recipes,
                  ),
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

  Widget _buildContent(
    BuildContext context,
    dynamic user,
    List<PlannedMeal> meals,
    List<Recipe> recipes,
  ) {
    final occupiedSlotsForSelectedDate = _getOccupiedSlots(meals, _selectedDate);

    return Column(
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
        _buildDatePicker(context, meals),

        const SizedBox(height: 20),

        // Slot selection with occupancy indicators
        _buildSlotSelection(context, occupiedSlotsForSelectedDate, meals, recipes),

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
    );
  }

  /// Build slot selection with occupancy indicators
  Widget _buildSlotSelection(
    BuildContext context,
    Set<MealSlot> occupiedSlots,
    List<PlannedMeal> meals,
    List<Recipe> recipes,
  ) {
    // Get the existing meal name for the selected slot if occupied
    final existingMeal = _getMealForSlot(meals, _selectedDate, _selectedSlot);
    final existingMealName = existingMeal != null
        ? _getExistingMealName(existingMeal, recipes)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mahlzeit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: MealSlot.values.map((slot) {
            final isOccupied = occupiedSlots.contains(slot);
            final isSelected = _selectedSlot == slot;

            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(slot.displayName),
                  if (isOccupied) ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.event_busy,
                      size: 14,
                      color: isSelected ? Colors.white70 : Colors.orange[700],
                    ),
                  ],
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedSlot = slot);
              },
            );
          }).toList(),
        ),
        // Show warning if selected slot is occupied
        if (occupiedSlots.contains(_selectedSlot) && existingMealName != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(Icons.swap_horiz, color: Colors.orange[700], size: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '"$existingMealName"',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange[900],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: ' wird ersetzt.',
                          style: TextStyle(fontSize: 12, color: Colors.orange[900]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// Build the horizontal date picker section
  Widget _buildDatePicker(BuildContext context, List<PlannedMeal> meals) {
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
          height: 76, // Slightly taller to accommodate slot indicators
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: _days.length,
            separatorBuilder: (_, __) => const SizedBox(width: _dayCardSpacing),
            itemBuilder: (context, index) {
              final date = _days[index];
              final isSelected = _isSameDay(date, _selectedDate);
              final isToday = _isSameDay(date, _today);
              final occupiedSlots = _getOccupiedSlots(meals, date);
              return _buildDayCard(context, date, isSelected, isToday, occupiedSlots);
            },
          ),
        ),
      ],
    );
  }

  /// Build a single day card with slot indicators
  Widget _buildDayCard(
    BuildContext context,
    DateTime date,
    bool isSelected,
    bool isToday,
    Set<MealSlot> occupiedSlots,
  ) {
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
          // Today indicator: thin border instead of dot
          border: isToday && !isSelected
              ? Border.all(color: theme.colorScheme.primary, width: 2)
              : null,
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
            const SizedBox(height: 4),
            // Slot indicators (3 dots for breakfast/lunch/dinner)
            _buildSlotIndicators(context, isSelected, occupiedSlots),
          ],
        ),
      ),
    );
  }

  /// Build the three slot indicator dots
  Widget _buildSlotIndicators(BuildContext context, bool isSelected, Set<MealSlot> occupiedSlots) {
    final theme = Theme.of(context);

    // Colors for dots
    final filledColor = isSelected ? Colors.white : theme.colorScheme.primary;
    final emptyColor = isSelected ? Colors.white38 : Colors.grey[300];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: MealSlot.values.map((slot) {
        final isOccupied = occupiedSlots.contains(slot);
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isOccupied ? filledColor : emptyColor,
          ),
        );
      }).toList(),
    );
  }

  /// Handle adding to plan with confirmation if slot is occupied
  Future<void> _handleAddToPlan(List<PlannedMeal> meals, List<Recipe> recipes) async {
    final existingMeal = _getMealForSlot(meals, _selectedDate, _selectedSlot);

    if (existingMeal != null) {
      final existingMealName = _getExistingMealName(existingMeal, recipes);

      // Show confirmation dialog
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Mahlzeit ersetzen?'),
          content: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '"$existingMealName"',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: ' (${_selectedSlot.displayName} am ${WeekplanDateUtils.formatDayShort(_selectedDate)}) '
                      'durch ',
                ),
                TextSpan(
                  text: '"${widget.recipeTitle}"',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const TextSpan(text: ' ersetzen?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Ersetzen'),
            ),
          ],
        ),
      );

      if (confirmed != true) return;
    }

    await _addToPlan();
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
