# Phase 11: User Recipes (Eigene Rezepte)

**Status:** Geplant
**Ziel:** Usern ermöglichen, ihre eigene Rezept-Sammlung in der App zu verwalten.

## 1. Scope & Features

### 1.1 Rezept Editor
- Formular zum Erfassen neuer Rezepte.
- Felder: Titel, Bild (Upload), Zutaten, Schritte, Zeit, Portionen.
- "Import" Funktion (Text-Paste Parsing - Future Scope, erstmal manuell).

### 1.2 "Meine Rezepte" Ansicht
- Neuer Tab oder Sektion in der Rezept-Übersicht.
- Liste aller selbst erstellten Rezepte.
- Suche & Filterung (auch für eigene Rezepte).

### 1.3 Daten-Erweiterung
- Erweiterung des `Recipe` Models um `source` (curated vs. user).
- Image Upload Handling in PocketBase.

## 2. Technical Details

### 2.1 Data Model Changes

```dart
enum RecipeSource { curated, user }

@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    // ... bestehende Felder
    required RecipeSource source,
    String? userId, // Owner ID für User Rezepte
    bool isPublic,  // Default false für User Rezepte
  }) = _Recipe;
}
```

### 2.2 Image Handling
- Verwendung des `image_picker` Packages.
- Upload zu PocketBase via API.
- Caching lokal.

## 3. UI/UX
- **FAB (Floating Action Button):** "+" Button in der Rezept-Übersicht.
- **Editor:** Clean UI, Zutaten hinzufügen wie in einer To-Do Liste.
- **Empty State:** "Erstelle dein erstes Rezept..."

## 4. Acceptance Criteria
- [ ] User kann ein neues Rezept mit Bild erstellen.
- [ ] User sieht seine Rezepte in einer Liste.
- [ ] User kann eigene Rezepte bearbeiten und löschen.
- [ ] Bilder werden korrekt hochgeladen und angezeigt.
