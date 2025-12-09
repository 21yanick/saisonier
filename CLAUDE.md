# Saisonier - Claude Code Guide

> **Definitive Source of Truth** for development with Claude

---

## 1. Projekt-Essentials

### Was ist Saisonier?

Eine visuelle **Flutter-App** (iOS/Android) die den klassischen Schweizer Saisonkalender ins digitale Zeitalter bringt. Design-Philosophie: **"Tinder für Gemüse"** - immersives, bildgetriebenes Erlebnis statt langweiliger Tabellen.

**Status:** MVP Complete + Phase 2 (User Engagement) Complete

**Kernmerkmale:**

- **Visuelle Dominanz:** Bilder im Mittelpunkt, Text sekundär
- **Offline First:** Alle Daten lokal cached (SQLite), funktioniert im Supermarkt ohne Empfang
- **Schweizer Fokus:** CH-Nomenklatur (Wirz, Randen, Nüsslisalat), CH-Saison-Daten
- **Guest Mode:** App sofort nutzbar ohne Account, Login nur für Sync

---

## 2. Tech Stack

| Bereich             | Technologie                | Version/Details                            |
| ------------------- | -------------------------- | ------------------------------------------ |
| **Framework**       | Flutter                    | Latest Stable (Dart SDK >=3.0.0 <4.0.0)    |
| **State**           | Riverpod                   | `flutter_riverpod` + `riverpod_annotation` |
| **Routing**         | GoRouter                   | Type-safe, deklarativ                      |
| **Backend**         | PocketBase                 | Docker Container, Port 8091                |
| **Local DB**        | Drift (SQLite)             | Schema Version 6                           |
| **Data Classes**    | Freezed                    | Immutable + JSON Serialization             |
| **Code Generation** | build_runner               | `make generate`                            |
| **Images**          | cached_network_image       | Aggressive Caching                         |
| **Fonts**           | google_fonts (Outfit)      |                                            |
| **Sensors**         | sensors_plus               | Gyroskop für 3D-Tilt                       |
| **External API**    | Bring! (Einkaufsliste)     | Reverse-Engineered API                     |

---

## 3. Architecture Pattern

**Clean Architecture (Feature-First)** mit Riverpod

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                        │
│  Widgets & Screens (watch providers via ConsumerWidget)      │
└─────────────────────────┬───────────────────────────────────┘
                          │ watches
┌─────────────────────────▼───────────────────────────────────┐
│                    RIVERPOD CONTROLLERS                      │
│  AsyncNotifier / StateNotifier (generated with @riverpod)    │
└─────────────────────────┬───────────────────────────────────┘
                          │ calls
┌─────────────────────────▼───────────────────────────────────┐
│                    REPOSITORY LAYER                          │
│  VegetableRepository, RecipeRepository, etc.                 │
│  - Stream<List<T>> watchX() → Local DB (Drift)               │
│  - Future<void> sync() → Remote (PocketBase) → Local         │
└─────────────────────────┬───────────────────────────────────┘
                          │
         ┌────────────────┴────────────────┐
         │                                 │
