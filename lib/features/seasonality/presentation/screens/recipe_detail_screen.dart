import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saisonier/core/database/app_database.dart';
import 'package:saisonier/features/seasonality/data/repositories/recipe_repository.dart';
import 'package:saisonier/features/seasonality/domain/models/ingredient.dart';
import 'package:saisonier/features/seasonality/domain/enums/recipe_enums.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:saisonier/core/config/app_config.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:saisonier/features/shopping_list/presentation/state/shopping_list_controller.dart';
import 'package:saisonier/features/weekplan/presentation/widgets/add_to_plan_dialog.dart';
import 'package:saisonier/features/profile/domain/enums/profile_enums.dart';
import 'package:go_router/go_router.dart';

final recipeProvider = StreamProvider.family.autoDispose<Recipe?, String>((ref, id) {
  return ref.watch(recipeRepositoryProvider).watchRecipe(id);
});

/// Provider for the linked vegetable (if any)
final linkedVegetableProvider = StreamProvider.family.autoDispose<Vegetable?, String>((ref, id) {
  if (id.isEmpty) return Stream.value(null);
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.vegetables)..where((t) => t.id.equals(id))).watchSingleOrNull();
});

class RecipeDetailScreen extends ConsumerStatefulWidget {
  final String recipeId;
  final int? initialServings;

  const RecipeDetailScreen({
    super.key,
    required this.recipeId,
    this.initialServings,
  });

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  bool _cookingMode = false;
  int _currentServings = 4;
  bool _servingsInitialized = false;

