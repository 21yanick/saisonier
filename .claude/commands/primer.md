---
description: Verschafft Claude einen vollständigen Überblick über das Saisonier-Projekt
allowed-tools: ["Read", "Glob", "Grep", "Bash"]
argument-hint: "z.B. 'Feed verbessern', 'Neue Collection', 'Rezept-Feature', 'Shopping'"
---

# Saisonier Projekt-Primer

**Session-Fokus:** $ARGUMENTS

---

## 1. Projekt-Essentials (Inline-Kontext)

### Was ist Saisonier?

Visueller Saisonkalender für die Schweiz als Flutter-App. Design-Philosophie: **"Tinder für Gemüse"** - bildgetriebenes, immersives Erlebnis statt langweiliger Listen.

**Kernmerkmale:**
- **Visuelle Dominanz:** Bilder im Mittelpunkt, Text sekundär
- **Offline First:** SQLite Cache via Drift, funktioniert ohne Internet
- **Schweizer Fokus:** CH-Begriffe (Wirz, Randen, Nüsslisalat), CH-Saison-Daten
- **Guest Mode:** Sofort nutzbar, Login nur für Sync

### Tech Stack

| Bereich | Technologie |
|---------|-------------|
| **Framework** | Flutter (Dart >=3.0.0) |
| **State** | Riverpod + `@riverpod` Generator |
| **Backend** | PocketBase (Docker, Port 8091) |
| **Local DB** | Drift (SQLite, Schema v6) |
| **Data Classes** | Freezed |
| **Routing** | GoRouter |
| **External** | Bring! API (Einkaufsliste) |

### Architektur-Highlights

**Clean Architecture (Feature-First):**
```
Presentation → Riverpod Controllers → Repository → Local (Drift) / Remote (PocketBase)
```

**Data Sync Pattern:**
1. UI watched Drift Streams (sofort, reaktiv)
2. Repository synct im Hintergrund von PocketBase
3. Favorites: Local-First, Fire-and-Forget Cloud Sync

**Datenbank-Schema (Drift Tables):**
- `Vegetables` - Gemüse/Früchte mit Saison-Monaten
- `Recipes` - Rezepte (curated + user-created)
- `PlannedMeals` - Wochenplan
- `ShoppingItems` - Einkaufsliste

---

## 2. Projekt-Struktur

```
lib/
├── core/
│   ├── config/app_config.dart     # PocketBase URL
│   ├── database/app_database.dart # Drift DB + Migrations
│   ├── network/pocketbase_provider.dart
│   ├── router/app_router.dart     # Routes
│   └── theme/app_theme.dart       # Colors (#4A6C48, #FAFAF9)
│
├── features/
│   ├── seasonality/    # Feed, Grid, Details, Recipes for Vegetables
│   ├── auth/           # PocketBase Auth + Sync
│   ├── profile/        # User Settings (Haushalt, Allergien, Skills)
│   ├── recipes/        # User Recipe CRUD
│   ├── weekplan/       # Meal Planning
│   └── shopping_list/  # Einkaufsliste + Bring!
│
backend/
├── docker-compose.yml  # PocketBase Container
└── pb_data/           # Data + Backups
```

---

## 3. Fokussierte Analyse

**Lies zuerst `CLAUDE.md`** im Root für die komplette Architektur-Doku.

### Wenn $ARGUMENTS enthält "feed" | "grid" | "detail" | "seasonality"

**Relevante Files:**
- `lib/features/seasonality/presentation/screens/` - Feed, Grid, Detail Screens
- `lib/features/seasonality/data/repositories/vegetable_repository.dart`
- `lib/features/seasonality/presentation/widgets/` - Feed Items, Grid Items

**Fokus:**
- `watchSeasonal(month)` für saisonale Filterung
- Tier-basierte Sortierung (1=Hero, 4=Basic)
- Parallax & Haptic Feedback im Feed

---

### Wenn $ARGUMENTS enthält "rezept" | "recipe" | "cooking"

**Relevante Files:**
- `lib/features/seasonality/data/repositories/recipe_repository.dart`
- `lib/features/recipes/presentation/screens/` - Editor, My Recipes
- `lib/features/seasonality/presentation/screens/recipe_detail_screen.dart`
- `lib/features/seasonality/data/local/recipe_table.dart` - Schema

**Fokus:**
- User Recipes vs Curated (`source` field)
- Allergene & Ernährung (isVegan, containsGluten, etc.)
- Ingredient JSON Format: `[{item, amount, unit, note}]`

---

### Wenn $ARGUMENTS enthält "plan" | "weekplan" | "meal"

**Relevante Files:**
- `lib/features/weekplan/` - Komplettes Feature
- `lib/features/weekplan/data/repositories/weekplan_repository.dart`
- `lib/features/weekplan/presentation/screens/weekplan_screen.dart`

