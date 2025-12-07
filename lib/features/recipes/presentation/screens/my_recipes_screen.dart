import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:saisonier/core/config/app_config.dart';
import 'package:saisonier/core/database/app_database.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:saisonier/features/seasonality/data/repositories/recipe_repository.dart';

/// Provider for user recipes stream
final userRecipesProvider = StreamProvider.autoDispose<List<Recipe>>((ref) {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null) return Stream.value([]);
  return ref.watch(recipeRepositoryProvider).watchUserRecipes(user.id);
});

class MyRecipesScreen extends ConsumerWidget {
  const MyRecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final recipesAsync = ref.watch(userRecipesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Rezepte'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return _buildLoginPrompt(context);
          }
          return recipesAsync.when(
            data: (recipes) {
              if (recipes.isEmpty) {
                return _buildEmptyState(context);
              }
              return _buildRecipeList(context, ref, recipes);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Fehler: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Fehler: $e')),
      ),
      floatingActionButton: userAsync.valueOrNull != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 60), // Above the toggle pill
              child: FloatingActionButton.extended(
                onPressed: () => context.push('/recipes/new'),
                icon: const Icon(Icons.add),
                label: const Text('Neues Rezept'),
              ),
            )
          : null,
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Deine Rezeptsammlung',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Melde dich an, um eigene Rezepte zu erstellen und zu verwalten.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Noch keine Rezepte',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Erstelle dein erstes eigenes Rezept und baue deine persönliche Sammlung auf.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.push('/recipes/new'),
              icon: const Icon(Icons.add),
              label: const Text('Erstes Rezept erstellen'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeList(BuildContext context, WidgetRef ref, List<Recipe> recipes) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return _RecipeListTile(recipe: recipe);
      },
    );
  }
}

class _RecipeListTile extends StatelessWidget {
  final Recipe recipe;

  const _RecipeListTile({required this.recipe});

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
                        Icon(Icons.timer_outlined, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${recipe.timeMin} Min',
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.people_outline, size: 16, color: Colors.grey[600]),
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
            // Edit button
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
