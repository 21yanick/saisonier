import 'package:drift/drift.dart';

/// Drift table for shopping list items
class ShoppingItems extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get item => text()(); // Ingredient name
  RealColumn get amount => real().nullable()(); // null = "nach Bedarf"
  TextColumn get unit => text().nullable()(); // g, ml, Stück, etc.
  TextColumn get note => text().nullable()();
  BoolColumn get isChecked => boolean().withDefault(const Constant(false))();
  TextColumn get sourceRecipeId => text().nullable()(); // Optional tracking
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
