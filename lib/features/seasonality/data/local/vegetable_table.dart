import 'package:drift/drift.dart';

class Vegetables extends Table {
  TextColumn get id => text()(); // Pocketbase ID
  TextColumn get name => text()();
  TextColumn get type => text()(); // enum stored as string
  TextColumn get description => text().nullable()();
  TextColumn get image => text()(); // filename
  TextColumn get hexColor => text()();
  TextColumn get months => text()(); // JSON string of [1, 2, 3]
  IntColumn get tier => integer()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
