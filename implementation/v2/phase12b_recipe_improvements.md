# Phase 12b: Recipe & Weekplan Improvements

## Übersicht

Umfassende Verbesserungen am Rezept-System:
- Portionen-Skalierung mit User Profile Integration
- Strukturiertes Zutaten-Format
- Getrennte Zeiten (Vorbereitung/Kochen)
- Ernährungs-Flags & Allergen-Tracking
- UI-Verbesserungen

---

## 1. Datenbank-Schema (Schema v5)

### 1.1 Recipe Table - Änderungen

```dart
class Recipes extends Table {
  // === Basis (unverändert) ===
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get image => text()();
  TextColumn get ingredients => text()();  // Format geändert!
  TextColumn get steps => text()();
  IntColumn get servings => integer().withDefault(const Constant(4))();
  TextColumn get difficulty => text().nullable()();
  TextColumn get vegetableId => text().nullable()();
  TextColumn get source => text().withDefault(const Constant('curated'))();
  TextColumn get userId => text().nullable()();
  BoolColumn get isPublic => boolean().withDefault(const Constant(false))();

  // === ENTFERNT ===
  // IntColumn get timeMin  ← wird durch prep+cook ersetzt

  // === NEU: Zeiten getrennt ===
  IntColumn get prepTimeMin => integer().withDefault(const Constant(0))();
  IntColumn get cookTimeMin => integer().withDefault(const Constant(0))();

  // === NEU: Favoriten ===
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  // === NEU: Ernährung ===
  BoolColumn get isVegetarian => boolean().withDefault(const Constant(false))();
  BoolColumn get isVegan => boolean().withDefault(const Constant(false))();

  // === NEU: Allergene (contains = true wenn enthalten) ===
  BoolColumn get containsGluten => boolean().withDefault(const Constant(false))();
  BoolColumn get containsLactose => boolean().withDefault(const Constant(false))();
  BoolColumn get containsNuts => boolean().withDefault(const Constant(false))();
  BoolColumn get containsEggs => boolean().withDefault(const Constant(false))();
  BoolColumn get containsSoy => boolean().withDefault(const Constant(false))();
  BoolColumn get containsFish => boolean().withDefault(const Constant(false))();
  BoolColumn get containsShellfish => boolean().withDefault(const Constant(false))();

  // === NEU: Kategorie & Tags ===
  TextColumn get category => text().nullable()();  // 'main','side','dessert','snack','breakfast','soup','salad'
  TextColumn get tags => text().withDefault(const Constant('[]'))();  // JSON: ["schnell","günstig"]
}
```

### 1.2 Migration (app_database.dart)

```dart
@override
int get schemaVersion => 5;

@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onUpgrade: (Migrator m, int from, int to) async {
      // ... existing migrations ...

      if (from < 5) {
        // Zeiten
        await m.addColumn(recipes, recipes.prepTimeMin);
        await m.addColumn(recipes, recipes.cookTimeMin);

        // Favoriten
        await m.addColumn(recipes, recipes.isFavorite);

        // Ernährung
        await m.addColumn(recipes, recipes.isVegetarian);
        await m.addColumn(recipes, recipes.isVegan);

        // Allergene
        await m.addColumn(recipes, recipes.containsGluten);
        await m.addColumn(recipes, recipes.containsLactose);
        await m.addColumn(recipes, recipes.containsNuts);
        await m.addColumn(recipes, recipes.containsEggs);
        await m.addColumn(recipes, recipes.containsSoy);
        await m.addColumn(recipes, recipes.containsFish);
        await m.addColumn(recipes, recipes.containsShellfish);

        // Kategorie & Tags
        await m.addColumn(recipes, recipes.category);
        await m.addColumn(recipes, recipes.tags);

        // Datenmigration: timeMin → cookTimeMin
        await customStatement(
          'UPDATE recipes SET cook_time_min = time_min WHERE time_min IS NOT NULL'
        );

        // timeMin Spalte entfernen (Drift macht das automatisch beim nächsten Build)
      }
    },
  );
}
```

### 1.3 PocketBase Schema

Gleiche Felder im Backend hinzufügen:
- `prep_time_min` (number)
- `cook_time_min` (number)
- `is_vegetarian`, `is_vegan` (boolean)
- `contains_gluten`, `contains_lactose`, etc. (boolean)
- `category` (select: main,side,dessert,snack,breakfast,soup,salad)
- `tags` (json)

---

## 2. Zutaten-Format

### 2.1 Neues Format

```json
[
  {
    "item": "Tomaten",
    "amount": 500,
    "unit": "g",
    "note": "gewürfelt"
  },
  {
    "item": "Olivenöl",
    "amount": 2,
    "unit": "EL",
    "note": null
  },
  {
    "item": "Salz",
    "amount": null,
    "unit": null,
    "note": "nach Geschmack"
  }
]
```

