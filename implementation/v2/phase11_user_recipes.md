# Phase 11: User Recipes (Eigene Rezepte)

**Status:** Done
**Ziel:** Usern ermöglichen, ihre eigene Rezept-Sammlung in der App zu verwalten.

## 1. Implementierte Features

### 1.1 Rezept Editor (`RecipeEditorScreen`)
- Formular zum Erfassen neuer Rezepte
- Felder: Titel, Bild (Upload via `image_picker`), Zutaten, Schritte, Zeit, Portionen, Schwierigkeit
- Dynamische Listen für Zutaten und Schritte (hinzufügen/entfernen)
- Edit-Modus für bestehende Rezepte
- Löschen-Funktion mit Bestätigung

### 1.2 "Meine Rezepte" Ansicht (`MyRecipesScreen`)
- **Neuer 3. Tab** in der Navigation: "Saison" | "Katalog" | "Rezepte"
- Liste aller selbst erstellten Rezepte mit Thumbnail
- Empty State für nicht-eingeloggte User (Login-Prompt)
- Empty State für User ohne Rezepte
- FAB zum Erstellen neuer Rezepte
- Direkter Zugang zum Editor via Edit-Button

### 1.3 Daten-Erweiterung
- `RecipeDto` erweitert: `source`, `userId`, `isPublic`, `servings`, `difficulty`
- Drift Schema v3 Migration
- PocketBase Security Rules für Owner-only Access

## 2. Architektur

```
lib/features/
├── recipes/                          # Neues Feature
│   └── presentation/
│       └── screens/
│           ├── my_recipes_screen.dart
│           └── recipe_editor_screen.dart
├── seasonality/
│   ├── data/
│   │   ├── local/recipe_table.dart   # Erweitert
│   │   ├── remote/recipe_dto.dart    # Erweitert
│   │   └── repositories/recipe_repository.dart  # CRUD hinzugefügt
│   └── domain/
│       └── enums/recipe_enums.dart   # Neu
```

## 3. Routes

| Route | Screen | Beschreibung |
|-------|--------|--------------|
| `/my-recipes` | MyRecipesScreen | 3. Tab - Rezeptliste |
| `/recipes/new` | RecipeEditorScreen | Neues Rezept erstellen |
| `/recipes/:id/edit` | RecipeEditorScreen | Rezept bearbeiten |

## 4. PocketBase Schema

```dart
// Neue Felder in 'recipes' Collection:
{"name": "source", "type": "select", "values": ["curated", "user"]},
{"name": "user_id", "type": "relation", "collectionId": "_pb_users_auth_"},
{"name": "is_public", "type": "bool"},
{"name": "servings", "type": "number"},
{"name": "difficulty", "type": "select", "values": ["easy", "medium", "hard"]}

// Security Rules:
"listRule": "source = 'curated' || user_id = @request.auth.id || (is_public = true && user_id != '')"
"createRule": "@request.auth.id != ''"
"updateRule": "source = 'curated' || user_id = @request.auth.id"
"deleteRule": "user_id = @request.auth.id"
```

## 5. Acceptance Criteria
- [x] User kann ein neues Rezept mit Bild erstellen
- [x] User sieht seine Rezepte in einer Liste
- [x] User kann eigene Rezepte bearbeiten und löschen
- [x] Bilder werden korrekt hochgeladen und angezeigt
- [x] Navigation erweitert auf 3 Tabs
- [x] Empty States für verschiedene Zustände

## 6. Technische Hinweise

### GoRouter: Route-Reihenfolge
Spezifische Routen müssen **VOR** parametrisierten Routen definiert werden:
```dart
// RICHTIG:
GoRoute(path: '/recipes/new', ...),      // Spezifisch zuerst
GoRoute(path: '/recipes/:id/edit', ...),
GoRoute(path: '/recipes/:id', ...),      // Parametrisiert zuletzt

// FALSCH: /recipes/:id würde "new" als ID matchen!
```

### FAB-Positionierung
Der FAB muss über der Toggle-Pill positioniert werden (bottom: 60):
```dart
floatingActionButton: Padding(
  padding: const EdgeInsets.only(bottom: 60),
  child: FloatingActionButton.extended(...),
)
```
