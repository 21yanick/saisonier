import 'package:drift/drift.dart';

class Recipes extends Table {
  // === Basis ===
  TextColumn get id => text()(); // Pocketbase ID
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get image => text()();

  // === Zeiten (getrennt) ===
  IntColumn get prepTimeMin => integer().withDefault(const Constant(0))();
  IntColumn get cookTimeMin => integer().withDefault(const Constant(0))();

  // === Portionen & Schwierigkeit ===
  IntColumn get servings => integer().withDefault(const Constant(4))();
  TextColumn get difficulty => text().nullable()(); // 'easy' | 'medium' | 'hard'

  // === Inhalte (JSON) ===
  TextColumn get ingredients => text()(); // JSON: [{item, amount, unit, note}]
  TextColumn get steps => text()(); // JSON: [step1, step2, ...]

  // === Beziehungen ===
  TextColumn get vegetableId => text().nullable()(); // FK to Vegetable

  // === Ownership ===
  TextColumn get source => text().withDefault(const Constant('curated'))(); // 'curated' | 'user'
  TextColumn get userId => text().nullable()(); // Owner for user recipes
  BoolColumn get isPublic => boolean().withDefault(const Constant(false))();

  // === Favoriten (lokal) ===
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  // === Ernährung ===
  BoolColumn get isVegetarian => boolean().withDefault(const Constant(false))();
  BoolColumn get isVegan => boolean().withDefault(const Constant(false))();

  // === Allergene (contains = true wenn enthalten) ===
  BoolColumn get containsGluten => boolean().withDefault(const Constant(false))();
  BoolColumn get containsLactose => boolean().withDefault(const Constant(false))();
  BoolColumn get containsNuts => boolean().withDefault(const Constant(false))();
  BoolColumn get containsEggs => boolean().withDefault(const Constant(false))();
  BoolColumn get containsSoy => boolean().withDefault(const Constant(false))();
  BoolColumn get containsFish => boolean().withDefault(const Constant(false))();
  BoolColumn get containsShellfish => boolean().withDefault(const Constant(false))();

  // === Kategorie & Tags ===
  TextColumn get category => text().nullable()(); // 'main','side','dessert','snack','breakfast','soup','salad'
  TextColumn get tags => text().withDefault(const Constant('[]'))(); // JSON: ["schnell","günstig"]

  @override
  Set<Column> get primaryKey => {id};
}