### 2.2 Ingredient Model

```dart
@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient({
    required String item,
    double? amount,      // null = "nach Geschmack"
    String? unit,
    String? note,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);
}
```

### 2.3 Einheiten

```dart
const availableUnits = [
  'g', 'kg', 'ml', 'l',
  'EL', 'TL',
  'Stück', 'Scheibe', 'Prise', 'Bund',
  'Dose', 'Packung', 'Becher', 'Glas',
];
```

### 2.4 Skalierung

```dart
List<Ingredient> scaleIngredients(
  List<Ingredient> ingredients,
  int baseServings,
  int targetServings,
) {
  if (baseServings == targetServings) return ingredients;
  final factor = targetServings / baseServings;

  return ingredients.map((ing) {
    if (ing.amount == null) return ing;

    final scaled = ing.amount! * factor;
    // Runden auf sinnvolle Werte
    final rounded = _roundAmount(scaled, ing.unit);

    return ing.copyWith(amount: rounded);
  }).toList();
}

double _roundAmount(double value, String? unit) {
  // g, ml: auf 5er/10er runden
  if (unit == 'g' || unit == 'ml') {
    return (value / 5).round() * 5.0;
  }
  // EL, TL: auf 0.5 runden
  if (unit == 'EL' || unit == 'TL') {
    return (value * 2).round() / 2;
  }
  // Stück: auf ganze Zahlen
  if (unit == 'Stück') {
    return value.round().toDouble();
  }
  // Default: eine Nachkommastelle
  return double.parse(value.toStringAsFixed(1));
}
```

---

## 3. UI-Änderungen

### 3.1 RecipeDetailScreen

```
┌─────────────────────────────────────────┐
│  [Bild mit Titel]                       │
├─────────────────────────────────────────┤
│  Beschreibung des Rezepts hier...       │  ← NEU
├─────────────────────────────────────────┤
│  ⏱ Vorb: 15 Min  |  🍳 Kochen: 30 Min  │  ← NEU (getrennt)
│  🟢 Einfach  |  🥕 Karotten            │  ← NEU (Difficulty + Gemüse-Link)
├─────────────────────────────────────────┤
│  [❤️ Favorit]  [Zum Plan]  [Einkauf]    │  ← NEU (Favorit-Button)
├─────────────────────────────────────────┤
│  Zutaten für  [-] 4 [+]  Portionen      │  ← NEU (Stepper)
├─────────────────────────────────────────┤
│  • 500g Tomaten                         │  ← Skaliert
│  • 2 EL Olivenöl                        │
│  • Salz nach Geschmack                  │
├─────────────────────────────────────────┤
│  Zubereitung                            │
│  1. ...                                 │
└─────────────────────────────────────────┘
```

**Änderungen:**
- `initialServings` Parameter (von URL Query)
- `_currentServings` State Variable
- Portionen-Stepper über Zutaten
- Beschreibung anzeigen
- Getrennte Zeiten anzeigen
- Difficulty-Badge
- Link zum Gemüse (wenn `vegetableId != null`)
- Favorit-Toggle
- Einkauf verwendet skalierte Mengen

### 3.2 RecipeEditorScreen

```
┌─────────────────────────────────────────┐
│  [Bild-Picker]                          │
├─────────────────────────────────────────┤
│  Titel: [________________________]      │
│  Beschreibung: [________________]       │  ← Textarea
├─────────────────────────────────────────┤
│  Vorbereitung: [15] Min                 │  ← NEU
│  Kochzeit:     [30] Min                 │  ← NEU
│  Portionen:    [4]                      │
│  Schwierigkeit: [Einfach ▼]             │
│  Kategorie:     [Hauptgericht ▼]        │  ← NEU
├─────────────────────────────────────────┤
│  Ernährung:                             │  ← NEU
│  [ ] Vegetarisch  [ ] Vegan             │
├─────────────────────────────────────────┤
│  Enthält:                               │  ← NEU
│  [ ] Gluten  [ ] Laktose  [ ] Nüsse     │
│  [ ] Eier    [ ] Soja     [ ] Fisch     │
├─────────────────────────────────────────┤
│  Zutaten                                │
│  [Menge] [Einheit▼] [Zutat    ] [Notiz] │  ← NEU (4 Felder)
│  [500  ] [g      ▼] [Tomaten  ] [     ] │
│  [2    ] [EL     ▼] [Olivenöl ] [     ] │
│                              [+ Zutat]  │
├─────────────────────────────────────────┤
│  Zubereitung                            │
│  ...                                    │
└─────────────────────────────────────────┘
```

### 3.3 MyRecipesScreen