  void _toggleCookingMode() {
    setState(() => _cookingMode = !_cookingMode);
    if (_cookingMode) {
      WakelockPlus.enable();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kochmodus aktiv: Display bleibt an')),
      );
    } else {
      WakelockPlus.disable();
    }
  }

  void _initServings(Recipe recipe) {
    if (_servingsInitialized) return;
    _servingsInitialized = true;
    _currentServings = widget.initialServings ?? recipe.servings;
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipeAsync = ref.watch(recipeProvider(widget.recipeId));
    final theme = Theme.of(context);

    return Scaffold(
      body: recipeAsync.when(
        data: (recipe) {
          if (recipe == null) {
            return const Center(child: Text('Rezept nicht gefunden'));
          }

          // Initialize servings once
          _initServings(recipe);

          // Parse ingredients & steps
          final ingredients = _parseIngredients(recipe.ingredients);
          final scaledIngredients = scaleIngredients(
            ingredients,
            recipe.servings,
            _currentServings,
          );
          final steps = _parseSteps(recipe.steps);

          return CustomScrollView(
            slivers: [
              // === HEADER ===
              _buildAppBar(recipe, theme),

              // === CONTENT ===
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Beschreibung
                      if (recipe.description.isNotEmpty) ...[
                        Text(
                          recipe.description,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Meta-Info Row
                      _buildMetaRow(recipe, theme),
                      const SizedBox(height: 16),

                      // Allergen-Hinweis (falls vorhanden)
                      _buildAllergenInfo(recipe),

                      // Tags (falls vorhanden)
                      _buildTagsSection(recipe),

                      // Linked Vegetable (falls vorhanden)
                      _buildLinkedVegetable(recipe),

                      // Action Buttons
                      _buildActionButtons(recipe, scaledIngredients),
                      const SizedBox(height: 24),

                      // Portionen-Stepper + Zutaten
                      _buildIngredientsSection(recipe, scaledIngredients, theme),
                      const SizedBox(height: 28),

                      // Zubereitung
                      _buildStepsSection(steps, theme),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
      ),
    );
  }

  // === APP BAR ===
  SliverAppBar _buildAppBar(Recipe recipe, ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          recipe.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.black, blurRadius: 10)],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (recipe.image.isNotEmpty)
              CachedNetworkImage(
                imageUrl: '${AppConfig.pocketBaseUrl}/api/files/recipes/${recipe.id}/${recipe.image}',
                fit: BoxFit.cover,
                memCacheWidth: 800,
                fadeInDuration: const Duration(milliseconds: 150),
                errorWidget: (_, __, ___) => Container(color: Colors.grey[300]),
              )
            else
              Container(color: Colors.grey[300]),
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
        // Favorit-Toggle
        IconButton(
          icon: Icon(
            recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: recipe.isFavorite ? Colors.red[400] : null,
          ),
          tooltip: 'Favorit',
          onPressed: () => _toggleFavorite(recipe),
        ),
        // Kochmodus
        IconButton(
          icon: Icon(_cookingMode ? Icons.wb_sunny : Icons.wb_sunny_outlined),
          tooltip: 'Kochmodus',
          onPressed: _toggleCookingMode,
        ),
      ],
    );
  }

  // === META ROW ===
  Widget _buildMetaRow(Recipe recipe, ThemeData theme) {
    final difficulty = recipe.difficulty != null
        ? RecipeDifficulty.values.where((d) => d.name == recipe.difficulty).firstOrNull
        : null;
    final category = RecipeCategory.fromValue(recipe.category);

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Kategorie (prominent am Anfang)
        if (category != null) _CategoryBadge(category: category),

        // Vorbereitungszeit
        if (recipe.prepTimeMin > 0)
          _MetaChip(
            icon: Icons.content_cut,
            label: 'Vorb: ${recipe.prepTimeMin} Min',
          ),

        // Kochzeit
        if (recipe.cookTimeMin > 0)
          _MetaChip(
            icon: Icons.local_fire_department_outlined,
            label: 'Kochen: ${recipe.cookTimeMin} Min',
          ),

        // Gesamtzeit (falls beides > 0)
        if (recipe.prepTimeMin > 0 && recipe.cookTimeMin > 0)
          _MetaChip(
            icon: Icons.timer_outlined,
            label: 'Gesamt: ${recipe.prepTimeMin + recipe.cookTimeMin} Min',
          ),

        // Nur Gesamtzeit wenn eines 0 ist
        if ((recipe.prepTimeMin == 0) != (recipe.cookTimeMin == 0))
          _MetaChip(
            icon: Icons.timer_outlined,
            label: '${recipe.prepTimeMin + recipe.cookTimeMin} Min',
          ),

        // Schwierigkeit
        if (difficulty != null)
          _DifficultyBadge(difficulty: difficulty),

        // Vegetarisch/Vegan
        if (recipe.isVegan)
          const _MetaChip(
            icon: Icons.eco,
            label: 'Vegan',
            color: Colors.green,
          )
        else if (recipe.isVegetarian)
          const _MetaChip(
            icon: Icons.eco_outlined,
            label: 'Vegetarisch',
            color: Colors.green,
          ),
      ],
    );
  }

  // === ALLERGEN INFO ===
  Widget _buildAllergenInfo(Recipe recipe) {
    // Collect allergens that are present
    final allergens = <Allergen>[];
    if (recipe.containsGluten) allergens.add(Allergen.gluten);
    if (recipe.containsLactose) allergens.add(Allergen.lactose);
    if (recipe.containsNuts) allergens.add(Allergen.nuts);
    if (recipe.containsEggs) allergens.add(Allergen.eggs);
    if (recipe.containsSoy) allergens.add(Allergen.soy);
    if (recipe.containsFish) allergens.add(Allergen.fish);
    if (recipe.containsShellfish) allergens.add(Allergen.shellfish);

    if (allergens.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange[700], size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enthält:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.orange[800],
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    allergens.map((a) => a.label).join(', '),
                    style: TextStyle(
                      color: Colors.orange[900],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // === TAGS SECTION ===
  Widget _buildTagsSection(Recipe recipe) {
    final tags = _parseTags(recipe.tags);
    if (tags.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: tags.map((tag) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Text(
              '#$tag',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<String> _parseTags(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
    } catch (_) {
      return [];
    }
  }

  // === LINKED VEGETABLE ===
  Widget _buildLinkedVegetable(Recipe recipe) {
    // PocketBase returns "" instead of null for empty relations
    final vegId = recipe.vegetableId;
    if (vegId == null || vegId.isEmpty) return const SizedBox.shrink();

    final vegAsync = ref.watch(linkedVegetableProvider(vegId));

    return vegAsync.when(
      data: (vegetable) {
        if (vegetable == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () => context.push('/details/${vegetable.id}'),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.eco,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Passt zu:',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          vegetable.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  // === ACTION BUTTONS ===
  Widget _buildActionButtons(Recipe recipe, List<Ingredient> scaledIngredients) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.calendar_month),
            label: const Text('Zum Plan'),
            onPressed: () => _addToPlan(recipe),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.playlist_add),
            label: const Text('Einkauf'),
            onPressed: () => _addToShoppingList(scaledIngredients),
          ),
        ),
      ],
    );
  }

  // === INGREDIENTS SECTION ===
  Widget _buildIngredientsSection(
    Recipe recipe,
    List<Ingredient> scaledIngredients,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header mit Portionen-Stepper
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Zutaten',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            // Portionen-Stepper
            Container(
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 20),
                    onPressed: _currentServings > 1
                        ? () => setState(() => _currentServings--)
                        : null,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '$_currentServings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: _currentServings < 20
                        ? () => setState(() => _currentServings++)
                        : null,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Hinweis wenn skaliert
        if (_currentServings != recipe.servings) ...[
          const SizedBox(height: 4),
          Text(
            'Originalrezept: ${recipe.servings} Portionen',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],

        const SizedBox(height: 12),

        // Zutaten-Liste
        ...scaledIngredients.map((ing) => _buildIngredientRow(ing, theme)),
      ],
    );
  }

  Widget _buildIngredientRow(Ingredient ing, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '•  ',
            style: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (ing.amount != null || ing.unit != null)
            Text(
              '${_formatAmount(ing.amount)}${ing.unit ?? ''} ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: ing.item),
                  if (ing.note != null && ing.note!.isNotEmpty)
                    TextSpan(
                      text: ' (${ing.note})',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // === STEPS SECTION ===
  Widget _buildStepsSection(List<String> steps, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Zubereitung',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 16),
        ...steps.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${entry.key + 1}',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    entry.value,
                    style: const TextStyle(height: 1.5, fontSize: 15),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // === ACTIONS ===
  Future<void> _toggleFavorite(Recipe recipe) async {
    await ref.read(recipeRepositoryProvider).toggleFavorite(recipe.id);
  }

  Future<void> _addToPlan(Recipe recipe) async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) => AddToPlanDialog(
        recipeId: recipe.id,
        recipeTitle: recipe.title,
        defaultServings: _currentServings,
      ),
    );
    if (success == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Zum Wochenplan hinzugefügt')),
      );
    }
  }

  Future<void> _addToShoppingList(List<Ingredient> scaledIngredients) async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bitte melde dich an, um die Einkaufsliste zu nutzen.')),
        );
      }
      return;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Füge Zutaten hinzu...')),
    );

    int addedCount = 0;
    int skippedCount = 0;

    try {
      final controller = ref.read(nativeShoppingControllerProvider.notifier);

      for (final ing in scaledIngredients) {
        if (ing.item.isEmpty) {
          skippedCount++;
          continue;
        }

        await controller.addManualItem(
          ing.item,
          amount: ing.amount,
          unit: ing.unit,
        );
        addedCount++;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        final message = skippedCount > 0
            ? '$addedCount Zutaten hinzugefügt ($skippedCount übersprungen)'
            : '$addedCount Zutaten zur Einkaufsliste hinzugefügt';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // === HELPERS ===
  List<Ingredient> _parseIngredients(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list.map((e) {
        final map = e as Map<String, dynamic>;
        return Ingredient(
          item: (map['item'] ?? map['name'] ?? '') as String,
          amount: (map['amount'] is num) ? (map['amount'] as num).toDouble() : null,
          unit: map['unit'] as String?,
          note: map['note'] as String?,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  List<String> _parseSteps(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list.map((e) => e.toString()).toList();
    } catch (_) {
      return [];
    }
  }

  String _formatAmount(double? amount) {
    if (amount == null) return '';
    if (amount == amount.roundToDouble()) {
      return amount.toInt().toString();
    }
    return amount.toStringAsFixed(1).replaceAll(RegExp(r'\.0$'), '');
  }
}

// === WIDGETS ===
class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _MetaChip({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color ?? Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: color ?? Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final RecipeDifficulty difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final color = _parseHexColor(difficulty.color);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        difficulty.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  final RecipeCategory category;

  const _CategoryBadge({required this.category});

  @override
  Widget build(BuildContext context) {
    final color = _parseHexColor(category.color);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getCategoryIcon(category), size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            category.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(RecipeCategory cat) {
    return switch (cat) {
      RecipeCategory.main => Icons.restaurant,
      RecipeCategory.side => Icons.rice_bowl,
      RecipeCategory.dessert => Icons.cake,
      RecipeCategory.snack => Icons.cookie,
      RecipeCategory.breakfast => Icons.free_breakfast,
      RecipeCategory.soup => Icons.soup_kitchen,
      RecipeCategory.salad => Icons.eco,
    };
  }
}

Color _parseHexColor(String hex) {
  final hexCode = hex.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}