┌────────▼────────┐               ┌────────▼────────┐
│  LOCAL (Drift)  │               │ REMOTE (PB SDK) │
│  SQLite Cache   │               │  PocketBase API │
└─────────────────┘               └─────────────────┘
```

---

## 4. Folder Structure

```
lib/
├── main.dart                    # Entry Point, ProviderScope
├── core/
│   ├── config/app_config.dart   # PocketBase URL (10.0.2.2 für Emulator)
│   ├── database/app_database.dart # Drift DB + Migration Strategy
│   ├── network/pocketbase_provider.dart
│   ├── router/app_router.dart   # GoRouter Routes
│   ├── storage/shared_prefs_provider.dart
│   └── theme/app_theme.dart     # Colors: primaryGreen #4A6C48, cream #FAFAF9
│
├── features/
│   ├── seasonality/             # Core Feature (Feed, Grid, Details)
│   │   ├── data/
│   │   │   ├── local/           # Drift Tables (vegetable_table.dart, recipe_table.dart)
│   │   │   ├── remote/          # DTOs (freezed)
│   │   │   └── repositories/    # VegetableRepository, RecipeRepository
│   │   ├── domain/
│   │   │   ├── models/          # Freezed Domain Models
│   │   │   └── enums/
│   │   └── presentation/
│   │       ├── screens/         # main_screen, feed_screen, grid_screen, detail_screen
│   │       └── widgets/         # gyroscope_card, seasonal_feed_item
│   │
│   ├── auth/                    # PocketBase Auth
│   │   ├── application/auth_sync_service.dart  # Favorite Sync on Login
│   │   ├── data/repositories/
│   │   └── presentation/
│   │
│   ├── profile/                 # User Profile (Haushalt, Allergien, Koch-Skills)
│   │   ├── domain/enums/profile_enums.dart  # Allergen, DietType, CookingSkill
│   │   └── ...
│   │
│   ├── recipes/                 # User Recipes (CRUD)
│   │   └── presentation/screens/my_recipes_screen, recipe_editor_screen
│   │
│   ├── weekplan/                # Wochenplan (Meal Planning)
│   │   ├── data/local/planned_meal_table.dart
│   │   └── presentation/
│   │
│   └── shopping_list/           # Einkaufsliste + Bring! Integration
│       ├── data/bring_api_client.dart
│       └── ...
│
backend/
├── docker-compose.yml           # PocketBase Container
├── pb_data/                     # PocketBase Data (SQLite + Files)
├── seed_images/                 # Original Images (PNG)
└── seed_images_compressed/      # WebP Compressed
```

---

## 5. Database Schema

### 5.1 Local (Drift) - Schema Version 6

**Tables:** `Vegetables`, `Recipes`, `PlannedMeals`, `ShoppingItems`

```dart
// Vegetables
id, name, type, description, image, hexColor, months (JSON), tier, isFavorite

// Recipes (erweitert Phase 12b)
id, title, description, image, prepTimeMin, cookTimeMin, servings, difficulty,
ingredients (JSON), steps (JSON), vegetableId, source, userId, isPublic,
isFavorite, isVegetarian, isVegan, contains* (Allergene), category, tags (JSON)

// PlannedMeals
id, userId, date, slot, recipeId (nullable), customTitle (nullable), servings

// ShoppingItems
id, userId, item, amount, unit, note, isChecked, sourceRecipeId, createdAt
```

### 5.2 Remote (PocketBase)

**Collections:** `vegetables`, `recipes`, `users`, `user_profiles`, `planned_meals`

**API Rules:**
- `vegetables`: Public Read, Admin Write
- `recipes`: Curated/Owner/Public Read, Auth Create, Owner Update/Delete
- `user_profiles`: Owner Only
- `planned_meals`: Owner Only

---

## 6. Data Sync Strategy

**Offline First Pattern:**

1. **App Start:** Riverpod streams data sofort aus SQLite (Zero Latency)
2. **Background Sync:** Repository ruft PocketBase API → Upsert zu Drift
3. **Favorites:** Local-First Toggle, Fire-and-Forget Remote Sync
4. **Login:** AuthSyncService merged Local + Remote Favorites (Union)

```dart
// Repository Pattern
Stream<List<Vegetable>> watchAll() → Drift Stream (reaktiv)
Future<void> sync() → PB.getFullList() → batch.insertAllOnConflictUpdate()
```

---

## 7. Key Implementation Patterns

### 7.1 Riverpod Provider Generation

```dart
@riverpod
VegetableRepository vegetableRepository(Ref ref) {
  return VegetableRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(pocketbaseProvider),
  );
}
```

### 7.2 Freezed DTOs

```dart
@freezed
class VegetableDto with _$VegetableDto {
  const factory VegetableDto({
    required String id,
    required String name,
    // ...
  }) = _VegetableDto;

