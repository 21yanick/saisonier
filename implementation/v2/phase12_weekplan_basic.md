# Phase 12: Wochenplan Basic (Manuell)

**Status:** Done
**Ziel:** Manuelles Planen von Mahlzeiten für die Woche (Core Utility Feature).

## 1. Implementierte Features

### 1.1 Übersichts-Ansicht (Default)
- Kompakte 7-Tage Übersicht mit Tages-Kacheln
- Visueller Status pro Tag (●○○ Dots für Frühstück/Mittag/Abend)
- Heute-Highlighting mit Primary-Color Border
- Wochen-Navigation (vor/zurück)
- Statistik-Bar: Fortschrittsbalken + Rezepte/Eigene Zähler

### 1.2 Detail-Ansicht (Drill-Down)
- Tap auf Tag → Vollbild-Tagesansicht
- PageView mit Swipe zwischen Tagen
- Mini-Tab-Leiste oben für Quick-Navigation
- Grosse horizontale Meal-Karten
- Zurück-Button zur Übersicht

### 1.3 Meal Management
- ⋮ Menü-Button (statt Long-Press) für:
  - Rezept anzeigen
  - Portionen ändern
  - Entfernen
- "Zum Plan" Button auf Rezept-Detail-Seite
- Custom-Einträge ("Pizza bestellen", "Reste")
- Gestrichelte Empty-Slots mit "+ Hinzufügen"

## 2. Architektur

### 2.1 Data Model (KISS - Flach)

```dart
class PlannedMeals extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get slot => text()(); // 'breakfast', 'lunch', 'dinner'
  TextColumn get recipeId => text().nullable()();
  TextColumn get customTitle => text().nullable()();
  IntColumn get servings => integer().withDefault(const Constant(2))();
}
```

### 2.2 Dateistruktur

```
lib/features/weekplan/
├── data/
│   ├── local/planned_meal_table.dart
│   ├── remote/planned_meal_dto.dart
│   └── repositories/weekplan_repository.dart
├── domain/
│   ├── enums.dart (MealSlot)
│   └── date_utils.dart (WeekplanDateUtils)
├── presentation/
│   ├── screens/
│   │   ├── weekplan_screen.dart      # State: overview vs detail
│   │   └── add_meal_sheet.dart
│   ├── views/
│   │   ├── week_overview_view.dart   # Kompakte Wochen-Übersicht
│   │   └── day_detail_view.dart      # PageView für Tagesdetails
│   ├── state/
│   │   └── weekplan_controller.dart
│   └── widgets/
│       ├── day_tile.dart             # Tages-Kachel mit Dots
│       ├── week_stats_bar.dart       # Statistik-Leiste
│       ├── meal_card.dart            # Horizontale Meal-Karte
│       ├── empty_meal_slot.dart      # Gestrichelte Box
│       └── add_to_plan_dialog.dart   # Dialog von Rezept-Detail
```

### 2.3 UI Pattern: Drill-Down Navigation

```
┌──────────────────┐
│  Week Overview   │  ← Default View
│  (Compact Tiles) │
└────────┬─────────┘
         │ Tap on Day
         ▼
┌──────────────────┐
│   Day Detail     │  ← PageView with Swipe
│  (Full Cards)    │
└────────┬─────────┘
         │ Back Button
         ▼
┌──────────────────┐
│  Week Overview   │
└──────────────────┘
```

## 3. Navigation

- **4. Tab** in der Bottom Navigation: Saison | Katalog | Rezepte | **Plan**
- Route: `/weekplan`

## 4. UI-Komponenten

| Komponente | Beschreibung |
|------------|--------------|
| `DayTile` | Kompakte Tages-Kachel (56x72px) mit Tag-Nummer und ●○○ Dots |
| `WeekStatsBar` | Fortschrittsbalken (X/21) + Rezepte/Eigene Zähler |
| `MealCard` | Horizontales Layout: Bild 64x64, Titel, Zeit, Portionen, ⋮ Menü |
| `EmptyMealSlot` | Gestrichelte Box mit "+ Hinzufügen" |
| `DayTabBar` | Mini-Tabs mit Wochentagen und Tagesnummern |

## 5. Database

- **Schema Version:** 4
- **Tabelle:** `planned_meals`
- **Timezone:** UTC für konsistente Speicherung

## 6. Acceptance Criteria

- [x] User sieht Wochen-Übersicht mit allen 7 Tagen
- [x] User kann auf Tag tippen für Detail-Ansicht
- [x] User kann zwischen Tagen swipen
- [x] User kann Rezept/Custom-Eintrag hinzufügen
- [x] User kann Einträge löschen (⋮ Menü)
- [x] User kann Portionen ändern
- [x] Plan wird persistiert (Lokal + Cloud)
- [x] "Zum Plan" Button im Rezept-Detail
- [x] 4. Tab in Navigation

## 7. Best Practices Applied

| Prinzip | Implementation |
|---------|---------------|
| **KISS** | Drill-Down statt komplexer Toggle-UI |
| **YAGNI** | Keine Drag&Drop (für spätere Phase) |
| **DRY** | Shared WeekplanDateUtils |
| **Discoverable** | ⋮ Menü statt hidden Long-Press |
| **Mobile-First** | Swipe-Gesten, Touch-Targets ≥48dp |