**Änderungen:**
- Badge "Mein Rezept" für eigene Rezepte
- Difficulty-Indikator in Liste
- Getrennte Zeiten: "Vorb: 15 | Koch: 30 Min"

```
┌─────────────────────────────────────────┐
│ [Bild]  Tomatensuppe                    │
│         Vorb: 15 | Koch: 30 Min         │  ← Getrennt
│         🟢 Einfach · 4 Portionen        │  ← Difficulty
│         📝 Mein Rezept                  │  ← Badge (wenn eigenes)
└─────────────────────────────────────────┘
```

### 3.4 MealCard (Wochenplan)

**Änderung:** Navigation mit Portionen

```dart
// Vorher:
onTap: () => context.push('/recipes/${recipe.id}')

// Nachher:
onTap: () => context.push('/recipes/${recipe.id}?servings=${meal.servings}')
```

### 3.5 Router (app_router.dart)

```dart
GoRoute(
  path: '/recipes/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    final servingsParam = state.uri.queryParameters['servings'];
    final initialServings = servingsParam != null
        ? int.tryParse(servingsParam)
        : null;
    return RecipeDetailScreen(
      recipeId: id,
      initialServings: initialServings,
    );
  },
),
```

### 3.6 DetailScreen (Gemüse)

**Änderung:** Cooking Mode entfernen (gehört nur zu Rezepten)

---

## 4. User Profile Integration

### 4.1 Automatische Filterung

```dart
// recipe_repository.dart
Stream<List<Recipe>> watchFiltered({UserProfile? profile}) {
  var query = select(recipes);

  if (profile != null) {
    // Ernährungsweise
    if (profile.diet == DietType.vegan) {
      query = query..where((r) => r.isVegan.equals(true));
    } else if (profile.diet == DietType.vegetarian) {
      query = query..where((r) =>
        r.isVegetarian.equals(true) | r.isVegan.equals(true)
      );
    }

    // Allergien ausschließen
    for (final allergen in profile.allergens) {
      switch (allergen) {
        case Allergen.gluten:
          query = query..where((r) => r.containsGluten.equals(false));
        case Allergen.lactose:
          query = query..where((r) => r.containsLactose.equals(false));
        case Allergen.nuts:
          query = query..where((r) => r.containsNuts.equals(false));
        case Allergen.eggs:
          query = query..where((r) => r.containsEggs.equals(false));
        case Allergen.soy:
          query = query..where((r) => r.containsSoy.equals(false));
        case Allergen.fish:
          query = query..where((r) => r.containsFish.equals(false));
        case Allergen.shellfish:
          query = query..where((r) => r.containsShellfish.equals(false));
      }
    }

    // Zeitlimit
    query = query..where((r) =>
      (r.prepTimeMin + r.cookTimeMin).isSmallerOrEqualValue(profile.maxCookingTimeMin)
    );
  }

  return query.watch();
}
```

### 4.2 Portionen-Default

```dart
// In RecipeDetailScreen
final profile = ref.watch(userProfileControllerProvider).valueOrNull;
final defaultServings = widget.initialServings
    ?? profile?.householdSize
    ?? recipe.servings;
```

### 4.3 Allergen-Warnung (optional)

```dart
// Wenn User Allergie hat aber Rezept enthält Allergen
if (profile.allergens.contains(Allergen.gluten) && recipe.containsGluten) {
  // Warnung anzeigen
}
```

---

## 5. RecipeDto Anpassung

```dart
@freezed
class RecipeDto with _$RecipeDto {
  const factory RecipeDto({
    required String id,
    required String title,
    @Default('') String description,
    @Default('') String image,

    // Zeiten
    @JsonKey(name: 'prep_time_min') @Default(0) int prepTimeMin,
    @JsonKey(name: 'cook_time_min') @Default(0) int cookTimeMin,

    @Default(4) int servings,
    String? difficulty,
    String? category,
    @Default([]) List<dynamic> ingredients,
    @Default([]) List<dynamic> steps,
    @Default([]) List<dynamic> tags,  // PocketBase returns array, not string

    // Beziehungen
    @JsonKey(name: 'vegetable_id') String? vegetableId,

    // Ownership
    @Default('curated') String source,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'is_public') @Default(false) bool isPublic,

    // Ernährung
    @JsonKey(name: 'is_vegetarian') @Default(false) bool isVegetarian,
    @JsonKey(name: 'is_vegan') @Default(false) bool isVegan,

    // Allergene
    @JsonKey(name: 'contains_gluten') @Default(false) bool containsGluten,
    @JsonKey(name: 'contains_lactose') @Default(false) bool containsLactose,
    @JsonKey(name: 'contains_nuts') @Default(false) bool containsNuts,
    @JsonKey(name: 'contains_eggs') @Default(false) bool containsEggs,
    @JsonKey(name: 'contains_soy') @Default(false) bool containsSoy,
    @JsonKey(name: 'contains_fish') @Default(false) bool containsFish,
    @JsonKey(name: 'contains_shellfish') @Default(false) bool containsShellfish,
  }) = _RecipeDto;

  factory RecipeDto.fromJson(Map<String, dynamic> json) => _$RecipeDtoFromJson(json);
}
```

