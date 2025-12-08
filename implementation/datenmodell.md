# Saisonier Data Model & Schema

**Status:** Definitive
**Source of Truth:** PRD v1.0.0 + Vision v2.0
**Technology:** Pocketbase (Remote), Drift (Local Cache), Freezed (Domain)
**Schema Version:** 5

## 1. Domain Entities (Dart/Flutter)

The application uses `freezed` for immutable data classes in the Domain Layer.

### 1.1 `Vegetable`
Core entity representing a seasonal product.
```dart
@freezed
class Vegetable with _$Vegetable {
  const factory Vegetable({
    required String id,
    required String name,
    required VegetableType type, // Enum: vegetable, fruit, herb, nut, salad, mushroom
    required List<int> months, // [1, 2, 12] etc.
    required String description,
    required String hexColor, // "#RRGGBB"
    required String imageUrl, // Full URL to Pocketbase
    required int tier, // 1-4
    required bool isFavorite, // Local user state
  }) = _Vegetable;
}

enum VegetableType { vegetable, fruit, herb, nut, salad, mushroom }
```

### 1.2 `Recipe`
Recipe entity linked to a vegetable.
```dart
@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    required String id,
    required String title,
    required String vegetableId,
    required String imageUrl,
    required int timeMin,
    required List<Ingredient> ingredients,
    required List<String> steps,
  }) = _Recipe;
}

@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient({
    required String item,
    required String amount,
  }) = _Ingredient;
}
```

### 1.3 `UserProfile` (Phase 9)
User profile for personalization.
```dart
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String viserId,
    required int householdSize,
    required int childrenCount,
    List<int>? childrenAges,
    required List<Allergen> allergens,
    required DietType diet,
    List<String>? dislikes,
    required CookingSkill skill,
    required int maxCookingTimeMin,
    String? bringListUuid,
  }) = _UserProfile;
}

enum Allergen { gluten, lactose, nuts, eggs, soy, shellfish, fish }
enum DietType { omnivore, vegetarian, vegan, pescatarian, flexitarian }
enum CookingSkill { beginner, intermediate, advanced }
```

### 1.4 `PlannedMeal` (Phase 12)
Meal planning entity for week plans.
```dart
@freezed
class PlannedMealDto with _$PlannedMealDto {
  const factory PlannedMealDto({
    required String id,
    required String userId,
    required DateTime date,
    required String slot, // 'breakfast', 'lunch', 'dinner'
    String? recipeId,     // null = custom entry
    String? customTitle,  // "Pizza bestellen", "Reste"
    @Default(2) int servings,
  }) = _PlannedMealDto;
}

enum MealSlot { breakfast, lunch, dinner }
```

## 2. Remote Schema (Pocketbase)

### 2.1 Collection: `vegetables`
- **Type:** Base
- **API Rules:** List/View = Public (Empty rule), Create/Update/Delete = Admin only.

