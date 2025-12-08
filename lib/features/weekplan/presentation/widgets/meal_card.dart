import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/database/app_database.dart';
import '../../../seasonality/data/repositories/recipe_repository.dart';
import '../state/weekplan_controller.dart';

/// Provider to get recipe details for a planned meal
final plannedMealRecipeProvider =
    StreamProvider.family.autoDispose<Recipe?, String?>((ref, recipeId) {
  if (recipeId == null || recipeId.isEmpty) return Stream.value(null);
  return ref.watch(recipeRepositoryProvider).watchRecipe(recipeId);
});

/// Horizontal meal card showing recipe image, title, and menu button
class MealCard extends ConsumerWidget {
  final PlannedMeal meal;

  const MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Custom entry (no recipe)
    if (meal.recipeId == null || meal.recipeId!.isEmpty) {
      return _CustomMealCard(meal: meal);
    }

    // Recipe entry - fetch recipe details
    final recipeAsync = ref.watch(plannedMealRecipeProvider(meal.recipeId));

    return recipeAsync.when(
      data: (recipe) {
        if (recipe == null) {
          return _CustomMealCard(meal: meal);
        }
        return _RecipeMealCard(meal: meal, recipe: recipe);
      },
      loading: () => _LoadingMealCard(),
      error: (_, __) => _CustomMealCard(meal: meal),
    );
  }
}

class _RecipeMealCard extends ConsumerWidget {
  final PlannedMeal meal;
  final Recipe recipe;

  const _RecipeMealCard({required this.meal, required this.recipe});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => context.push('/recipes/${recipe.id}'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Recipe image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: recipe.image.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl:
                              '${AppConfig.pocketBaseUrl}/api/files/recipes/${recipe.id}/${recipe.image}',
                          fit: BoxFit.cover,
                          memCacheWidth: 128,
                          memCacheHeight: 128,
                          fadeInDuration: const Duration(milliseconds: 100),
                          placeholder: (_, __) =>
                              Container(color: Colors.grey[200]),
                          errorWidget: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.restaurant, size: 24),
                          ),
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.restaurant, size: 24),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              // Recipe info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${recipe.prepTimeMin + recipe.cookTimeMin} Min · ${meal.servings} Portionen',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Menu button
              _MenuButton(
                onShowRecipe: () => context.push('/recipes/${recipe.id}'),
                onChangeServings: () => _showServingsDialog(context, ref),
                onDelete: () => _deleteMeal(ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showServingsDialog(BuildContext context, WidgetRef ref) {
    int newServings = meal.servings;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Portionen'),
        content: StatefulBuilder(
          builder: (context, setState) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: newServings > 1
                    ? () => setState(() => newServings--)
                    : null,
              ),
              Text(
                '$newServings',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => setState(() => newServings++),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(weekplanControllerProvider.notifier)
                  .updateServings(meal.id, newServings);
              Navigator.pop(context);
            },
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
  }

  void _deleteMeal(WidgetRef ref) {
    ref.read(weekplanControllerProvider.notifier).removeMeal(meal.id);
  }
}

class _CustomMealCard extends ConsumerWidget {
  final PlannedMeal meal;

  const _CustomMealCard({required this.meal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 1,
      color: Colors.amber[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.amber[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.sticky_note_2_outlined,
                color: Colors.amber[700],
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Title
            Expanded(
              child: Text(
                meal.customTitle ?? '',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.amber[900],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Menu button
            _MenuButton(
              onDelete: () => ref
                  .read(weekplanControllerProvider.notifier)
                  .removeMeal(meal.id),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingMealCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final VoidCallback? onShowRecipe;
  final VoidCallback? onChangeServings;
  final VoidCallback onDelete;

  const _MenuButton({
    this.onShowRecipe,
    this.onChangeServings,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.grey[600]),
      onSelected: (value) {
        switch (value) {
          case 'show':
            onShowRecipe?.call();
            break;
          case 'servings':
            onChangeServings?.call();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        if (onShowRecipe != null)
          const PopupMenuItem(
            value: 'show',
            child: Row(
              children: [
                Icon(Icons.open_in_new, size: 20),
                SizedBox(width: 12),
                Text('Rezept anzeigen'),
              ],
            ),
          ),
        if (onChangeServings != null)
          const PopupMenuItem(
            value: 'servings',
            child: Row(
              children: [
                Icon(Icons.people_outline, size: 20),
                SizedBox(width: 12),
                Text('Portionen ändern'),
              ],
            ),
          ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 20, color: Colors.red[600]),
              const SizedBox(width: 12),
              Text('Entfernen', style: TextStyle(color: Colors.red[600])),
            ],
          ),
        ),
      ],
    );
  }
}
