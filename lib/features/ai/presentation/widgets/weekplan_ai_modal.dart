import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saisonier/core/theme/app_theme.dart';
import 'package:saisonier/features/ai/domain/enums/ai_enums.dart';
import 'package:saisonier/features/ai/domain/models/fixed_recipe.dart';
import 'package:saisonier/features/ai/domain/models/smart_weekplan_response.dart';
import 'package:saisonier/features/ai/data/repositories/ai_service.dart';
import 'package:saisonier/features/ai/presentation/widgets/fixed_recipe_sheet.dart';
import 'package:saisonier/features/profile/domain/models/user_profile.dart';
import 'package:saisonier/features/profile/presentation/state/user_profile_controller.dart';
import 'package:saisonier/features/weekplan/presentation/state/weekplan_controller.dart';
import 'package:saisonier/features/seasonality/data/repositories/recipe_repository.dart';

/// Modal for generating a smart AI weekplan.
class WeekplanAIModal extends ConsumerStatefulWidget {
  final Function(SmartWeekplanResponse response) onPlanGenerated;

  const WeekplanAIModal({
    super.key,
    required this.onPlanGenerated,
  });

  @override
  ConsumerState<WeekplanAIModal> createState() => _WeekplanAIModalState();
}

class _WeekplanAIModalState extends ConsumerState<WeekplanAIModal> {
  // Constants
  static const _dayCount = 14;
  static const _defaultSelectedDays = 5;

  final TextEditingController _contextController = TextEditingController();
  late final ScrollController _scrollController;

  // Day selection - concrete dates
  late final List<DateTime> _availableDays;
  late final Set<DateTime> _selectedDates;

  // Slot selection
  final Set<String> _selectedSlots = {'dinner'};

  // Inspiration
  WeekplanInspiration? _selectedInspiration;

  // Boosts
  bool _boostFavorites = false;
  bool _boostOwnRecipes = false;

  // Overrides
  bool _forceVegetarian = false;
  bool _forceVegan = false;
  bool _forceQuick = false;

  // Fixed recipes
  final List<FixedRecipe> _fixedRecipes = [];

  // State
  bool _isGenerating = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Generate available days starting from today
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    _availableDays = List.generate(
      _dayCount,
      (i) => normalizedToday.add(Duration(days: i)),
    );

