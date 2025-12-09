import 'package:drift/drift.dart';

/// Local cache for AI profiles (Premium users only).
/// Mirrors the ai_profiles PocketBase collection.
class AIProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();

  // Preferences (JSON stored as text)
  TextColumn get cuisinePreferences =>
      text().withDefault(const Constant('[]'))();
  TextColumn get flavorProfile => text().withDefault(const Constant('[]'))();
  TextColumn get likes => text().withDefault(const Constant('[]'))();
  TextColumn get proteinPreferences =>
      text().withDefault(const Constant('[]'))();

  // Lifestyle
  TextColumn get budgetLevel => text().withDefault(const Constant('normal'))();
  TextColumn get mealPrepStyle => text().withDefault(const Constant('mixed'))();
  IntColumn get cookingDaysPerWeek =>
      integer().withDefault(const Constant(4))();

  // Goals
  TextColumn get healthGoals => text().withDefault(const Constant('[]'))();
  TextColumn get nutritionFocus =>
      text().withDefault(const Constant('balanced'))();

  // Equipment
  TextColumn get equipment => text().withDefault(const Constant('[]'))();

  // Learning Context (JSON object)
  TextColumn get learningContext =>
      text().withDefault(const Constant('{}'))();

  // Meta
  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
