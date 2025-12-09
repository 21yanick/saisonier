import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:saisonier/core/config/app_config.dart';
import 'package:saisonier/core/database/app_database.dart';
import 'package:saisonier/core/theme/app_theme.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:saisonier/features/seasonality/data/repositories/recipe_repository.dart';
import 'package:saisonier/features/seasonality/domain/enums/recipe_enums.dart';
import 'package:saisonier/features/ai/presentation/widgets/ai_fab.dart';
import 'package:saisonier/features/ai/presentation/widgets/recipe_generation_modal.dart';
import 'package:saisonier/features/ai/presentation/screens/recipe_review_screen.dart';

/// Filter options for the recipe list
enum RecipeFilter { all, mine, curated }

/// Sort options for the recipe list
enum RecipeSort {
  alphabetical('A-Z'),
  alphabeticalReverse('Z-A'),
  fastest('Schnellste'),
  easiest('Einfachste');

  final String label;
  const RecipeSort(this.label);
}

class MyRecipesScreen extends ConsumerStatefulWidget {
  const MyRecipesScreen({super.key});

  @override
  ConsumerState<MyRecipesScreen> createState() => _MyRecipesScreenState();
}

class _MyRecipesScreenState extends ConsumerState<MyRecipesScreen> {
  RecipeFilter _filter = RecipeFilter.all;
  RecipeCategory? _categoryFilter; // null = alle Kategorien
  RecipeSort _sort = RecipeSort.alphabetical;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final recipesAsync = ref.watch(allRecipesProvider);
    final userId = userAsync.valueOrNull?.id;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Rezepte'),
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          actions: [
            // Sort dropdown
            PopupMenuButton<RecipeSort>(
              icon: const Icon(Icons.sort),
              tooltip: 'Sortieren',
              onSelected: (sort) => setState(() => _sort = sort),
              itemBuilder: (context) => RecipeSort.values
                  .map((sort) => PopupMenuItem(
                        value: sort,
                        child: Row(
                          children: [
                            if (_sort == sort)
                              Icon(Icons.check, size: 18, color: Theme.of(context).primaryColor)
                            else
                              const SizedBox(width: 18),
                            const SizedBox(width: 8),
                            Text(sort.label),
                          ],
                        ),
                      ))
                  .toList(),
            ),
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () => context.push('/profile'),
            ),
          ],
        ),
      body: Column(
        children: [
          // Segmented Control
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: _buildSegmentedControl(context),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Rezept suchen...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),

          const SizedBox(height: 8),

          // Category Filter Chips
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // "Alle" Chip
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('Alle'),
                    selected: _categoryFilter == null,
                    onSelected: (_) => setState(() => _categoryFilter = null),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                // Category Chips
                ...RecipeCategory.values.map((cat) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(cat.label),
                        selected: _categoryFilter == cat,
                        onSelected: (_) => setState(() {
                          _categoryFilter = _categoryFilter == cat ? null : cat;
                        }),
                        visualDensity: VisualDensity.compact,
                      ),
                    )),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Recipe List
          Expanded(
            child: recipesAsync.when(
              data: (recipes) => _buildRecipeList(context, recipes, userId),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Fehler: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: userId != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 90), // Platz für Pills
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // AI Recipe Generator FAB
                  AIFab(
                    label: 'AI Rezept',
                    onPressed: () {
                      showRecipeGenerationModal(
                        context,
                        onRecipeGenerated: (recipe) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeReviewScreen(
                                generatedRecipe: recipe,
                                onRegenerate: () {
                                  showRecipeGenerationModal(
                                    context,
                                    onRecipeGenerated: (r) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RecipeReviewScreen(
                                            generatedRecipe: r,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  // Manual Recipe FAB
                  FloatingActionButton.extended(
                    heroTag: 'manual_recipe',
                    onPressed: () => context.push('/recipes/new'),
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    icon: const Icon(Icons.add),
                    label: const Text('Neues Rezept'),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildSegmentedControl(BuildContext context) {
    return SegmentedButton<RecipeFilter>(
      segments: const [
        ButtonSegment(value: RecipeFilter.all, label: Text('Alle')),
        ButtonSegment(value: RecipeFilter.mine, label: Text('Meine')),
        ButtonSegment(value: RecipeFilter.curated, label: Text('Entdecken')),
      ],
      selected: {_filter},
      onSelectionChanged: (selected) {
        setState(() => _filter = selected.first);
      },
      style: const ButtonStyle(
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildRecipeList(
      BuildContext context, List<Recipe> recipes, String? userId) {
    // Apply filters
    final filtered = recipes.where((r) {
      // Filter by source
      switch (_filter) {
        case RecipeFilter.all:
          break; // No filter
        case RecipeFilter.mine:
          if (r.source != 'user' || r.userId != userId) return false;
        case RecipeFilter.curated:
          if (r.source != 'curated') return false;
      }

      // Filter by category
      if (_categoryFilter != null) {
        if (r.category != _categoryFilter!.value) return false;
      }

      // Filter by search
      if (_searchQuery.isNotEmpty) {
        if (!r.title.toLowerCase().contains(_searchQuery.toLowerCase())) {
          return false;
        }
      }

      return true;
    }).toList();

    // Apply sorting
    switch (_sort) {
      case RecipeSort.alphabetical:
        filtered.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      case RecipeSort.alphabeticalReverse:
        filtered.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
      case RecipeSort.fastest:
        filtered.sort((a, b) =>
            (a.prepTimeMin + a.cookTimeMin).compareTo(b.prepTimeMin + b.cookTimeMin));
      case RecipeSort.easiest:
        filtered.sort((a, b) {
          const order = {'easy': 0, 'medium': 1, 'hard': 2};
          final aVal = order[a.difficulty] ?? 1;
          final bVal = order[b.difficulty] ?? 1;
          return aVal.compareTo(bVal);
        });
    }

    // Empty states
    if (filtered.isEmpty) {
      return _buildEmptyState(context, userId);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final recipe = filtered[index];
        final isOwn = recipe.source == 'user' && recipe.userId == userId;
        return _RecipeListTile(recipe: recipe, showEditButton: isOwn);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String? userId) {
    // Different empty states based on filter
    if (_searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Keine Rezepte gefunden',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Versuche einen anderen Suchbegriff',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    if (_filter == RecipeFilter.mine) {
      if (userId == null) {
        // Not logged in
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book_outlined, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 24),
                Text(
                  'Deine Rezeptsammlung',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Melde dich an, um eigene Rezepte zu erstellen.',
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: () => context.push('/profile'),
                  icon: const Icon(Icons.login),
                  label: const Text('Anmelden'),
                ),
              ],
            ),
          ),
        );
      }

      // Logged in but no recipes
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 24),
              Text(
                'Noch keine eigenen Rezepte',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Erstelle dein erstes Rezept!',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => context.push('/recipes/new'),
                icon: const Icon(Icons.add),
                label: const Text('Rezept erstellen'),
              ),
            ],
          ),
        ),
      );
    }

    // Generic empty (curated or all)
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Keine Rezepte vorhanden',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _RecipeListTile extends StatelessWidget {
  final Recipe recipe;
  final bool showEditButton;

  const _RecipeListTile({
    required this.recipe,
    required this.showEditButton,
  });

  @override
  Widget build(BuildContext context) {
    final difficulty = recipe.difficulty != null
        ? RecipeDifficulty.values.where((d) => d.name == recipe.difficulty).firstOrNull
        : null;
    final category = RecipeCategory.fromValue(recipe.category);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/recipes/${recipe.id}'),
        child: Row(
          children: [
            // Image
            SizedBox(
              width: 100,
              height: 100,
              child: recipe.image.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl:
                          '${AppConfig.pocketBaseUrl}/api/files/recipes/${recipe.id}/${recipe.image}',
                      fit: BoxFit.cover,
                      memCacheWidth: 200,
                      memCacheHeight: 200,
                      fadeInDuration: const Duration(milliseconds: 100),
                      placeholder: (_, __) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.restaurant, color: Colors.grey),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.restaurant, color: Colors.grey),
                      ),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.restaurant, size: 40, color: Colors.grey),
                    ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Time + Portionen
                    Row(
                      children: [
                        Icon(Icons.timer_outlined, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 3),
                        Text(
                          _buildTimeString(),
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        const SizedBox(width: 10),
                        Icon(Icons.people_outline, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 3),
                        Text(
                          '${recipe.servings}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Badges Row
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        // Kategorie Badge (prominent am Anfang)
                        if (category != null) _CategoryChip(category: category),
                        // Difficulty Badge
                        if (difficulty != null)
                          _DifficultyChip(difficulty: difficulty),
                        // Mein Rezept Badge
                        if (showEditButton)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Mein Rezept',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                        // Vegetarisch/Vegan
                        if (recipe.isVegan)
                          const _InfoChip(label: 'Vegan', color: Colors.green)
                        else if (recipe.isVegetarian)
                          const _InfoChip(label: 'Vegetarisch', color: Colors.green),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Edit button (only for own recipes)
            if (showEditButton)
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.push('/recipes/${recipe.id}/edit'),
              ),
          ],
        ),
      ),
    );
  }

  String _buildTimeString() {
    if (recipe.prepTimeMin > 0 && recipe.cookTimeMin > 0) {
      return '${recipe.prepTimeMin}+${recipe.cookTimeMin} Min';
    }
    return '${recipe.prepTimeMin + recipe.cookTimeMin} Min';
  }
}

class _DifficultyChip extends StatelessWidget {
  final RecipeDifficulty difficulty;

  const _DifficultyChip({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(difficulty.color);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        difficulty.label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;

  const _InfoChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final RecipeCategory category;

  const _CategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    final color = _parseHexColor(category.color);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getCategoryIcon(category), size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            category.label,
            style: TextStyle(
              fontSize: 10,
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

  static Color _parseHexColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