    // Default: select next 5 days
    _selectedDates = _availableDays.take(_defaultSelectedDays).toSet();
  }

  @override
  void dispose() {
    _contextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onInspirationTap(WeekplanInspiration inspiration) {
    setState(() {
      if (_selectedInspiration == inspiration) {
        _selectedInspiration = null;
        _forceQuick = false;
      } else {
        _selectedInspiration = inspiration;
        if (inspiration == WeekplanInspiration.quickWeek) {
          _forceQuick = true;
        }
      }
    });
  }

  void _toggleDate(DateTime date) {
    setState(() {
      if (_selectedDates.contains(date)) {
        if (_selectedDates.length > 1) _selectedDates.remove(date);
      } else {
        _selectedDates.add(date);
      }
    });
  }

  void _toggleSlot(String slot) {
    setState(() {
      if (_selectedSlots.contains(slot)) {
        if (_selectedSlots.length > 1) _selectedSlots.remove(slot);
      } else {
        _selectedSlots.add(slot);
      }
    });
  }

  Future<void> _generatePlan() async {
    setState(() {
      _isGenerating = true;
      _errorMessage = null;
    });

    try {
      // Sort selected dates chronologically
      final sortedDates = _selectedDates.toList()
        ..sort((a, b) => a.compareTo(b));

      // Get existing meals to tell AI which slots are already filled
      final existingMeals = _getExistingMealsForSelectedSlots();

      // Convert fixed recipes to JSON format
      final fixedRecipesJson = _fixedRecipes
          .map((r) => r.toJson(sortedDates))
          .toList();

      final response = await ref.read(aiServiceProvider).generateSmartWeekplan(
            selectedDates: sortedDates,
            selectedSlots: _selectedSlots.toList(),
            weekContext: _contextController.text,
            inspiration: _selectedInspiration,
            boostFavorites: _boostFavorites,
            boostOwnRecipes: _boostOwnRecipes,
            forceVegetarian: _forceVegetarian,
            forceVegan: _forceVegan,
            forceQuick: _forceQuick,
            existingMeals: existingMeals,
            fixedRecipes: fixedRecipesJson,
          );

      if (mounted) {
        widget.onPlanGenerated(response);
      }
    } on AIServiceException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = 'Plan konnte nicht erstellt werden');
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  /// Get existing meals that overlap with selected dates and slots.
  List<Map<String, String>> _getExistingMealsForSelectedSlots() {
    final plannedMeals = ref.read(dialogPlannedMealsProvider()).valueOrNull ?? [];
    final recipes = ref.read(allRecipesProvider).valueOrNull ?? [];

    final existingMeals = <Map<String, String>>[];

    for (final meal in plannedMeals) {
      // Normalize meal date
      final mealDate = DateTime(meal.date.year, meal.date.month, meal.date.day);

      // Check if this meal's date is in selected dates
      if (!_selectedDates.contains(mealDate)) continue;

      // Check if this meal's slot is in selected slots
      if (!_selectedSlots.contains(meal.slot)) continue;

      // Get title (customTitle or recipe title)
      String title;
      if (meal.customTitle != null && meal.customTitle!.isNotEmpty) {
        title = meal.customTitle!;
      } else if (meal.recipeId != null && meal.recipeId!.isNotEmpty) {
        final recipe = recipes.where((r) => r.id == meal.recipeId).firstOrNull;
        title = recipe?.title ?? 'Geplant';
      } else {
        continue;
      }

      // Format date as ISO string
      final dateStr =
          '${mealDate.year}-${mealDate.month.toString().padLeft(2, '0')}-${mealDate.day.toString().padLeft(2, '0')}';

      existingMeals.add({
        'date': dateStr,
        'slot': meal.slot,
        'title': title,
      });
    }

    return existingMeals;
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileControllerProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppTheme.cream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile summary
                  _buildProfileSummary(userProfile),
                  const SizedBox(height: 20),

                  // Week context input
                  _buildContextInput(),
                  const SizedBox(height: 20),

                  // Inspiration chips
                  _buildInspirationChips(),
                  const SizedBox(height: 20),

                  // Day selection
                  _buildDaySelector(),
                  const SizedBox(height: 16),

                  // Slot selection
                  _buildSlotSelector(),
                  const SizedBox(height: 20),

                  // Boost toggles
                  _buildBoostToggles(),
                  const SizedBox(height: 16),

                  // Override toggles
                  _buildOverrideToggles(),
                  const SizedBox(height: 20),

                  // Fixed recipes section
                  _buildFixedRecipesSection(),
                  const SizedBox(height: 24),

                  // Error message
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Generate button
                  _buildGenerateButton(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Text(
            'Wochenplan-Assistent',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSummary(AsyncValue<UserProfile?> profileAsync) {
    return profileAsync.when(
      data: (profile) {
        if (profile == null) return const SizedBox.shrink();

        final parts = <String>[];
        if (profile.householdSize > 0) {
          parts.add('${profile.householdSize} Pers.');
        }
        if (profile.diet.name != 'omnivore') {
          parts.add(profile.diet.label);
        }
        parts.add('Max ${profile.maxCookingTimeMin}min');
        if (profile.allergens.isNotEmpty) {
          final allergenLabels = profile.allergens.map((a) => a.label).join(', ');
          parts.add('Ohne $allergenLabels');
        }

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.person, color: AppTheme.primaryGreen, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  parts.join(' | '),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildContextInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Was steht diese Woche an?',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _contextController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'z.B. Mo+Di Stress, Do kommen Gäste, hab noch Lauch...',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Je mehr du mir sagst, desto besser kann ich planen',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildInspirationChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Inspiration',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: WeekplanInspiration.values.map((inspiration) {
            final isSelected = _selectedInspiration == inspiration;
            return GestureDetector(
              onTap: () => _onInspirationTap(inspiration),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryGreen : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryGreen
                        : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(inspiration.emoji),
                    const SizedBox(width: 6),
                    Text(
                      inspiration.label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDaySelector() {
    const weekdayNames = ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'];
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Welche Tage?',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const Spacer(),
            Text(
              '${_selectedDates.length} ausgewählt',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 68,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: _availableDays.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final date = _availableDays[index];
              final isSelected = _selectedDates.contains(date);
              final isToday = date == normalizedToday;
              final weekday = weekdayNames[date.weekday % 7];

              return GestureDetector(
                onTap: () => _toggleDate(date),
                child: Container(
                  width: 52,
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryGreen : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryGreen
                          : isToday
                              ? AppTheme.primaryGreen.withValues(alpha: 0.5)
                              : Colors.grey.shade300,
                      width: isToday && !isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weekday,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? Colors.white70
                              : Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSlotSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welche Mahlzeiten?',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildSlotChip('breakfast', 'Frühstück'),
            const SizedBox(width: 8),
            _buildSlotChip('lunch', 'Mittagessen'),
            const SizedBox(width: 8),
            _buildSlotChip('dinner', 'Abendessen'),
          ],
        ),
      ],
    );
  }

  Widget _buildSlotChip(String slot, String label) {
    final isSelected = _selectedSlots.contains(slot);
    return GestureDetector(
      onTap: () => _toggleSlot(slot),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildBoostToggles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bevorzugen',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildToggleChip(
              'Meine Favoriten',
              _boostFavorites,
              () => setState(() => _boostFavorites = !_boostFavorites),
            ),
            const SizedBox(width: 8),
            _buildToggleChip(
              'Meine Rezepte',
              _boostOwnRecipes,
              () => setState(() => _boostOwnRecipes = !_boostOwnRecipes),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverrideToggles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nur diese Woche',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildToggleChip(
              'Vegetarisch',
              _forceVegetarian,
              () => setState(() {
                _forceVegetarian = !_forceVegetarian;
                if (_forceVegetarian) _forceVegan = false;
              }),
            ),
            _buildToggleChip(
              'Vegan',
              _forceVegan,
              () => setState(() {
                _forceVegan = !_forceVegan;
                if (_forceVegan) _forceVegetarian = false;
              }),
            ),
            _buildToggleChip(
              'Max 30min',
              _forceQuick,
              () => setState(() => _forceQuick = !_forceQuick),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleChip(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.primaryGreen.withValues(alpha: 0.15) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppTheme.primaryGreen : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? Icons.check_circle : Icons.circle_outlined,
              size: 18,
              color: isActive ? AppTheme.primaryGreen : Colors.grey.shade400,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppTheme.primaryGreen : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFixedRecipesSection() {
    const slotLabels = {
      'breakfast': 'Frühstück',
      'lunch': 'Mittagessen',
      'dinner': 'Abendessen',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Feste Rezepte',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message:
                  'Diese Rezepte werden fix eingeplant.\nDie KI überspringt diese Slots.',
              child: Icon(Icons.info_outline, size: 16, color: Colors.grey.shade500),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // List of fixed recipes
        if (_fixedRecipes.isNotEmpty) ...[
          ..._fixedRecipes.asMap().entries.map((entry) {
            final index = entry.key;
            final recipe = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryGreen.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.push_pin, size: 16, color: AppTheme.primaryGreen),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.recipeTitle,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${slotLabels[recipe.slot] ?? recipe.slot} • ${recipe.everySelectedDay ? 'Jeden Tag' : '${recipe.specificDays?.length ?? 0} Tage'}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 18, color: Colors.grey.shade600),
                    onPressed: () => _removeFixedRecipe(index),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
        ],

        // Add button
        GestureDetector(
          onTap: _showFixedRecipeSheet,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 18, color: Colors.grey.shade700),
                const SizedBox(width: 6),
                Text(
                  'Rezept hinzufügen',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showFixedRecipeSheet() {
    // Determine which slots are still available (not fully occupied by fixed recipes)
    final availableSlots = _selectedSlots.toSet();
    // Note: We allow adding multiple fixed recipes for the same slot on different days

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FixedRecipeSheet(
        availableSlots: availableSlots,
        selectedDates: _selectedDates,
        onRecipeSelected: (fixedRecipe) {
          setState(() => _fixedRecipes.add(fixedRecipe));
        },
      ),
    );
  }

  void _removeFixedRecipe(int index) {
    setState(() => _fixedRecipes.removeAt(index));
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isGenerating ? null : _generatePlan,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _isGenerating
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : const Text(
                'Plan erstellen',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
