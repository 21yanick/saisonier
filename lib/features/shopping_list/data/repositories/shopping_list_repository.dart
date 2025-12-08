import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/network/pocketbase_provider.dart';
import '../remote/shopping_item_dto.dart';

part 'shopping_list_repository.g.dart';

@riverpod
ShoppingListRepository shoppingListRepository(Ref ref) {
  return ShoppingListRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(pocketbaseProvider),
  );
}

class ShoppingListRepository {
  final AppDatabase _db;
  final PocketBase _pb;

  ShoppingListRepository(this._db, this._pb);

  /// Watch all shopping items for a user (sorted: unchecked first, then by creation)
  Stream<List<ShoppingItem>> watchAll(String userId) {
    return (_db.select(_db.shoppingItems)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([
            (t) => OrderingTerm.asc(t.isChecked),
            (t) => OrderingTerm.desc(t.createdAt),
          ]))
        .watch();
  }

  /// Add a single item
  Future<ShoppingItem?> addItem({
    required String userId,
    required String item,
    double? amount,
    String? unit,
    String? note,
    String? sourceRecipeId,
  }) async {
    final record = await _pb.collection('shopping_list_items').create(body: {
      'user_id': userId,
      'item': item,
      'amount': amount,
      'unit': unit,
      'note': note,
      'is_checked': false,
      'source_recipe_id': sourceRecipeId,
    });

    final dto = ShoppingItemDto.fromJson(record.toJson());
    await _db.into(_db.shoppingItems).insertOnConflictUpdate(
      ShoppingItemsCompanion(
        id: Value(dto.id),
        userId: Value(dto.userId),
        item: Value(dto.item),
        amount: Value(dto.amount),
        unit: Value(dto.unit),
        note: Value(dto.note),
        isChecked: Value(dto.isChecked),
        sourceRecipeId: Value(dto.sourceRecipeId),
        createdAt: Value(dto.createdAt),
      ),
    );

    return (_db.select(_db.shoppingItems)..where((t) => t.id.equals(dto.id)))
        .getSingleOrNull();
  }

  /// Add multiple items in batch (for weekplan import)
  Future<void> addItems(String userId, List<ShoppingItemDto> items) async {
    for (final item in items) {
      try {
        final record = await _pb.collection('shopping_list_items').create(body: {
          'user_id': userId,
          'item': item.item,
          'amount': item.amount,
          'unit': item.unit,
          'note': item.note,
          'is_checked': false,
          'source_recipe_id': item.sourceRecipeId,
        });

        final dto = ShoppingItemDto.fromJson(record.toJson());
        await _db.into(_db.shoppingItems).insertOnConflictUpdate(
          _dtoToCompanion(dto),
        );
      } catch (_) {
        // Continue with other items if one fails
      }
    }
  }

  /// Toggle checked status
  Future<void> toggleChecked(String id, bool isChecked) async {
    await _pb.collection('shopping_list_items').update(id, body: {
      'is_checked': isChecked,
    });

    await (_db.update(_db.shoppingItems)..where((t) => t.id.equals(id)))
        .write(ShoppingItemsCompanion(isChecked: Value(isChecked)));
  }

  /// Remove single item
  Future<void> removeItem(String id) async {
    await _pb.collection('shopping_list_items').delete(id);
    await (_db.delete(_db.shoppingItems)..where((t) => t.id.equals(id))).go();
  }

  /// Remove all checked items
  Future<void> removeCheckedItems(String userId) async {
    // Get all checked items
    final checkedItems = await (_db.select(_db.shoppingItems)
          ..where((t) => t.userId.equals(userId) & t.isChecked.equals(true)))
        .get();

    // Delete from PocketBase
    for (final item in checkedItems) {
      try {
        await _pb.collection('shopping_list_items').delete(item.id);
      } catch (_) {
        // Continue if item doesn't exist in PB
      }
    }

    // Delete from local DB
    await (_db.delete(_db.shoppingItems)
          ..where((t) => t.userId.equals(userId) & t.isChecked.equals(true)))
        .go();
  }

  /// Clear all items for user
  Future<void> clearAll(String userId) async {
    // IMPORTANT: Fetch items from PocketBase, not local DB (which may be empty)
    try {
      final records = await _pb.collection('shopping_list_items').getFullList(
        filter: 'user_id = "$userId"',
      );

      // Delete from PocketBase
      for (final record in records) {
        try {
          await _pb.collection('shopping_list_items').delete(record.id);
        } catch (_) {
          // Continue if item doesn't exist in PB
        }
      }
    } catch (_) {
      // Handle offline case - continue with local deletion
    }

    // Delete from local DB
    await (_db.delete(_db.shoppingItems)
          ..where((t) => t.userId.equals(userId)))
        .go();
  }

  /// Sync with PocketBase
  Future<void> sync(String userId) async {
    try {
      final records = await _pb.collection('shopping_list_items').getFullList(
            filter: 'user_id = "$userId"',
          );

      final dtos =
          records.map((r) => ShoppingItemDto.fromJson(r.toJson())).toList();

      final pbIds = dtos.map((dto) => dto.id).toSet();

      await _db.transaction(() async {
        // Upsert all records from PocketBase
        await _db.batch((batch) {
          batch.insertAllOnConflictUpdate(
            _db.shoppingItems,
            dtos.map((dto) => _dtoToCompanion(dto)).toList(),
          );
        });

        // Delete local records that no longer exist in PocketBase
        if (pbIds.isNotEmpty) {
          await (_db.delete(_db.shoppingItems)
                ..where((t) => t.userId.equals(userId) & t.id.isNotIn(pbIds)))
              .go();
        } else {
          // PocketBase returned empty → clear all local items for user
          await (_db.delete(_db.shoppingItems)
                ..where((t) => t.userId.equals(userId)))
              .go();
        }
      });
    } catch (_) {
      // Fail silently for offline - keep existing local data
    }
  }

  ShoppingItemsCompanion _dtoToCompanion(ShoppingItemDto dto) {
    return ShoppingItemsCompanion(
      id: Value(dto.id),
      userId: Value(dto.userId),
      item: Value(dto.item),
      amount: Value(dto.amount),
      unit: Value(dto.unit),
      note: Value(dto.note),
      isChecked: Value(dto.isChecked),
      sourceRecipeId: Value(dto.sourceRecipeId),
      createdAt: Value(dto.createdAt),
    );
  }
}
