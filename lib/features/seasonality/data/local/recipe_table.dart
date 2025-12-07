import 'package:drift/drift.dart';

class Recipes extends Table {
  TextColumn get id => text()(); // Pocketbase ID
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get steps => text()(); // JSON or Text
  TextColumn get ingredients => text()(); // JSON
  TextColumn get image => text()();
  IntColumn get timeMin => integer()();
  TextColumn get vegetableId => text()(); // FK to Vegetable
  
  @override
  Set<Column> get primaryKey => {id};
}
