import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saisonier/features/seasonality/data/repositories/vegetable_repository.dart';
import 'package:saisonier/features/seasonality/presentation/widgets/vegetable_grid_item.dart';

import '../../../../core/database/app_database.dart';

// =============================================================================
// ENUMS & CONSTANTS
// =============================================================================

enum SortOrder {
  nameAsc('A-Z'),
  nameDesc('Z-A'),
  tierAsc('Beliebtheit');

  final String label;
  const SortOrder(this.label);
}

/// Filter-Konfiguration für die Chips
const _typeFilters = [
  (type: null, label: 'Alle'),
  (type: 'vegetable', label: 'Gemüse'),
  (type: 'fruit', label: 'Früchte'),
  (type: 'salad', label: 'Salate'),
  (type: 'herb', label: 'Kräuter'),
  (type: 'meat', label: 'Fleisch'),
  (type: 'nut', label: 'Nüsse'),
];

// =============================================================================
// STATE PROVIDERS
// =============================================================================

/// Suchbegriff
final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

/// Ausgewählter Type-Filter (null = Alle)
final selectedTypeProvider = StateProvider.autoDispose<String?>((ref) => null);

/// Nur Favoriten anzeigen
final onlyFavoritesProvider = StateProvider.autoDispose<bool>((ref) => false);

/// Nur saisonale Items anzeigen
final onlySeasonalProvider = StateProvider.autoDispose<bool>((ref) => false);

/// Sortierreihenfolge
final sortOrderProvider = StateProvider.autoDispose<SortOrder>((ref) => SortOrder.nameAsc);

// =============================================================================
// COMBINED PROVIDER - Filtert und sortiert die Liste
// =============================================================================

final catalogVegetablesProvider = StreamProvider.autoDispose<List<Vegetable>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final selectedType = ref.watch(selectedTypeProvider);
  final onlyFavorites = ref.watch(onlyFavoritesProvider);
  final onlySeasonal = ref.watch(onlySeasonalProvider);
  final sortOrder = ref.watch(sortOrderProvider);
  final currentMonth = DateTime.now().month;

  return ref.watch(vegetableRepositoryProvider).watchAll().map((items) {
    final filtered = items.where((v) {
      // 1. Textsuche
      if (query.isNotEmpty && !v.name.toLowerCase().contains(query)) {
        return false;
      }

      // 2. Type-Filter
      if (selectedType != null && v.type != selectedType) {
        return false;
      }

      // 3. Nur Favoriten
      if (onlyFavorites && !v.isFavorite) {
        return false;
      }

      // 4. Nur Saison
      if (onlySeasonal && !_isInSeason(v, currentMonth)) {
        return false;
      }

      return true;
    }).toList()
      // Sortierung
      ..sort((a, b) {
        switch (sortOrder) {
          case SortOrder.nameAsc:
            return a.name.compareTo(b.name);
          case SortOrder.nameDesc:
            return b.name.compareTo(a.name);
          case SortOrder.tierAsc:
            final tierComp = a.tier.compareTo(b.tier);
            if (tierComp != 0) return tierComp;
            return a.name.compareTo(b.name);
        }
      });

    return filtered;
  });
});

/// Hilfsfunktion: Prüft ob ein Vegetable im aktuellen Monat Saison hat
bool _isInSeason(Vegetable v, int month) {
  try {
    final clean = v.months.replaceAll('[', '').replaceAll(']', '');
    if (clean.isEmpty) return false;
    final parts = clean.split(',').map((e) => int.tryParse(e.trim()) ?? 0);
    return parts.contains(month);
  } catch (_) {
    return false;
  }
}

// =============================================================================
// GRID SCREEN WIDGET
// =============================================================================

class GridScreen extends ConsumerWidget {
  const GridScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vegetablesAsync = ref.watch(catalogVegetablesProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        key: const PageStorageKey('grid_scroll'),
        slivers: [
          // Header mit Suche, Filter und Sort
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            floating: true,
            snap: true,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Suchfeld + Profil-Button
                      _SearchRow(),
                      const SizedBox(height: 12),
                      // Filter-Chips
                      _FilterChipsRow(),
                      const SizedBox(height: 8),
                      // Sort + Saison Toggle
                      _SortRow(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Ergebnis-Counter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: vegetablesAsync.when(
                data: (items) => Text(
                  '${items.length} Einträge',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
          ),

          // Grid
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: vegetablesAsync.when(
              data: (vegetables) {
                if (vegetables.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 48, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('Keine Ergebnisse gefunden'),
                        ],
                      ),
                    ),
                  );
                }
                return SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final veg = vegetables[index];
                      return VegetableGridItem(
                        vegetable: veg,
                        onTap: () => context.push('/details/${veg.id}'),
                      );
                    },
                    childCount: vegetables.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
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

// =============================================================================
// PRIVATE WIDGETS
// =============================================================================

class _SearchRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Suche...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              prefixIcon: const Icon(Icons.search),
              isDense: true,
            ),
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.person_outline),
          color: Colors.black87,
          onPressed: () => context.push('/profile'),
        ),
      ],
    );
  }
}

class _FilterChipsRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedTypeProvider);
    final onlyFavorites = ref.watch(onlyFavoritesProvider);

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Type-Filter Chips
          ..._typeFilters.map((filter) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(filter.label),
                  selected: selectedType == filter.type && !onlyFavorites,
                  onSelected: (_) {
                    ref.read(selectedTypeProvider.notifier).state = filter.type;
                    ref.read(onlyFavoritesProvider.notifier).state = false;
                  },
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
              )),

          // Favoriten-Chip (separat, da spezieller Filter)
          FilterChip(
            avatar: Icon(
              onlyFavorites ? Icons.favorite : Icons.favorite_border,
              size: 18,
              color: onlyFavorites ? Colors.white : Colors.red,
            ),
            label: const Text('Favoriten'),
            selected: onlyFavorites,
            onSelected: (selected) {
              ref.read(onlyFavoritesProvider.notifier).state = selected;
              if (selected) {
                ref.read(selectedTypeProvider.notifier).state = null;
              }
            },
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class _SortRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortOrder = ref.watch(sortOrderProvider);
    final onlySeasonal = ref.watch(onlySeasonalProvider);

    return Row(
      children: [
        // Sort Dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<SortOrder>(
              value: sortOrder,
              isDense: true,
              icon: const Icon(Icons.arrow_drop_down, size: 20),
              items: SortOrder.values
                  .map((order) => DropdownMenuItem(
                        value: order,
                        child: Text(order.label, style: const TextStyle(fontSize: 14)),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  ref.read(sortOrderProvider.notifier).state = value;
                }
              },
            ),
          ),
        ),

        const Spacer(),

        // Saison Toggle
        FilterChip(
          avatar: Icon(
            Icons.wb_sunny_outlined,
            size: 18,
            color: onlySeasonal ? Colors.white : Colors.orange,
          ),
          label: const Text('Saison'),
          selected: onlySeasonal,
          onSelected: (selected) {
            ref.read(onlySeasonalProvider.notifier).state = selected;
          },
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