---

## 6. Implementierungsreihenfolge

### Step 1: Schema & Models ✅ (bereits erledigt)
- [x] `recipe_table.dart` - Neue Spalten, timeMin entfernen
- [x] `app_database.dart` - Schema v5 Migration
- [x] `recipe_dto.dart` - Neue Felder
- [x] `ingredient.dart` - Neues Model erstellen
- [x] `dart run build_runner build`
- [x] PocketBase Schema anpassen

### Step 2: Repository ✅ (bereits erledigt)
- [x] `recipe_repository.dart` - Sync mit neuen Feldern
- [x] `recipe_repository.dart` - `watchFiltered(profile)` Methode
- [x] `recipe_repository.dart` - `toggleFavorite()` Methode

### Step 3: RecipeDetailScreen ✅ (08.12.2025)
- [x] `initialServings` Parameter hinzufügen
- [x] Portionen-Stepper UI
- [x] Skalierungslogik (nutzt `scaleIngredients()`)
- [x] Beschreibung anzeigen
- [x] Getrennte Zeiten anzeigen (Vorb/Kochen/Gesamt)
- [x] Difficulty-Badge mit Farben
- [ ] Link zum Gemüse (optional, nicht kritisch)
- [x] Favorit-Toggle
- [x] Einkauf mit skalierten Mengen
- [x] Vegetarisch/Vegan Badges
- [x] Ingredient Notes anzeigen

### Step 4: Router ✅ (08.12.2025)
- [x] `app_router.dart` - Query-Parameter `servings` parsen

### Step 5: MealCard ✅ (08.12.2025)
- [x] Navigation mit `?servings=` Parameter

### Step 6: RecipeEditorScreen ✅ (08.12.2025)
- [x] Getrennte Zeit-Felder (Vorbereitung + Kochzeit)
- [x] Zutaten: 4 Felder (Menge, Einheit, Zutat, Notiz)
- [x] Einheiten-Dropdown
- [x] Ernährungs-Toggles (Vegetarisch/Vegan)
- [ ] Allergen-Checkboxen (optional, nicht kritisch für MVP)
- [x] Kategorie-Dropdown
- [x] Beschreibung-Feld

### Step 7: MyRecipesScreen ✅ (08.12.2025)
- [x] "Mein Rezept" Badge
- [x] Difficulty-Indikator (farbcodiert)
- [x] Getrennte Zeiten in Liste (15+30 Min Format)
- [x] Vegetarisch/Vegan Badges

### Step 8: DetailScreen (Gemüse)
- [ ] Cooking Mode entfernen (optional)

### Step 9: User Profile Integration
- [ ] Portionen-Default aus `householdSize`
- [ ] Optional: Automatische Filterung

---

## 7. Dateien

| Datei | Änderung |
|-------|----------|
| `recipe_table.dart` | Neue Spalten, timeMin entfernen |
| `app_database.dart` | Schema v5 Migration |
| `recipe_dto.dart` | Neue Felder |
| `recipe_dto.g.dart` | Regenerieren |
| `ingredient.dart` | NEU: Ingredient Model |
| `recipe_repository.dart` | Sync, Filter, Favoriten |
| `recipe_detail_screen.dart` | Komplett überarbeiten |
| `recipe_editor_screen.dart` | Neue Felder, Zutaten-UI |
| `my_recipes_screen.dart` | Badges, Zeiten |
| `app_router.dart` | Query-Parameter |
| `meal_card.dart` | Navigation mit servings |
| `detail_screen.dart` | Cooking Mode entfernen |
| `add_meal_sheet.dart` | Zeiten-Anzeige anpassen |

---

## 8. Enums & Konstanten

```dart
// recipe_enums.dart - Erweitern

enum RecipeCategory {
  main('Hauptgericht'),
  side('Beilage'),
  dessert('Dessert'),
  snack('Snack'),
  breakfast('Frühstück'),
  soup('Suppe'),
  salad('Salat');

  final String label;
  const RecipeCategory(this.label);
}

const availableUnits = [
  'g', 'kg', 'ml', 'l', 'EL', 'TL',
  'Stück', 'Scheibe', 'Prise', 'Bund',
  'Dose', 'Packung', 'Becher', 'Glas',
];

const availableTags = [
  'schnell', 'günstig', 'meal-prep', 'one-pot',
  'kinderfreundlich', 'party', 'gesund', 'comfort-food',
];
```
