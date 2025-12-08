import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/network/pocketbase_provider.dart';
import '../remote/planned_meal_dto.dart';
import '../../domain/enums.dart';

part 'weekplan_repository.g.dart';

@riverpod
WeekplanRepository weekplanRepository(Ref ref) {
  return WeekplanRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(pocketbaseProvider),
  );
}

class WeekplanRepository {
  final AppDatabase _db;
  final PocketBase _pb;

  WeekplanRepository(this._db, this._pb);

  /// Watch all planned meals for a specific week
  Stream<List<PlannedMeal>> watchWeek(String userId, DateTime weekStart) {
    // Use UTC to avoid timezone issues with PocketBase dates
    final weekStartUtc = DateTime.utc(weekStart.year, weekStart.month, weekStart.day);
    final weekEndUtc = weekStartUtc.add(const Duration(days: 7));

    return (_db.select(_db.plannedMeals)
          ..where((t) =>
              t.userId.equals(userId) &
              t.date.isBiggerOrEqualValue(weekStartUtc) &
              t.date.isSmallerThanValue(weekEndUtc))
          ..orderBy([(t) => OrderingTerm.asc(t.date)]))
        .watch();
  }

  /// Get planned meal for a specific date and slot
  Future<PlannedMeal?> getMeal(String userId, DateTime date, MealSlot slot) {
    final dayStart = DateTime.utc(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));
    return (_db.select(_db.plannedMeals)
          ..where((t) =>
              t.userId.equals(userId) &
              t.date.isBiggerOrEqualValue(dayStart) &
              t.date.isSmallerThanValue(dayEnd) &
              t.slot.equals(slot.name)))
        .getSingleOrNull();
  }

  /// Add a recipe to the plan
  Future<PlannedMeal?> addRecipeToSlot({
    required String userId,
    required DateTime date,
    required MealSlot slot,
    required String recipeId,
    int servings = 2,
  }) async {
    final normalizedDate = DateTime.utc(date.year, date.month, date.day);

    final record = await _pb.collection('planned_meals').create(body: {
      'user_id': userId,
      'date': normalizedDate.toIso8601String(),
      'slot': slot.name,
      'recipe_id': recipeId,
      'servings': servings,
    });

    final dto = PlannedMealDto.fromJson(record.toJson());
    await _db.into(_db.plannedMeals).insertOnConflictUpdate(_dtoToCompanion(dto));

    return (_db.select(_db.plannedMeals)..where((t) => t.id.equals(dto.id)))
        .getSingleOrNull();
  }

  /// Add a custom entry (no recipe)
  Future<PlannedMeal?> addCustomEntry({
    required String userId,
    required DateTime date,
    required MealSlot slot,
    required String customTitle,
    int servings = 2,
  }) async {
    final normalizedDate = DateTime.utc(date.year, date.month, date.day);

    final record = await _pb.collection('planned_meals').create(body: {
      'user_id': userId,
      'date': normalizedDate.toIso8601String(),
      'slot': slot.name,
      'custom_title': customTitle,
      'servings': servings,
    });

    final dto = PlannedMealDto.fromJson(record.toJson());
    await _db.into(_db.plannedMeals).insertOnConflictUpdate(_dtoToCompanion(dto));

    return (_db.select(_db.plannedMeals)..where((t) => t.id.equals(dto.id)))
        .getSingleOrNull();
  }

  /// Update servings for a planned meal
  Future<void> updateServings(String id, int servings) async {
    await _pb.collection('planned_meals').update(id, body: {
      'servings': servings,
    });

    await (_db.update(_db.plannedMeals)..where((t) => t.id.equals(id)))
        .write(PlannedMealsCompanion(servings: Value(servings)));
  }

  /// Remove a planned meal
  Future<void> removeMeal(String id) async {
    await _pb.collection('planned_meals').delete(id);
    await (_db.delete(_db.plannedMeals)..where((t) => t.id.equals(id))).go();
  }

  /// Move a meal to a different date/slot
  Future<void> moveMeal(String id, DateTime newDate, MealSlot newSlot) async {
    final normalizedDate = DateTime.utc(newDate.year, newDate.month, newDate.day);

    await _pb.collection('planned_meals').update(id, body: {
      'date': normalizedDate.toIso8601String(),
      'slot': newSlot.name,
    });

    await (_db.update(_db.plannedMeals)..where((t) => t.id.equals(id))).write(
      PlannedMealsCompanion(
        date: Value(normalizedDate),
        slot: Value(newSlot.name),
      ),
    );
  }

  /// Sync planned meals from PocketBase
  Future<void> sync(String userId) async {
    try {
      final records = await _pb.collection('planned_meals').getFullList(
            filter: 'user_id = "$userId"',
          );

      final dtos =
          records.map((r) => PlannedMealDto.fromJson(r.toJson())).toList();

      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          _db.plannedMeals,
          dtos.map((dto) => _dtoToCompanion(dto)).toList(),
        );
      });
    } catch (_) {
      // Fail silently for offline
    }
  }

  PlannedMealsCompanion _dtoToCompanion(PlannedMealDto dto) {
    return PlannedMealsCompanion(
      id: Value(dto.id),
      userId: Value(dto.userId),
      date: Value(dto.date),
      slot: Value(dto.slot),
      recipeId: Value(dto.recipeId),
      customTitle: Value(dto.customTitle),
      servings: Value(dto.servings),
    );
  }
}
