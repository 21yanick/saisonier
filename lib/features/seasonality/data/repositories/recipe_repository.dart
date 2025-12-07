import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/network/pocketbase_provider.dart';

import '../remote/recipe_dto.dart';

part 'recipe_repository.g.dart';

@riverpod
RecipeRepository recipeRepository(Ref ref) {
  return RecipeRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(pocketbaseProvider),
  );
}

class RecipeRepository {
  final AppDatabase _db;
  final PocketBase _pb;

  RecipeRepository(this._db, this._pb);

  /// Get recipes for a specific vegetable
  Stream<List<Recipe>> watchRecipesForVegetable(String vegetableId) {
    return (_db.select(_db.recipes)
          ..where((t) => t.vegetableId.equals(vegetableId)))
        .watch();
  }

  /// Get single recipe
  Stream<Recipe?> watchRecipe(String id) {
    return (_db.select(_db.recipes)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  /// Syncs recipes from Pocketbase
  Future<void> sync() async {
    try {
      final records = await _pb.collection('recipes').getFullList();
      final dtos = records.map((r) => RecipeDto.fromJson(r.toJson())).toList();

      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          _db.recipes,
          dtos.map((dto) {
            return RecipesCompanion(
              id: Value(dto.id),
              vegetableId: Value(dto.vegetableId),
              title: Value(dto.title),
              description: const Value(''), // Not in DTO/PB yet, using empty string
              image: Value(dto.image),
              timeMin: Value(dto.timeMin),
              steps: Value(jsonEncode(dto.steps)),
              ingredients: Value(jsonEncode(dto.ingredients)),
            );
          }).toList(),
        );
      });
    } catch (e) {
      // print('Recipe Sync failed: $e');
      // rethrow; // Optional: Fail silently offline
    }
  }
}
