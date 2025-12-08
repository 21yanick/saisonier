import 'dart:convert';
import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:http/http.dart' as http;
import '../../../../core/database/app_database.dart';
import '../../../../core/network/pocketbase_provider.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

import '../remote/recipe_dto.dart';

part 'recipe_repository.g.dart';

/// Provider for all available recipes (curated + user's own)
/// Used by MyRecipesScreen and AddMealSheet
final allRecipesProvider = StreamProvider.autoDispose<List<Recipe>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final user = ref.watch(currentUserProvider).valueOrNull;
  final userId = user?.id;

  return (db.select(db.recipes)
        ..where((t) =>
            t.source.equals('curated') |
            (userId != null ? t.userId.equals(userId) : const Constant(false)))
        ..orderBy([(t) => OrderingTerm.asc(t.title)]))
      .watch();
});

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

  /// Get recipes for a specific vegetable (curated only)
  Stream<List<Recipe>> watchRecipesForVegetable(String vegetableId) {
    return (_db.select(_db.recipes)
          ..where((t) => t.vegetableId.equals(vegetableId) & t.source.equals('curated')))
        .watch();
  }

  /// Get single recipe
  Stream<Recipe?> watchRecipe(String id) {
    return (_db.select(_db.recipes)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  /// Get all user recipes for a specific user
  Stream<List<Recipe>> watchUserRecipes(String userId) {
    return (_db.select(_db.recipes)
          ..where((t) => t.userId.equals(userId) & t.source.equals('user'))
          ..orderBy([(t) => OrderingTerm.desc(t.id)]))
        .watch();
  }

  /// Get recipe by ID (one-shot)
  Future<Recipe?> getRecipe(String id) {
    return (_db.select(_db.recipes)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Syncs recipes from Pocketbase (curated + user's own)
  ///
  /// This performs a full sync:
  /// 1. Fetches all visible recipes from PocketBase
  /// 2. Upserts them into local DB
  /// 3. Deletes local recipes that no longer exist in PocketBase
  ///
  /// PocketBase Security Rules determine visibility:
  /// - All curated recipes (public)
  /// - User's own recipes (when logged in)
  /// - Public user recipes from others
  Future<void> sync() async {
    try {
      final records = await _pb.collection('recipes').getFullList();
      final dtos = records.map((r) => RecipeDto.fromJson(r.toJson())).toList();

      // Collect all IDs from PocketBase response
      final pbIds = dtos.map((dto) => dto.id).toSet();

      await _db.transaction(() async {
        // 1. Upsert all records from PocketBase
        await _db.batch((batch) {
          batch.insertAllOnConflictUpdate(
            _db.recipes,
            dtos.map((dto) => _dtoToCompanion(dto)).toList(),
          );
        });

        // 2. Delete local records that no longer exist in PocketBase
        // This handles: deleted recipes, re-seeded DB with new IDs, etc.
        if (pbIds.isNotEmpty) {
          await (_db.delete(_db.recipes)
                ..where((t) => t.id.isNotIn(pbIds)))
              .go();
        } else {
          // PocketBase returned empty → clear all local recipes
          // This is correct: if PB has no recipes, local should match
          await _db.delete(_db.recipes).go();
        }
      });
    } catch (e) {
      // Fail silently when offline - keep existing local data
    }
  }

  /// Create a new user recipe
  Future<Recipe?> createUserRecipe({
    required String userId,
    required String title,
    required List<Map<String, dynamic>> ingredients,
    required List<String> steps,
    int timeMin = 30,
    int servings = 4,
    String? difficulty,
    String? vegetableId,
    File? imageFile,
  }) async {
    try {
      // Build body
      final body = <String, dynamic>{
        'title': title,
        'source': 'user',
        'user_id': userId,
        'is_public': false,
        'time_min': timeMin,
        'servings': servings,
        'ingredients': jsonEncode(ingredients),
        'steps': jsonEncode(steps),
      };
      if (difficulty != null) body['difficulty'] = difficulty;
      if (vegetableId != null) body['vegetable_id'] = vegetableId;

      // Create with or without image
      RecordModel record;
      if (imageFile != null) {
        record = await _pb.collection('recipes').create(
          body: body,
          files: [
            http.MultipartFile.fromBytes(
              'image',
              await imageFile.readAsBytes(),
              filename: 'recipe_image.jpg',
            ),
          ],
        );
      } else {
        record = await _pb.collection('recipes').create(body: body);
      }

      final dto = RecipeDto.fromJson(record.toJson());
      final companion = _dtoToCompanion(dto);

      // Insert locally
      await _db.into(_db.recipes).insertOnConflictUpdate(companion);

      return getRecipe(dto.id);
    } catch (e) {
      rethrow;
    }
  }

  /// Update a user recipe
  Future<Recipe?> updateUserRecipe({
    required String recipeId,
    required String title,
    required List<Map<String, dynamic>> ingredients,
    required List<String> steps,
    int timeMin = 30,
    int servings = 4,
    String? difficulty,
    String? vegetableId,
    File? imageFile,
  }) async {
    try {
      final body = <String, dynamic>{
        'title': title,
        'time_min': timeMin,
        'servings': servings,
        'ingredients': jsonEncode(ingredients),
        'steps': jsonEncode(steps),
      };
      if (difficulty != null) body['difficulty'] = difficulty;
      if (vegetableId != null) body['vegetable_id'] = vegetableId;

      RecordModel record;
      if (imageFile != null) {
        record = await _pb.collection('recipes').update(
          recipeId,
          body: body,
          files: [
            http.MultipartFile.fromBytes(
              'image',
              await imageFile.readAsBytes(),
              filename: 'recipe_image.jpg',
            ),
          ],
        );
      } else {
        record = await _pb.collection('recipes').update(recipeId, body: body);
      }

      final dto = RecipeDto.fromJson(record.toJson());
      final companion = _dtoToCompanion(dto);

      // Update locally
      await _db.into(_db.recipes).insertOnConflictUpdate(companion);

      return getRecipe(dto.id);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a user recipe
  Future<void> deleteUserRecipe(String recipeId) async {
    try {
      await _pb.collection('recipes').delete(recipeId);
      await (_db.delete(_db.recipes)..where((t) => t.id.equals(recipeId))).go();
    } catch (e) {
      rethrow;
    }
  }

  /// Convert DTO to Drift Companion
  RecipesCompanion _dtoToCompanion(RecipeDto dto) {
    return RecipesCompanion(
      id: Value(dto.id),
      vegetableId: Value(dto.vegetableId ?? ''),
      title: Value(dto.title),
      description: const Value(''),
      image: Value(dto.image),
      timeMin: Value(dto.timeMin),
      servings: Value(dto.servings),
      steps: Value(dto.steps is String ? dto.steps as String : jsonEncode(dto.steps)),
      ingredients: Value(dto.ingredients is String ? dto.ingredients as String : jsonEncode(dto.ingredients)),
      source: Value(dto.source),
      userId: Value(dto.userId),
      isPublic: Value(dto.isPublic),
      difficulty: Value(dto.difficulty),
    );
  }
}