| Field | Type | Options | Notes |
| :--- | :--- | :--- | :--- |
| `name` | Text | Required | Index this field |
| `type` | Select | Options: `vegetable`, `fruit`, `herb`, `nut`, `salad`, `mushroom` | |
| `image` | File | Mime: image/* | Max size: 5MB |
| `months` | JSON | | Format: `[1,2,3]` |
| `hex_color` | Text | Regex: `^#[0-9a-fA-F]{6}$` | |
| `description` | Text | | |
| `tier` | Number | Min: 1, Max: 4 | Def: 4 |

### 2.2 Collection: `recipes` (Updated Phase 12b)
- **Type:** Base
- **API Rules:** List/View = Curated or Owner or Public, Create = Auth, Update/Delete = Owner.

| Field | Type | Options | Notes |
| :--- | :--- | :--- | :--- |
| `title` | Text | Required | |
| `description` | Text | | Phase 12b |
| `image` | File | | |
| `vegetable_id` | Relation | Collection: `vegetables`, Nullable | |
| `prep_time_min` | Number | Default: 0 | Phase 12b (replaces time_min) |
| `cook_time_min` | Number | Default: 0 | Phase 12b (replaces time_min) |
| `servings` | Number | Default: 4 | |
| `difficulty` | Select | `easy`, `medium`, `hard`, Nullable | |
| `category` | Select | `main`, `side`, `dessert`, `snack`, `breakfast`, `soup`, `salad` | Phase 12b |
| `ingredients` | JSON | | `[{item, amount, unit, note}]` |
| `steps` | JSON | | List of strings |
| `tags` | JSON | | `["schnell", "günstig"]` Phase 12b |
| `source` | Select | `curated`, `user` | |
| `user_id` | Relation | Collection: `users`, Nullable | |
| `is_public` | Bool | Default: false | |
| `is_vegetarian` | Bool | Default: false | Phase 12b |
| `is_vegan` | Bool | Default: false | Phase 12b |
| `contains_gluten` | Bool | Default: false | Phase 12b |
| `contains_lactose` | Bool | Default: false | Phase 12b |
| `contains_nuts` | Bool | Default: false | Phase 12b |
| `contains_eggs` | Bool | Default: false | Phase 12b |
| `contains_soy` | Bool | Default: false | Phase 12b |
| `contains_fish` | Bool | Default: false | Phase 12b |
| `contains_shellfish` | Bool | Default: false | Phase 12b |

### 2.3 Collection: `user_profiles` (Phase 9)
- **Type:** Base
- **API Rules:** Owner only.

| Field | Type | Options | Notes |
| :--- | :--- | :--- | :--- |
| `user_id` | Relation | Collection: `users` | Unique |
| `household_size` | Number | Default: 2 | |
| `children_count` | Number | Default: 0 | |
| `children_ages` | JSON | | Array of numbers |
| `allergens` | JSON | | Array of enum strings |
| `diet` | Select | `omnivore`, `vegetarian`, etc. | |
| `dislikes` | JSON | | Array of strings |
| `skill` | Select | `beginner`, `intermediate`, `advanced` | |
| `max_cooking_time_min` | Number | Default: 60 | |
| `bring_list_uuid` | Text | Nullable | Phase 10 |

### 2.4 Collection: `planned_meals` (Phase 12)
- **Type:** Base
- **API Rules:** Owner only.

| Field | Type | Options | Notes |
| :--- | :--- | :--- | :--- |
| `user_id` | Relation | Collection: `users` | Required |
| `date` | Date | | Day of meal |
| `slot` | Select | `breakfast`, `lunch`, `dinner` | |
| `recipe_id` | Relation | Collection: `recipes`, Nullable | Null = custom entry |
| `custom_title` | Text | Nullable | For non-recipe entries |
| `servings` | Number | Default: 2 | |

## 3. Local Schema (Drift Database)

For "Offline First" capability, we mirror the remote data into a local SQLite database using **Drift**.

**Current Schema Version: 5**

### 3.1 `Vegetables` Table
```dart
class Vegetables extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get description => text().nullable()();
  TextColumn get image => text()();
  TextColumn get hexColor => text()();
  TextColumn get months => text()(); // JSON "[1,2,3]"
  IntColumn get tier => integer()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
```

### 3.2 `Recipes` Table (Updated Phase 12b)
```dart
class Recipes extends Table {
  // === Basis ===
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get image => text()();

  // === Zeiten (getrennt, Phase 12b) ===
  IntColumn get prepTimeMin => integer().withDefault(const Constant(0))();
  IntColumn get cookTimeMin => integer().withDefault(const Constant(0))();

  // === Portionen & Schwierigkeit ===
  IntColumn get servings => integer().withDefault(const Constant(4))();
  TextColumn get difficulty => text().nullable()(); // 'easy' | 'medium' | 'hard'

  // === Inhalte (JSON) ===
  TextColumn get ingredients => text()(); // JSON: [{item, amount, unit, note}]
  TextColumn get steps => text()(); // JSON: [step1, step2, ...]

  // === Beziehungen ===
  TextColumn get vegetableId => text().nullable()();

  // === Ownership (Phase 11) ===
  TextColumn get source => text().withDefault(const Constant('curated'))();
  TextColumn get userId => text().nullable()();
  BoolColumn get isPublic => boolean().withDefault(const Constant(false))();

  // === Favoriten (lokal, Phase 12b) ===
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  // === Ernährung (Phase 12b) ===
  BoolColumn get isVegetarian => boolean().withDefault(const Constant(false))();
  BoolColumn get isVegan => boolean().withDefault(const Constant(false))();

  // === Allergene (Phase 12b) ===
  BoolColumn get containsGluten => boolean().withDefault(const Constant(false))();
  BoolColumn get containsLactose => boolean().withDefault(const Constant(false))();
  BoolColumn get containsNuts => boolean().withDefault(const Constant(false))();
  BoolColumn get containsEggs => boolean().withDefault(const Constant(false))();
  BoolColumn get containsSoy => boolean().withDefault(const Constant(false))();
  BoolColumn get containsFish => boolean().withDefault(const Constant(false))();
  BoolColumn get containsShellfish => boolean().withDefault(const Constant(false))();

  // === Kategorie & Tags (Phase 12b) ===
  TextColumn get category => text().nullable()();
  TextColumn get tags => text().withDefault(const Constant('[]'))(); // JSON array

  @override
  Set<Column> get primaryKey => {id};
}
```

### 3.3 `PlannedMeals` Table (Phase 12)
```dart
class PlannedMeals extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get slot => text()(); // 'breakfast', 'lunch', 'dinner'
  TextColumn get recipeId => text().nullable()();
  TextColumn get customTitle => text().nullable()();
  IntColumn get servings => integer().withDefault(const Constant(2))();

  @override
  Set<Column> get primaryKey => {id};
}
```

## 4. Data Sync Strategy (Repository Pattern)

1.  **App Start:**
    *   Initialize `AppDatabase` (Drift).
    *   Riverpod `vegetablesProvider` streams data **immediately** from SQLite (Zero latency) via `watch()`.
2.  **Background Sync:**
    *   Repo calls Pocketbase API `getFullList`.
    *   Upsert records to Drift using `batch.insertAllOnConflictUpdate`.
    *   Riverpod stream updates automatically with new data.
3.  **Images:**
    *   Use `cached_network_image`.
    *   Construct URL: `BASE_URL/api/files/COLLECTION/ID/FILENAME`.

## 5. Timezone Handling (PlannedMeals)

All dates in `planned_meals` are stored and queried as **UTC** to avoid timezone mismatches between PocketBase and local storage:

```dart
// Normalize to UTC when storing
final normalizedDate = DateTime.utc(date.year, date.month, date.day);

// Query with UTC range
final weekStartUtc = DateTime.utc(weekStart.year, weekStart.month, weekStart.day);
```

**Important:** PocketBase returns empty strings `""` instead of `null` for empty relation fields. Always check both:
```dart
if (meal.recipeId == null || meal.recipeId!.isEmpty) {
  // Handle custom entry
}
```
