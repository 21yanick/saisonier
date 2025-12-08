import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/seasonality/data/local/vegetable_table.dart';
import '../../features/seasonality/data/local/recipe_table.dart';
import '../../features/weekplan/data/local/planned_meal_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Vegetables, Recipes, PlannedMeals])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Schema v2 adds Recipes table
          await m.createTable(recipes);
        }
        if (from < 3) {
          // Schema v3: User Recipes - add new columns
          await m.addColumn(recipes, recipes.servings);
          await m.addColumn(recipes, recipes.source);
          await m.addColumn(recipes, recipes.userId);
          await m.addColumn(recipes, recipes.isPublic);
          await m.addColumn(recipes, recipes.difficulty);
        }
        if (from < 4) {
          // Schema v4: Week Plan - add PlannedMeals table
          await m.createTable(plannedMeals);
        }
        if (from < 5) {
          // Schema v5: Recipe Improvements
          // === Zeiten (getrennt) ===
          await m.addColumn(recipes, recipes.prepTimeMin);
          await m.addColumn(recipes, recipes.cookTimeMin);

          // === Favoriten (lokal) ===
          await m.addColumn(recipes, recipes.isFavorite);

          // === Ernährung ===
          await m.addColumn(recipes, recipes.isVegetarian);
          await m.addColumn(recipes, recipes.isVegan);

          // === Allergene ===
          await m.addColumn(recipes, recipes.containsGluten);
          await m.addColumn(recipes, recipes.containsLactose);
          await m.addColumn(recipes, recipes.containsNuts);
          await m.addColumn(recipes, recipes.containsEggs);
          await m.addColumn(recipes, recipes.containsSoy);
          await m.addColumn(recipes, recipes.containsFish);
          await m.addColumn(recipes, recipes.containsShellfish);

          // === Kategorie & Tags ===
          await m.addColumn(recipes, recipes.category);
          await m.addColumn(recipes, recipes.tags);

          // === Datenmigration: timeMin → cookTimeMin ===
          await customStatement(
            'UPDATE recipes SET cook_time_min = time_min WHERE time_min IS NOT NULL',
          );
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'saisonier.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

@riverpod
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}
