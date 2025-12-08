import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:saisonier/core/config/app_config.dart';
import 'package:saisonier/core/database/app_database.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:saisonier/features/seasonality/data/repositories/recipe_repository.dart';

/// Filter options for the recipe list
enum RecipeFilter { all, mine, curated }

class MyRecipesScreen extends ConsumerStatefulWidget {
  const MyRecipesScreen({super.key});

  @override
  ConsumerState<MyRecipesScreen> createState() => _MyRecipesScreenState();
}

class _MyRecipesScreenState extends ConsumerState<MyRecipesScreen> {
  RecipeFilter _filter = RecipeFilter.all;
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
        actions: [
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

          const SizedBox(height: 12),

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
              padding: const EdgeInsets.only(bottom: 60),
              child: FloatingActionButton.extended(
                onPressed: () => context.push('/recipes/new'),
                icon: const Icon(Icons.add),
                label: const Text('Neues Rezept'),
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

      // Filter by search
      if (_searchQuery.isNotEmpty) {
        if (!r.title.toLowerCase().contains(_searchQuery.toLowerCase())) {
          return false;
        }
      }

      return true;
    }).toList();

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
                      child:
                          const Icon(Icons.restaurant, size: 40, color: Colors.grey),
                    ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.timer_outlined,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.timeMin} Min',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.people_outline,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.servings} Portionen',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
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
}
