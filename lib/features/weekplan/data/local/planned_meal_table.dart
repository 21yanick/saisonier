import 'package:drift/drift.dart';

/// Drift table for planned meals
/// Simple flat structure - weeks are derived from date ranges
class PlannedMeals extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get slot => text()(); // 'breakfast', 'lunch', 'dinner'
  TextColumn get recipeId => text().nullable()(); // null = custom entry
  TextColumn get customTitle => text().nullable()(); // "Pizza bestellen", "Reste"
  IntColumn get servings => integer().withDefault(const Constant(2))();

  @override
  Set<Column> get primaryKey => {id};
}
