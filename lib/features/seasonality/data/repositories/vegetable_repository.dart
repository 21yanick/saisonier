import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/network/pocketbase_provider.dart';

import '../remote/vegetable_dto.dart';

part 'vegetable_repository.g.dart';

@riverpod
VegetableRepository vegetableRepository(Ref ref) {
  return VegetableRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(pocketbaseProvider),
  );
}

class VegetableRepository {
  final AppDatabase _db;
  final PocketBase _pb;

  VegetableRepository(this._db, this._pb);

  /// Offline-First: Stream from local DB
  Stream<List<Vegetable>> watchAll() {
    return (_db.select(_db.vegetables)
          ..orderBy([
            (t) => OrderingTerm(expression: t.name),
          ]))
        .watch();
  }

  /// Search by name (Case Insensitive)
  Stream<List<Vegetable>> watchFiltered(String query) {
    if (query.isEmpty) {
      return watchAll();
    }
    return (_db.select(_db.vegetables)
          ..where((t) => t.name.contains(query.toLowerCase()))
          ..orderBy([
            (t) => OrderingTerm(expression: t.name),
          ]))
        .watch();
  }

  /// Get seasonal vegetables for a specific month (1-12)
  /// Note: 'months' is stored as a JSON string "[1, 2, 12]" so we can't easily SQL filter.
  /// Ideally, we'd have a separate table for months or use a bitmask.
  /// For MVP with <100 items, filtering in Dart is acceptable.
  Stream<List<Vegetable>> watchSeasonal(int month) {
    return watchAll().map((items) {
      final filtered = items.where((v) {
        try {
          // Naive parsing
          final clean = v.months.replaceAll('[', '').replaceAll(']', '');
          if (clean.isEmpty) return false;
          final parts = clean.split(',').map((e) => int.tryParse(e.trim()) ?? 0);
          return parts.contains(month);
        } catch (_) {
          return false;
        }
      }).toList();

      // Sort by Tier (ascending: 1 is top) then Name
      filtered.sort((a, b) {
        final tierComp = a.tier.compareTo(b.tier);
        if (tierComp != 0) return tierComp;
        return a.name.compareTo(b.name);
      });

      return filtered;
    });
  }

  /// Toggles the favorite status of a vegetable
  Future<void> toggleFavorite(String id) async {
    final veg = await (_db.select(_db.vegetables)..where((t) => t.id.equals(id))).getSingleOrNull();
    if (veg != null) {
      // 1. Local Toggle
      final newStatus = !veg.isFavorite;
      await (_db.update(_db.vegetables)..where((t) => t.id.equals(id))).write(
        VegetablesCompanion(isFavorite: Value(newStatus)),
      );

      // 2. Remote Sync (Fire & Forget)
      if (_pb.authStore.isValid && _pb.authStore.model is RecordModel) {
        final user = _pb.authStore.model as RecordModel;
        try {
          // Fetch updated list of favorites
          final allFavs = await getFavoriteIds();
          await _pb.collection('users').update(user.id, body: {
            'favorites': allFavs,
          });
        } catch (e) {
          // Silent fail on network error, local state preserves it.
          // In a real app, we might queue this.
          // print('Remote toggle failed: $e');
        }
      }
    }
  }

  /// Syncs data from Pocketbase to Local DB
  ///
  /// This performs a full sync:
  /// 1. Fetches all vegetables from PocketBase
  /// 2. Upserts them into local DB (preserving favorite status)
  /// 3. Deletes local vegetables that no longer exist in PocketBase
  Future<void> sync() async {
    try {
      // 1. Fetch full list from Pocketbase
      final records = await _pb.collection('vegetables').getFullList();
      final dtos = records.map((r) => VegetableDto.fromJson(r.toJson())).toList();

      // Collect all IDs from PocketBase response
      final pbIds = dtos.map((dto) => dto.id).toSet();

      // 2. Get existing favorites map (to preserve local favorite status)
      final currentVegetables = await _db.select(_db.vegetables).get();
      final favoritesMap = {
        for (final v in currentVegetables) v.id: v.isFavorite
      };

      // 3. Transact to DB
      await _db.transaction(() async {
        // 3a. Upsert all records from PocketBase
        await _db.batch((batch) {
          batch.insertAllOnConflictUpdate(
            _db.vegetables,
            dtos.map((dto) {
              // Preserve favorite status if it exists, default to false
              final isFav = favoritesMap[dto.id] ?? false;

              return VegetablesCompanion(
                id: Value(dto.id),
                name: Value(dto.name),
                type: Value(dto.type),
                description: Value(dto.description),
                image: Value(dto.image),
                hexColor: Value(dto.hexColor),
                months: Value(jsonEncode(dto.months)),
                tier: Value(dto.tier),
                isFavorite: Value(isFav), // Preserved!
              );
            }).toList(),
          );
        });

        // 3b. Delete local records that no longer exist in PocketBase
        if (pbIds.isNotEmpty) {
          await (_db.delete(_db.vegetables)
                ..where((t) => t.id.isNotIn(pbIds)))
              .go();
        } else {
          await _db.delete(_db.vegetables).go();
        }
      });
    } catch (e) {
      // Fail silently when offline - keep existing local data
    }
  }

  /// Helper for AuthSync: Get all favorite IDs
  Future<List<String>> getFavoriteIds() async {
    final favorites = await (_db.select(_db.vegetables)
          ..where((t) => t.isFavorite.equals(true)))
        .get();
    return favorites.map((e) => e.id).toList();
  }

  /// Helper for AuthSync: Set favorite status directly
  Future<void> setFavorite(String id, bool isFavorite) async {
    await (_db.update(_db.vegetables)..where((t) => t.id.equals(id))).write(
      VegetablesCompanion(isFavorite: Value(isFavorite)),
    );
  }

  /// Helper for AuthSync: Clear all local favorites (Logout)
  Future<void> clearAllFavorites() async {
    await (_db.update(_db.vegetables)).write(
      const VegetablesCompanion(isFavorite: Value(false)),
    );
  }
}
