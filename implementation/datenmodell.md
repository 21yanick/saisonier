# Saisonier Data Model & Schema

**Status:** Definitive
**Source of Truth:** PRD v1.0.0
**Technology:** Pocketbase (Remote), Drift (Local Cache), Freezed (Domain)

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

### 2.2 Collection: `recipes`
- **Type:** Base
- **API Rules:** List/View = Public.

| Field | Type | Options | Notes |
| :--- | :--- | :--- | :--- |
| `vegetable_id` | Relation | Collection: `vegetables`, Max Select: 1 | Cascade Delete: False |
| `title` | Text | Required | |
| `image` | File | | |
| `time_min` | Number | | |
| `ingredients` | JSON | | List of objects |
| `steps` | JSON | | List of strings |

## 3. Local Schema (Drift Database)

For "Offline First" capability, we mirror the remote data into a local SQLite database using **Drift**.

### 3.1 `Vegetables` Table
```dart
class Vegetables extends Table {
  // Remote ID serves as Primary Key to ensure 1:1 mapping
  TextColumn get id => text()(); 
  
  TextColumn get name => text()();
  TextColumn get type => text()(); // Enum stored as String
  TextColumn get description => text().nullable()();
  TextColumn get image => text()(); // Stores filename
  TextColumn get hexColor => text()();
  
  // Stored as JSON String "[1,2,3]" because SQLite has no Array type
  TextColumn get months => text()(); 
  
  IntColumn get tier => integer()();
  
  // Local-only state
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
```

### 3.2 `Recipes` Table
```dart
class Recipes extends Table {
  TextColumn get id => text()();
  TextColumn get vegetableId => text().references(Vegetables, #id)(); // Foreign Key
  
  TextColumn get title => text()();
  TextColumn get image => text()();
  IntColumn get timeMin => integer()();
  
  // JSON Blobs
  TextColumn get ingredients => text()(); // List<Ingredient> as JSON
  TextColumn get steps => text()(); // List<String> as JSON

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