  factory VegetableDto.fromJson(Map<String, dynamic> json) =>
      _$VegetableDtoFromJson(json);
}
```

### 7.3 Image URLs (PocketBase)

```dart
final imageUrl = '${AppConfig.pocketBaseUrl}/api/files/vegetables/$id/$filename';
```

### 7.4 Android Emulator Config

```dart
// AppConfig.pocketBaseUrl
if (Platform.isAndroid) return 'http://10.0.2.2:8091';
return 'http://127.0.0.1:8091';
```

### 7.5 Timezone Handling (PlannedMeals)

```dart
// IMMER UTC verwenden für Datum-Queries
final normalizedDate = DateTime.utc(date.year, date.month, date.day);
```

### 7.6 PocketBase Empty Relations

```dart
// PocketBase returns "" statt null für leere Relations
if (meal.recipeId == null || meal.recipeId!.isEmpty) {
  // Custom Entry
}
```

---

## 8. Development Commands

```bash
# App starten (Emulator)
./run.sh              # Lokale DB (localhost:8091)
./run.sh --live       # Live DB (saisonier-api.21home.ch)

# Makefile Shortcuts
make run              # = ./run.sh
make generate         # Code Generation (Riverpod, Freezed, Drift)
make watch            # build_runner watch mode
make test             # Flutter Tests
make clean            # Clean Build
make seed             # PocketBase Seed Data

# Emulator konfigurieren
export SAISONIER_EMULATOR="Pixel_8_Pro"  # Default: Pixel_8_Pro
```

---

## 9. Navigation & Screens

**MainScreen** mit PageView (5 Pages):
| Index | Name | Screen |
|-------|------|--------|
| 0 | Feed | FeedScreen (Saisonal, vertikaler Swipe) |
| 1 | Katalog | GridScreen (3-Spalten Grid, Suche) |
| 2 | Rezepte | MyRecipesScreen (User Recipes) |
| 3 | Plan | WeekplanScreen (Wochenplan) |
| 4 | Einkauf | ShoppingListScreen |

**Routes:**
- `/` → MainScreen
- `/details/:id` → DetailScreen (Gemüse)
- `/recipes/:id` → RecipeDetailScreen
- `/recipes/new` → RecipeEditorScreen
- `/recipes/:id/edit` → RecipeEditorScreen
- `/profile` → ProfileSettingsScreen
- `/profile/setup` → OnboardingWizardScreen

---

## 10. External Integrations

### Bring! API

Reverse-Engineered API für Einkaufslisten-Sync:
- Login: `POST /v2/bringauth` (email, password)
- Listen laden: `GET /bringusers/{uuid}/lists`
- Item hinzufügen: `PUT /v2/bringlists/{listUuid}`

Credentials werden via `flutter_secure_storage` gespeichert.

---

## 11. Design System

**Colors:**
- Primary Green: `#4A6C48` (Deep Green)
- Light Green: `#A6C48A`
- Cream: `#FAFAF9`
- Text: `#1C1C1E`

**Typography:** Google Fonts "Outfit"

**UI Elements:**
- Feed: Fullscreen Images mit Parallax
- Grid: 3 Spalten, Out-of-Season Items gedimmt
- Toggle Pill: Bottom Navigation (Saison/Rezepte/Plan/Einkauf)
- Recipe Cards: 3D Tilt mit Gyroskop

---

## 12. Known Quirks & Gotchas

1. **Linux Desktop Build:** Funktioniert nicht mit Flutter Snap (GLib-Konflikt). Android Emulator verwenden.

2. **Drift Migrations:** Schema ändern → `schemaVersion` erhöhen + `onUpgrade` implementieren

3. **PocketBase Relations:** Leere Relations = `""` nicht `null`

4. **Months JSON:** In SQLite als String gespeichert (`"[1,2,3]"`), Parsing in Dart

5. **Code Generation:** Nach Model-Änderungen immer `make generate` ausführen

---

## 13. Future Scope (Phase 3)

- AI Chef (Gemini API via PocketBase Proxy)
- AI Wochenplaner
- AI Rezept-Generator
- AI Bildgenerierung
- Premium/Pro Subscription

Siehe `implementation/vision.md` für Details.
