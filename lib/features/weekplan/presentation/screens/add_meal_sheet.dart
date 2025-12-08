import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/database/app_database.dart';
import '../../../seasonality/data/repositories/recipe_repository.dart';
import '../../domain/date_utils.dart';
import '../../domain/enums.dart';
import '../state/weekplan_controller.dart';

class AddMealSheet extends ConsumerStatefulWidget {
  final DateTime date;
  final MealSlot slot;

  const AddMealSheet({
    super.key,
    required this.date,
    required this.slot,
  });

  @override
  ConsumerState<AddMealSheet> createState() => _AddMealSheetState();
}

class _AddMealSheetState extends ConsumerState<AddMealSheet> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showCustomEntry = false;
  final _customTitleController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _customTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipesAsync = ref.watch(allRecipesProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.slot.displayName} planen',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        WeekplanDateUtils.formatDayShort(widget.date),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Toggle: Recipe or Custom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _ToggleButton(
                    label: 'Rezept',
                    icon: Icons.restaurant_menu,
                    isSelected: !_showCustomEntry,
                    onTap: () => setState(() => _showCustomEntry = false),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ToggleButton(
                    label: 'Eigener Eintrag',
                    icon: Icons.edit_note,
                    isSelected: _showCustomEntry,
                    onTap: () => setState(() => _showCustomEntry = true),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Content
          Expanded(
            child: _showCustomEntry
                ? _buildCustomEntryForm()
                : _buildRecipeList(recipesAsync),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomEntryForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _customTitleController,
            decoration: const InputDecoration(
              labelText: 'Was gibt es?',
              hintText: 'z.B. "Pizza bestellen", "Reste"',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            onChanged: (_) => setState(() {}), // Rebuild to update button state
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _customTitleController.text.trim().isEmpty
                ? null
                : () => _addCustomEntry(),
            child: const Text('Hinzufügen'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeList(AsyncValue<List<Recipe>> recipesAsync) {
    return Column(
      children: [
        // Search
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rezept suchen...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
        ),
        const SizedBox(height: 12),

        // Recipe list
        Expanded(
          child: recipesAsync.when(
            data: (recipes) {
              final filtered = recipes.where((r) {
                if (_searchQuery.isEmpty) return true;
                return r.title
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
              }).toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      Text(
                        'Keine Rezepte gefunden',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final recipe = filtered[index];
                  return _RecipeListItem(
                    recipe: recipe,
                    onTap: () => _addRecipe(recipe),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Fehler: $e')),
          ),
        ),
      ],
    );
  }

  Future<void> _addRecipe(Recipe recipe) async {
    final success =
        await ref.read(weekplanControllerProvider.notifier).addRecipeToSlot(
              date: widget.date,
              slot: widget.slot,
              recipeId: recipe.id,
              servings: recipe.servings,
            );

    if (mounted) {
      Navigator.pop(context);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${recipe.title} hinzugefügt')),
        );
      }
    }
  }

  Future<void> _addCustomEntry() async {
    final title = _customTitleController.text.trim();
    if (title.isEmpty) return;

    final success =
        await ref.read(weekplanControllerProvider.notifier).addCustomEntry(
              date: widget.date,
              slot: widget.slot,
              customTitle: title,
            );

    if (mounted) {
      Navigator.pop(context);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title hinzugefügt')),
        );
      }
    }
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
          : Colors.grey[100],
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecipeListItem extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const _RecipeListItem({
    required this.recipe,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 56,
          height: 56,
          child: recipe.image.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl:
                      '${AppConfig.pocketBaseUrl}/api/files/recipes/${recipe.id}/${recipe.image}',
                  fit: BoxFit.cover,
                  memCacheWidth: 112,
                  memCacheHeight: 112,
                  fadeInDuration: const Duration(milliseconds: 100),
                  placeholder: (_, __) => Container(color: Colors.grey[200]),
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.restaurant),
                  ),
                )
              : Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.restaurant),
                ),
        ),
      ),
      title: Text(
        recipe.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${recipe.prepTimeMin + recipe.cookTimeMin} Min • ${recipe.servings} Portionen',
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
      trailing: const Icon(Icons.add_circle_outline),
    );
  }
}
