# Phase 12: Wochenplan Basic (Manuell)

**Status:** Geplant
**Ziel:** Manuelles Planen von Mahlzeiten für die Woche (Core Utility Feature).

## 1. Scope & Features

### 1.1 Kalender Ansicht
- 7-Tage Ansicht (Wochen-Swipe).
- Anzeige von Frühstück, Mittag, Abendessen (konfigurierbar).

### 1.2 Drag & Drop / Add Logic
- Rezepte aus der Sammlung (Kuratierte oder Eigene) in den Plan ziehen.
- "Zu Plan hinzufügen" Button auf der Rezept-Seite.
- Manuelle Einträge ("Pizza bestellen", "Reste").

### 1.3 Saison-Check
- Warnung oder Hinweis, wenn geplante Rezepte nicht-saisonale Zutaten enthalten (Optional).

## 2. Technical Details

### 2.1 Data Model

```dart
@freezed
class WeekPlan with _$WeekPlan {
  const factory WeekPlan({
    required String id,
    required String userId,
    required DateTime weekStart,
    required List<DayPlan> days,
  }) = _WeekPlan;
}

@freezed
class DayPlan with _$DayPlan {
  const factory DayPlan({
    required DateTime date,
    required Map<MealSlot, PlannedMeal?> meals,
  }) = _DayPlan;
}
```

### 2.2 State Management
- `WeekPlanController` (Riverpod) zum Laden/Speichern der aktuellen Woche.
- Optimistic UI updates für schnelles Drag & Drop.

## 3. UI/UX
- **Week View:** Horizontales Scrollen zwischen Wochen.
- **Empty Slots:** Visuell ansprechend ("Plan Lunch").
- **Mini-Cards:** Kleine Version der Rezept-Karten für den Plan.

## 4. Acceptance Criteria
- [ ] User sieht die aktuelle Woche.
- [ ] User kann ein Rezept einem Tag/Slot zuweisen.
- [ ] User kann Einträge verschieben oder löschen.
- [ ] Plan wird persistiert (Lokal + Cloud).
