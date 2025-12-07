import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saisonier/features/seasonality/data/repositories/vegetable_repository.dart';
import 'package:saisonier/features/seasonality/presentation/widgets/vegetable_grid_item.dart';

import '../../../../core/database/app_database.dart';

/// Provider for the search query state
final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

/// Stream provider for filtered vegetables
final filteredVegetablesProvider = StreamProvider.autoDispose<List<Vegetable>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final repo = ref.watch(vegetableRepositoryProvider);
  return repo.watchFiltered(query);
});

class GridScreen extends ConsumerWidget {
  const GridScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vegetablesAsync = ref.watch(filteredVegetablesProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        key: const PageStorageKey('grid_scroll'),
        slivers: [
          // Search Bar
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.1),
            floating: true,
            snap: true,
            title: TextField(
              decoration: InputDecoration(
                hintText: 'Suche (z.B. Karotte)...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_outline),
                color: Colors.black87,
                onPressed: () => context.push('/profile'),
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // Bottom padding for pill
            sliver: vegetablesAsync.when(
              data: (vegetables) {
                if (vegetables.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('Keine Ergebnisse gefunden.')),
                  );
                }
                return SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final veg = vegetables[index];
                      return VegetableGridItem(
                        vegetable: veg,
                        onTap: () {
                          // Navigate to Details
                          context.push('/details/${veg.id}');
                        },
                      );
                    },
                    childCount: vegetables.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Responsive? 3 on huge screens? Fixed 2 for now.
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                );
              },
              error: (err, stack) => SliverFillRemaining(
                child: Center(child: Text('Error: $err')),
              ),
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