**Fokus:**
- PlannedMeal: date + slot (breakfast/lunch/dinner)
- recipeId nullable → Custom Title möglich
- Timezone: IMMER UTC für Queries!

---

### Wenn $ARGUMENTS enthält "shopping" | "einkauf" | "bring"

**Relevante Files:**
- `lib/features/shopping_list/` - Komplettes Feature
- `lib/features/shopping_list/data/bring_api_client.dart` - Bring! API
- `lib/features/profile/presentation/widgets/bring_auth_dialog.dart`

**Fokus:**
- ShoppingAggregator für Zutatenlisten-Merge
- Bring! API (reverse-engineered): login → loadLists → saveItem
- Credentials via `flutter_secure_storage`

---

### Wenn $ARGUMENTS enthält "auth" | "login" | "sync"

**Relevante Files:**
- `lib/features/auth/` - Auth Feature
- `lib/features/auth/application/auth_sync_service.dart` - Favorite Merge
- `lib/core/network/pocketbase_provider.dart`

**Fokus:**
- PocketBase Auth (Email/Password)
- AuthSyncService: Merged Local + Remote Favorites bei Login
- clearLocalData() bei Logout

---

### Wenn $ARGUMENTS enthält "profile" | "settings" | "onboarding"

**Relevante Files:**
- `lib/features/profile/` - Profile Feature
- `lib/features/profile/domain/models/user_profile.dart`
- `lib/features/profile/domain/enums/profile_enums.dart`

**Fokus:**
- UserProfile: householdSize, allergens, diet, skill, maxCookingTimeMin
- Enums: Allergen, DietType, CookingSkill
- Bring! Integration (bringEmail, bringListUuid)

---

### Wenn $ARGUMENTS enthält "database" | "schema" | "migration"

**Relevante Files:**
- `lib/core/database/app_database.dart` - Schema + Migrations
- `lib/features/*/data/local/*_table.dart` - Table Definitions
- `implementation/datenmodell.md` - Vollständige Schema-Doku

**Fokus:**
- Schema Version (aktuell: 6)
- Migration Strategy in `onUpgrade`
- Code Gen: `make generate` nach Änderungen

---

### Wenn $ARGUMENTS enthält "backend" | "pocketbase" | "api"

**Relevante Files:**
- `backend/docker-compose.yml`
- `lib/core/config/app_config.dart`
- `lib/features/*/data/remote/*_dto.dart` - DTOs

**Fokus:**
- PocketBase Collections: vegetables, recipes, users, user_profiles, planned_meals
- API Rules (Public Read vs Owner Only)
- Android Emulator: 10.0.2.2:8091

---

### Wenn $ARGUMENTS leer → Allgemeiner Check

```bash
# Projekt-Status
echo "📂 Features:"
ls -la lib/features

echo "\n🗄️ Schema Version:"
grep "schemaVersion =>" lib/core/database/app_database.dart

echo "\n🔧 Recent Changes:"
git log --oneline -5
```

---

## 4. Wichtige Patterns & Gotchas

### Code Generation
```bash
make generate  # Nach Model-Änderungen IMMER ausführen
```

### Drift Migration
```dart
// Schema ändern → schemaVersion++ → onUpgrade implementieren
if (from < 7) {
  await m.addColumn(recipes, recipes.newColumn);
}
```

### PocketBase Quirks
```dart
// Leere Relations sind "" nicht null
if (meal.recipeId == null || meal.recipeId!.isEmpty)

// Image URLs
'${AppConfig.pocketBaseUrl}/api/files/vegetables/$id/$filename'
```

### Timezone (PlannedMeals)
```dart
// IMMER UTC!
final date = DateTime.utc(year, month, day);
```

---

## 5. Dev Commands

| Command | Beschreibung |
|---------|--------------|
| `./run.sh` | App starten (Emulator) |
| `./run.sh --live` | Mit Live-DB |
| `make generate` | Code Generation |
| `make watch` | build_runner watch |
| `make test` | Tests |
| `make seed` | PocketBase Seed |

---

## 6. Output-Format

### Für Session-Fokus: $ARGUMENTS

**Bereich:** [Erkannter Fokus-Bereich]

**Relevante Files:**
- [Pfad 1]
- [Pfad 2]
- [Pfad 3]

**Aktueller Status:**
- [Was existiert bereits?]
- [Letzte Änderungen?]

**Architektur-Kontext:**
- [Welche Patterns relevant?]
- [Welche Dependencies?]

**Empfohlener Einstieg:**
[Konkreter erster Schritt zum Loslegen]

---

*Alle Antworten auf Deutsch. Prägnant und actionable.*
