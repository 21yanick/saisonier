import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:saisonier/core/database/app_database.dart';
import 'package:saisonier/features/seasonality/data/repositories/recipe_repository.dart';
import 'package:saisonier/features/seasonality/data/repositories/vegetable_repository.dart';
import 'package:saisonier/features/seasonality/presentation/widgets/gyroscope_card.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:saisonier/core/config/app_config.dart';

// Helper Provider to find a vegetable by ID from the full list
// Ideally we would fetch single, but since we have the full list cached in Riverpod usually, we can find it.
// Or we can add a 'watchVegetable(id)' to repo. 
// For now, let's just assume we pass the Vegetable object or fetch it.
// GoRouter passes ID.
final vegetableProvider = StreamProvider.family.autoDispose<Vegetable?, String>((ref, id) {
  // Hacky: access the database directly for single item to ensure fresh data
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.vegetables)..where((t) => t.id.equals(id))).watchSingleOrNull();
});

final recipesProvider = StreamProvider.family.autoDispose<List<Recipe>, String>((ref, vegetableId) {
  return ref.watch(recipeRepositoryProvider).watchRecipesForVegetable(vegetableId);
});

class DetailScreen extends ConsumerStatefulWidget {
  final String vegetableId;

  const DetailScreen({super.key, required this.vegetableId});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
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
    WakelockPlus.disable(); // Safety first
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vegAsync = ref.watch(vegetableProvider(widget.vegetableId));
    final recipesAsync = ref.watch(recipesProvider(widget.vegetableId));

    return Scaffold(
      body: vegAsync.when(
        data: (vegetable) {
          if (vegetable == null) return const Center(child: Text('Vegetable not found'));
          
          return CustomScrollView(
            slivers: [
              // Header
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(vegetable.name, 
                    style: const TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                    )
                  ),
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                       Hero(
                        tag: 'vegetable_${vegetable.id}', // Matches Grid
                        // tag: 'vegetable_feed_${vegetable.id}', // If coming from Feed? 
                        // Note: Hero tags must be unique per route push. 
                        // If we support deep linking or multiple paths, we might need a dynamic tag param.
                        // For MVP let's default to generic 'vegetable_ID' and hopefully Grid uses that.
                        // Grid uses 'vegetable_ID'. Feed uses 'vegetable_feed_ID'.
                        // Fix: We need to know source. Or just ignore Feed->Detail hero for now.
                        child: CachedNetworkImage(
                          imageUrl: '${AppConfig.pocketBaseUrl}/api/files/vegetables/${vegetable.id}/${vegetable.image}',
                          fit: BoxFit.cover,
                        ),
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
                  IconButton(
                    icon: Icon(vegetable.isFavorite ? Icons.favorite : Icons.favorite_border),
                    color: vegetable.isFavorite ? Colors.red : Colors.white,
                    tooltip: 'Favorite',
                    onPressed: () {
                      ref.read(vegetableRepositoryProvider).toggleFavorite(vegetable.id);
                    },
                  ),
                ],
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Season Bar
                      const Text('Saison', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 8),
                      _buildSeasonBar(vegetable),
                      const SizedBox(height: 24),

                      // Description
                      const Text('Info', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 8),
                      Text(vegetable.description ?? '', style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 32),

                      // Recipes
                      const Text('Rezepte', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 280,
                        child: recipesAsync.when(
                          data: (recipes) {
                            if (recipes.isEmpty) return const Center(child: Text('Keine Rezepte verfügbar.'));
                            return ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: recipes.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 16),
                              itemBuilder: (context, index) {
                                final recipe = recipes[index];
                                return GyroscopeCard(
                                  child: Container(
                                    width: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0,5)),
                                      ],
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: InkWell(
                                      onTap: () {
                                        context.push('/recipes/${recipe.id}');
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: CachedNetworkImage(
                                              imageUrl: '${AppConfig.pocketBaseUrl}/api/files/recipes/${recipe.id}/${recipe.image}',
                                              fit: BoxFit.cover,
                                              errorWidget: (_,__,___) => Container(color: Colors.grey[300]),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.all(12.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(recipe.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                                                  const Spacer(),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.timer, size: 14, color: Colors.grey),
                                                      const SizedBox(width: 4),
                                                      Text('${recipe.timeMin} Min', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, s) => Center(child: Text('Error: $e')),
                        ),
                      ),
                      
                      const SizedBox(height: 80), // Bottom padding
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

  Widget _buildSeasonBar(Vegetable veg) {
    // Parse months
    Set<int> months = {};
    try {
      final clean = veg.months.replaceAll('[', '').replaceAll(']', '');
      if (clean.isNotEmpty) {
        months = clean.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toSet();
      }
    } catch (_) {}

    final currentMonth = DateTime.now().month;
    const monthLabels = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];

    return Column(
      children: [
        Row(
          children: List.generate(12, (index) {
            final month = index + 1;
            final isActive = months.contains(month);
            final isCurrent = month == currentMonth;
            
            // Try parsing hex color. Default to Green.
            Color activeColor = const Color(0xFF4A6C48);
            try {
              activeColor = Color(int.parse(veg.hexColor.replaceFirst('#', '0xFF')));
            } catch (_) {}

            return Expanded(
              child: Column(
                children: [
                   // Bar Segment
                   Container(
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: isActive ? activeColor : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                      border: isCurrent ? Border.all(color: Colors.black, width: 1) : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Letter Label
                  Text(
                    monthLabels[index],
                    style: TextStyle(
                      fontSize: 10, 
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isCurrent ? Colors.black : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        if (months.contains(currentMonth)) ...[
           const SizedBox(height: 8),
           Row(
             children: [
               Icon(Icons.check_circle, size: 14, color: Theme.of(context).primaryColor),
               const SizedBox(width: 4),
               const Text("Aktuell Saison", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
             ],
           )
        ]
      ],
    );
  }
}
