# Phase 13: Einkaufslisten-Export

**Status:** Geplant
**Ziel:** Intelligente Aggregation von Zutaten aus dem Wochenplan für den Einkauf.

## 1. Scope & Features

### 1.1 Aggregation Logic
- Analysieren aller Mahlzeiten im Wochenplan (Zeitraum X bis Y).
- Zusammenfassen gleicher Zutaten (z.B. 2x 200g Rüebli = 400g Rüebli).
- Berücksichtigung von Einheiten (g, kg, ml, l, Stück).

### 1.2 Kategorisierung
- Zuordnung von Zutaten zu Einkaufskategorien (Gemüse, Milchprodukte, etc.).
- Basis: Statische Liste oder Mapping im Backend.

### 1.3 Export
- Batch-Export an Bring! (via Phase 10 Integration).
- Share-Sheet Export (Text/PDF) für andere Apps.

## 2. Technical Details

### 2.1 Services
- `ShoppingListService`: Nimmt `WeekPlan`, spuckt `ShoppingList` aus.
- `UnitConverter`: Hilfs-Klasse für "1kg + 500g = 1.5kg".

### 2.2 Data Model

```dart
@freezed
class ShoppingList with _$ShoppingList {
  const factory ShoppingList({
    required List<ShoppingItem> items,
  }) = _ShoppingList;
}

@freezed
class ShoppingItem with _$ShoppingItem {
  const factory ShoppingItem({
    required String name,
    required double amount,
    required String unit,
    required String category,
    required List<String> sourceRecipes // "Benötigt für: Risotto, Suppe"
  }) = _ShoppingItem;
}
```

## 3. UI/UX
- **Review Screen:** Vor dem Export kann der User die Liste prüfen.
- **Checkboxes:** Zum Abwählen von Dingen, die man schon hat.

## 4. Acceptance Criteria
- [ ] Gleiche Zutaten werden korrekt addiert.
- [ ] User kann Items vor dem Export abwählen.
- [ ] Erfolgreicher Export zu Bring!.
