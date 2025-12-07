import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/seasonality/data/local/vegetable_table.dart';

import '../../features/seasonality/data/local/recipe_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Vegetables, Recipes])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 2;

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
