import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saisonier/core/theme/app_theme.dart';
import 'package:saisonier/core/database/app_database.dart';
import 'package:saisonier/features/ai/domain/models/fixed_recipe.dart';
import 'package:saisonier/features/seasonality/data/repositories/recipe_repository.dart';

/// Bottom sheet for selecting a fixed recipe.
class FixedRecipeSheet extends ConsumerStatefulWidget {
  final Set<String> availableSlots;
  final Set<DateTime> selectedDates;
  final Function(FixedRecipe) onRecipeSelected;

  const FixedRecipeSheet({
    super.key,
    required this.availableSlots,
    required this.selectedDates,
    required this.onRecipeSelected,
  });

  @override
  ConsumerState<FixedRecipeSheet> createState() => _FixedRecipeSheetState();
}

class _FixedRecipeSheetState extends ConsumerState<FixedRecipeSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSlot = 'dinner';
  Recipe? _selectedRecipe;
  bool _everyDay = true;
  final Set<DateTime> _specificDays = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Default to first available slot
    if (widget.availableSlots.isNotEmpty) {
      _selectedSlot = widget.availableSlots.first;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> _getAllergenWarnings(Recipe recipe) {
    final warnings = <String>[];
    if (recipe.containsGluten == true) warnings.add('Gluten');
    if (recipe.containsLactose == true) warnings.add('Laktose');
    if (recipe.containsNuts == true) warnings.add('Nüsse');
    if (recipe.containsEggs == true) warnings.add('Eier');
    if (recipe.containsFish == true) warnings.add('Fisch');
    if (recipe.containsShellfish == true) warnings.add('Meeresfrüchte');
    if (recipe.containsSoy == true) warnings.add('Soja');
    return warnings;
  }

  void _onAdd() {
    if (_selectedRecipe == null) return;

    final fixedRecipe = FixedRecipe(
      recipeId: _selectedRecipe!.id,
      recipeTitle: _selectedRecipe!.title,
      slot: _selectedSlot,
      everySelectedDay: _everyDay,
      specificDays: _everyDay ? null : _specificDays,
      cookTimeMin: _selectedRecipe!.prepTimeMin + _selectedRecipe!.cookTimeMin,
      allergenWarnings: _getAllergenWarnings(_selectedRecipe!),
    );

    widget.onRecipeSelected(fixedRecipe);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final recipesAsync = ref.watch(allRecipesProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
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
                  // Slot selection
                  _buildSlotSelection(),
                  const SizedBox(height: 20),

                  // Recipe search
                  _buildRecipeSearch(),
                  const SizedBox(height: 12),

                  // Recipe list
                  recipesAsync.when(
                    data: (recipes) => _buildRecipeList(recipes),
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (_, __) => const Text('Fehler beim Laden'),
                  ),

                  // When selection
                  if (_selectedRecipe != null) ...[
                    const SizedBox(height: 20),
                    _buildWhenSelection(),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
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
            'Festes Rezept hinzufügen',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildSlotSelection() {
    const slotLabels = {
      'breakfast': 'Frühstück',
      'lunch': 'Mittagessen',
      'dinner': 'Abendessen',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mahlzeit',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 8),
        Row(
          children: widget.availableSlots.map((slot) {
            final isSelected = _selectedSlot == slot;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedSlot = slot),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryGreen : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryGreen
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    slotLabels[slot] ?? slot,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecipeSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rezept',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Suchen...',
            prefixIcon: const Icon(Icons.search, size: 20),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
      ],
    );
  }

  Widget _buildRecipeList(List<Recipe> recipes) {
    // Filter by search query
    var filtered = recipes;
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = recipes
          .where((r) => r.title.toLowerCase().contains(query))
          .toList();
    }

    // Sort: selected first, then alphabetically
    filtered.sort((a, b) {
      if (a.id == _selectedRecipe?.id) return -1;
      if (b.id == _selectedRecipe?.id) return 1;
      return a.title.compareTo(b.title);
    });

    // Limit display
    final displayRecipes = filtered.take(15).toList();

    return Column(
      children: displayRecipes.map((recipe) {
        final isSelected = _selectedRecipe?.id == recipe.id;
        final allergens = _getAllergenWarnings(recipe);
        final totalTime = recipe.prepTimeMin + recipe.cookTimeMin;

        return GestureDetector(
          onTap: () => setState(() => _selectedRecipe = recipe),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryGreen.withValues(alpha: 0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppTheme.primaryGreen : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.schedule,
                              size: 14, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            '$totalTime min',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          if (allergens.isNotEmpty) ...[
                            const SizedBox(width: 12),
                            Icon(Icons.warning_amber,
                                size: 14, color: Colors.orange.shade700),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                allergens.join(', '),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange.shade700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle, color: AppTheme.primaryGreen),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWhenSelection() {
    final weekdayNames = ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Wann?',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() => _everyDay = true),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _everyDay ? AppTheme.primaryGreen.withValues(alpha: 0.1) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _everyDay ? AppTheme.primaryGreen : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _everyDay ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: _everyDay ? AppTheme.primaryGreen : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Text('Jeden ausgewählten Tag'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => setState(() => _everyDay = false),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: !_everyDay ? AppTheme.primaryGreen.withValues(alpha: 0.1) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: !_everyDay ? AppTheme.primaryGreen : Colors.grey.shade300,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      !_everyDay
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: !_everyDay ? AppTheme.primaryGreen : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text('Nur bestimmte Tage'),
                  ],
                ),
                if (!_everyDay) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (widget.selectedDates.toList()..sort())
                        .map((date) {
                      final isSelected = _specificDays.contains(date);
                      final weekday = weekdayNames[date.weekday % 7];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _specificDays.remove(date);
                            } else {
                              _specificDays.add(date);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryGreen
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '$weekday ${date.day}',
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    final canAdd = _selectedRecipe != null &&
        (_everyDay || _specificDays.isNotEmpty);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: canAdd ? _onAdd : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Hinzufügen',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
