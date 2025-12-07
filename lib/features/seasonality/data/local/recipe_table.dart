import 'package:drift/drift.dart';

class Recipes extends Table {
  TextColumn get id => text()(); // Pocketbase ID
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get steps => text()(); // JSON
  TextColumn get ingredients => text()(); // JSON
  TextColumn get image => text()();
  IntColumn get timeMin => integer()();
  IntColumn get servings => integer().withDefault(const Constant(4))();
  TextColumn get vegetableId => text().nullable()(); // FK to Vegetable (nullable for user recipes)
  // Phase 11: User Recipes
  TextColumn get source => text().withDefault(const Constant('curated'))(); // 'curated' | 'user'
  TextColumn get userId => text().nullable()(); // Owner for user recipes
  BoolColumn get isPublic => boolean().withDefault(const Constant(false))();
  TextColumn get difficulty => text().nullable()(); // 'easy' | 'medium' | 'hard'

  @override
  Set<Column> get primaryKey => {id};
}
