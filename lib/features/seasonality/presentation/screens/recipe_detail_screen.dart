import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saisonier/core/database/app_database.dart';
import 'package:saisonier/features/seasonality/data/repositories/recipe_repository.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:saisonier/core/config/app_config.dart';
import 'package:saisonier/features/shopping_list/presentation/state/shopping_list_controller.dart';
import 'package:saisonier/features/profile/presentation/widgets/bring_auth_dialog.dart';
import 'package:saisonier/features/weekplan/presentation/widgets/add_to_plan_dialog.dart';

final recipeProvider = StreamProvider.family.autoDispose<Recipe?, String>((ref, id) {
  return ref.watch(recipeRepositoryProvider).watchRecipe(id);
});

class RecipeDetailScreen extends ConsumerStatefulWidget {
  final String recipeId;

  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
  });

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  bool _cookingMode = false;

  void _toggleCookingMode() {
    setState(() {
      _cookingMode = !_cookingMode;
    });
    if (_cookingMode) {
      WakelockPlus.enable();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cooking Mode Active: Screen will stay on.')),
      );
    } else {
      WakelockPlus.disable();
    }
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipeAsync = ref.watch(recipeProvider(widget.recipeId));

    return Scaffold(
      body: recipeAsync.when(
        data: (recipe) {
          if (recipe == null) return const Center(child: Text('Recipe not found'));

          // Parse JSON lists
          List<dynamic> ingredients = [];
          List<String> steps = [];
          try {
            ingredients = jsonDecode(recipe.ingredients) as List<dynamic>;
            steps = (jsonDecode(recipe.steps) as List<dynamic>).map((e) => e.toString()).toList();
          } catch (e) {
            // Fallback or log if needed
            ingredients = [];
            steps = [];
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(recipe.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                      )),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: '${AppConfig.pocketBaseUrl}/api/files/recipes/${recipe.id}/${recipe.image}',
                        fit: BoxFit.cover,
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(_cookingMode ? Icons.wb_sunny : Icons.wb_sunny_outlined),
                    tooltip: 'Cooking Mode',
                    onPressed: _toggleCookingMode,
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       // Meta
                       Row(
                         children: [
                           const Icon(Icons.timer_outlined, size: 20, color: Colors.grey),
                           const SizedBox(width: 8),
                           Text('${recipe.timeMin} Min', style: const TextStyle(color: Colors.grey)),
                         ],
                       ),
                       const SizedBox(height: 24),

                      // Actions
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.calendar_month),
                              label: const Text('Zum Plan'),
                              onPressed: () async {
                                final success = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AddToPlanDialog(
                                    recipeId: recipe.id,
                                    recipeTitle: recipe.title,
                                    defaultServings: recipe.servings,
                                  ),
                                );
                                if (success == true && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Zum Wochenplan hinzugefügt')),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.playlist_add),
                              label: const Text('Einkauf'),
                              onPressed: () async {
                                final isConnected = await ref.read(shoppingListControllerProvider.future);
                                if (!isConnected) {
                                  if (context.mounted) {
                                     final success = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => const BringAuthDialog(),
                                    );
                                    if (success != true) return;
                                  } else {
                                    return;
                                  }
                                }
                                
                                // Add all ingredients
                                if (!context.mounted) return;

                                int addedCount = 0;
                                int skippedCount = 0;
                                try {
                                  final ingredients = jsonDecode(recipe.ingredients) as List<dynamic>;
                                  for (var ing in ingredients) {
                                    final i = ing as Map<String, dynamic>;
                                    // Support both 'item' (PRD spec) and 'name' field names
                                    final itemName = (i['item'] ?? i['name']) as String?;

                                    if (itemName == null || itemName.isEmpty) {
                                      skippedCount++;
                                      continue;
                                    }

                                    final amount = i['amount']?.toString() ?? '';
                                    final unit = i['unit']?.toString() ?? '';
                                    final spec = '$amount $unit'.trim();

                                    await ref.read(shoppingListControllerProvider.notifier).addItem(itemName, spec);
                                    addedCount++;
                                  }

                                  if (context.mounted) {
                                    final message = skippedCount > 0
                                        ? '$addedCount Zutaten hinzugefügt ($skippedCount übersprungen)'
                                        : '$addedCount Zutaten zu Bring! hinzugefügt';
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(message)),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Fehler beim Hinzufügen: $e'), backgroundColor: Colors.red),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Ingredients
                      const Text('Zutaten', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(height: 12),
                      ...ingredients.map((ing) {
                        final i = ing as Map<String, dynamic>;
                        final itemName = (i['item'] ?? i['name'] ?? '') as String;
                        final amount = i['amount']?.toString() ?? '';
                        final unit = i['unit']?.toString() ?? '';
                        final spec = '$amount$unit'.trim();
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Text('•  ', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                              if (spec.isNotEmpty)
                                Text('$spec ', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Expanded(child: Text(itemName)),
                            ],
                          ),
                        );
                      }),
                      
                      const SizedBox(height: 32),

                      // Steps
                      const Text('Zubereitung', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      const SizedBox(height: 16),
                      ...steps.asMap().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(child: Text('${entry.key + 1}', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 12))),
                              ),
                              const SizedBox(width: 16),
                              Expanded(child: Text(entry.value, style: const TextStyle(height: 1.5, fontSize: 16))),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
