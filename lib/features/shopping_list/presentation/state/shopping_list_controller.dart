import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:saisonier/core/database/app_database.dart';
import 'package:saisonier/features/shopping_list/application/listing_service.dart';
import 'package:saisonier/features/shopping_list/data/repositories/shopping_list_repository.dart';
import 'package:saisonier/features/shopping_list/data/remote/shopping_item_dto.dart';
import 'package:saisonier/features/shopping_list/domain/shopping_aggregator.dart';
import 'package:saisonier/features/auth/presentation/controllers/auth_controller.dart';
import 'package:saisonier/features/weekplan/presentation/state/weekplan_controller.dart';
import 'package:saisonier/features/weekplan/data/repositories/weekplan_repository.dart';
import 'package:saisonier/features/seasonality/data/repositories/recipe_repository.dart';

part 'shopping_list_controller.g.dart';

/// Bring connection status controller (unchanged)
@riverpod
class ShoppingListController extends _$ShoppingListController {
  @override
  FutureOr<bool> build() async {
    return ref.watch(listingServiceProvider).isConnected;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(listingServiceProvider).login(email, password);
      return true;
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(listingServiceProvider).logout();
      return false;
    });
  }

  Future<void> addItem(String item, String spec) async {
    await ref.read(listingServiceProvider).addItem(item, spec);
  }
}

/// Stream provider for shopping items
@riverpod
Stream<List<ShoppingItem>> shoppingItems(Ref ref) {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null) return Stream.value([]);

  final repo = ref.watch(shoppingListRepositoryProvider);
  return repo.watchAll(user.id);
}

/// Controller for native shopping list operations
@riverpod
class NativeShoppingController extends _$NativeShoppingController {
  @override
  FutureOr<void> build() async {
    // Initial sync
    final user = ref.watch(currentUserProvider).valueOrNull;
    if (user != null) {
      await ref.read(shoppingListRepositoryProvider).sync(user.id);
    }
  }

  /// Add manual item
  Future<void> addManualItem(String item, {double? amount, String? unit, String? note}) async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;

    await ref.read(shoppingListRepositoryProvider).addItem(
      userId: user.id,
      item: item,
      amount: amount,
      unit: unit,
      note: note,
    );
  }

  /// Toggle item checked status
  Future<void> toggleItem(String id, bool isChecked) async {
    await ref.read(shoppingListRepositoryProvider).toggleChecked(id, isChecked);
  }

  /// Remove single item
  Future<void> removeItem(String id) async {
    await ref.read(shoppingListRepositoryProvider).removeItem(id);
  }

  /// Update item details
  Future<void> updateItem({
    required String id,
    required String item,
    double? amount,
    String? unit,
    String? note,
  }) async {
    await ref.read(shoppingListRepositoryProvider).updateItem(
      id: id,
      item: item,
      amount: amount,
      unit: unit,
      note: note,
    );
  }

  /// Remove all checked items
  Future<void> removeChecked() async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;

    await ref.read(shoppingListRepositoryProvider).removeCheckedItems(user.id);
  }

  /// Clear all items
  Future<void> clearAll() async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;

    await ref.read(shoppingListRepositoryProvider).clearAll(user.id);
  }

  /// Generate shopping list from current weekplan
  /// Returns number of items added
  Future<int> generateFromWeekplan({required bool replace}) async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return 0;

    final repo = ref.read(shoppingListRepositoryProvider);
    final recipeRepo = ref.read(recipeRepositoryProvider);
    final weekStart = ref.read(selectedWeekStartProvider);

    // Load existing items for merging (only when not replacing)
    List<ShoppingItem>? existingItems;
    if (!replace) {
      existingItems = await ref.read(shoppingItemsProvider.future);
    }

    // Get week's planned meals from weekplan
    final weekplanRepo = ref.read(weekplanRepositoryProvider);
    final plannedMeals = await weekplanRepo.watchWeek(user.id, weekStart).first;

    // Fetch recipes for all planned meals with recipe IDs
    final mealsWithRecipes = <(Recipe, int)>[];
    for (final meal in plannedMeals) {
      if (meal.recipeId != null) {
        final recipe = await recipeRepo.getRecipe(meal.recipeId!);
        if (recipe != null) {
          mealsWithRecipes.add((recipe, meal.servings));
        }
      }
    }

    // Early return if nothing to add and replacing
    if (mealsWithRecipes.isEmpty && replace) return 0;

    // Early return if nothing to merge
    if (mealsWithRecipes.isEmpty && (existingItems == null || existingItems.isEmpty)) return 0;

    // Aggregate ingredients (merges existing + new)
    final aggregator = ShoppingAggregator();
    final aggregated = aggregator.aggregateFromMeals(
      mealsWithRecipes,
      existingItems: existingItems,
    );

    // Clear all items (we'll re-add the aggregated ones)
    await repo.clearAll(user.id);

    // Create DTOs for batch insert
    final items = aggregated.map((agg) => ShoppingItemDto(
      id: '', // Will be generated
      userId: user.id,
      item: agg.item,
      amount: agg.totalAmount,
      unit: agg.unit,
      note: agg.note,
      isChecked: false,
      sourceRecipeId: agg.sourceRecipeIds.isNotEmpty ? agg.sourceRecipeIds.first : null,
      createdAt: DateTime.now(),
    )).toList();

    // Add items
    await repo.addItems(user.id, items);

    return items.length;
  }

  /// Export unchecked items to Bring
  /// Returns number of items exported
  Future<int> exportToBring() async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return 0;

    // Check Bring connection
    final isConnected = await ref.read(shoppingListControllerProvider.future);
    if (!isConnected) return 0;

    // Get unchecked items
    final items = await ref.read(shoppingItemsProvider.future);
    final uncheckedItems = items.where((item) => !item.isChecked).toList();

    int exported = 0;
    for (final item in uncheckedItems) {
      try {
        final spec = _formatSpec(item.amount, item.unit);
        await ref.read(listingServiceProvider).addItem(item.item, spec);
        exported++;
      } catch (_) {
        // Continue with other items
      }
    }

    return exported;
  }

  String _formatSpec(double? amount, String? unit) {
    if (amount == null) return '';

    final amountStr = amount == amount.roundToDouble()
        ? amount.toInt().toString()
        : amount.toStringAsFixed(1);

    if (unit == null || unit.isEmpty) return amountStr;
    return '$amountStr $unit';
  }
}
