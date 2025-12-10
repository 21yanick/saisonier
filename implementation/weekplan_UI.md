# Weekplan UI Redesign Spec

> Kompakte Spezifikation für die Neugestaltung des Wochenplan-Screens

---

## 1. Übersicht

### Ziel
Ersetze das aktuelle 5-2 Grid-Layout durch einen **horizontalen Scroll-Kalender** (Google Calendar Style) mit **Bottom Sheet** für Tagesdetails.

### Design-Prinzipien
- **KISS**: Einfache, bewährte Flutter-Widgets
- **YAGNI**: Nur das bauen, was wir brauchen
- **DRY**: Bestehende Widgets (MealCard, EmptyMealSlot) wiederverwenden

---

## 2. Architektur

### Neue Widgets

```
weekplan/presentation/
├── views/
│   └── week_overview_view.dart     # UPDATE: Neues Layout
├── widgets/
│   ├── scroll_week_calendar.dart   # NEU: Horizontaler Kalender
│   ├── day_card.dart               # NEU: Einzelne Tageskarte
│   ├── day_detail_sheet.dart       # NEU: Bottom Sheet für Tag
│   ├── day_tile.dart               # ENTFERNEN (ersetzt durch day_card)
│   ├── meal_card.dart              # BEHALTEN
│   ├── empty_meal_slot.dart        # BEHALTEN
│   └── week_stats_bar.dart         # BEHALTEN
└── views/
    └── day_detail_view.dart        # ENTFERNEN (ersetzt durch Sheet)
```

### Datenfluss (unverändert)
```
weekPlannedMealsProvider → ScrollWeekCalendar → DayCard
                                              → DayDetailSheet → MealCard
```

---

## 3. ScrollWeekCalendar Widget

### Spezifikation

```dart
class ScrollWeekCalendar extends ConsumerStatefulWidget {
  final List<PlannedMeal> meals;
  final void Function(DateTime date) onDayTap;
  final void Function(DateTime date, MealSlot slot) onAddMeal;
}
```

### Layout

```
┌─────────────────────────────────────────────────────────────────┐
│  ◀  Dezember 2024                              [Heute]  ▶      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────┐ ┌──────┐ ┌────────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──   │
│  │Mo  9 │ │Di 10 │ │ Mi 11  │ │Do 12 │ │Fr 13 │ │Sa 14 │ │So   │
│  │──────│ │──────│ │ HEUTE  │ │──────│ │──────│ │──────│ │──   │
│  │🌅 —  │ │🌅Müs.│ │────────│ │🌅 +  │ │🌅 +  │ │🌅Bru.│ │🌅   │
│  │🌞Curr│ │🌞 —  │ │🌅 +    │ │🌞 +  │ │🌞 +  │ │🌞 —  │ │🌞   │
│  │🌙Sala│ │🌙Pizz│ │🌞Suppe │ │🌙 +  │ │🌙 +  │ │🌙Fond│ │🌙   │
│  └──────┘ └──────┘ │🌙 +    │ └──────┘ └──────┘ └──────┘ └──   │
│      ↑             └────────┘      ↑                            │
│   Vergangen           Heute     Wochenende                      │
│                                (leicht anders)                  │
└─────────────────────────────────────────────────────────────────┘
```

### Technische Details

| Aspekt | Implementierung |
|--------|-----------------|
| **Scroll Widget** | `ListView.builder` horizontal |
| **Item Count** | 28 Tage (7 vergangen + heute + 20 Zukunft) |
| **Item Width** | 100px (fest) |
| **Initial Scroll** | `ScrollController(initialScrollOffset: 7 * 100)` |
| **Snap Physics** | Optional: `PageScrollPhysics()` oder frei |
| **Monat-Header** | Statisch über ListView, Update via `ScrollController.addListener` |

### Monat-Header Logik

```dart
// Berechne sichtbaren Monat basierend auf Scroll-Position
void _onScroll() {
  final firstVisibleIndex = (_scrollController.offset / itemWidth).floor();
  final firstVisibleDate = _startDate.add(Duration(days: firstVisibleIndex));
  if (firstVisibleDate.month != _currentMonth) {
    setState(() => _currentMonth = firstVisibleDate.month);
  }
}
```

---

## 4. DayCard Widget

### Spezifikation

```dart
class DayCard extends StatelessWidget {
  final DateTime date;
  final List<PlannedMeal> meals;
  final bool isToday;
  final bool isPast;
  final bool isWeekend;
  final VoidCallback onTap;
  final void Function(MealSlot slot) onAddMeal;
}
```

### Dimensionen

```
Width:  100px
Height: 150px
Padding: 8px
Border-Radius: 14px
```

### Varianten

#### Normal (Zukunft)
```
┌────────────────┐
│   Donnerstag   │  ← TextStyle: 11px, grey[500]
│      12        │  ← TextStyle: 24px, bold, grey[800]
├────────────────┤
│ 🌅  +          │  ← 12px, grey[400], GestureDetector
│ 🌞  +          │
│ 🌙  +          │
└────────────────┘
Background: Colors.white
Border: 1px solid grey[200]
```

#### Mit Meals
```
┌────────────────┐
│   Dienstag     │
│      10        │
├────────────────┤
│ 🌅 Bircher...  │  ← maxLines: 1, ellipsis, grey[700]
│ 🌞  +          │
│ 🌙 Pasta m...  │
└────────────────┘
```

#### Heute (Highlighted)
```
┌────────────────┐
│   ★ HEUTE ★   │  ← 11px, primaryGreen, bold
│      11        │  ← 24px, bold, primaryGreen
├────────────────┤
│ 🌅  +          │  ← Grüner Akzent
│ 🌞 Kürbis...   │
│ 🌙  +          │
└────────────────┘
Background: primaryGreen.withOpacity(0.08)
Border: 2px solid primaryGreen
```

#### Vergangenheit
```
┌────────────────┐
│    Montag      │
│       9        │
├────────────────┤
│ 🌅  —          │  ← Keine Interaktion
│ 🌞 Curry       │
│ 🌙 Salat       │
└────────────────┘
Opacity: 0.5
Background: grey[100]
```

#### Wochenende
```
Background: Color(0xFFFFFBF5)  // Sehr leichtes Cream/Beige
Border: 1px solid grey[200]
```

### Slot-Icons (Emojis)
```dart
const slotEmojis = {
  MealSlot.breakfast: '🌅',
  MealSlot.lunch: '🌞',
  MealSlot.dinner: '🌙',
};
```

---

## 5. DayDetailSheet Widget

### Spezifikation

```dart
class DayDetailSheet extends ConsumerStatefulWidget {
  final DateTime initialDate;
  final List<PlannedMeal> allMeals;  // Alle Meals für Swipe
}

// Aufruf via:
void _showDayDetail(DateTime date) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DayDetailSheet(initialDate: date, allMeals: meals),
  );
}
```

### Layout

```
╔═══════════════════════════════════════════════════════════════╗
║                         ━━━━━━                                ║  ← Drag Handle
║                                                               ║
║  ◀  Mittwoch, 11. Dezember                              ▶    ║  ← Swipe Navigation
║      ════════════════════════                                 ║
║      ★ Heute                                                  ║  ← Badge (optional)
║                                                               ║
║  ┌───────────────────────────────────────────────────────┐   ║
║  │ 🌅 FRÜHSTÜCK                                          │   ║
║  │ ┌───────────────────────────────────────────────────┐ │   ║
║  │ │  ╭────╮                                           │ │   ║
║  │ │  │ +  │   Hinzufügen                              │ │   ║  ← EmptyMealSlot
║  │ │  ╰────╯                                           │ │   ║
║  │ └───────────────────────────────────────────────────┘ │   ║
║  └───────────────────────────────────────────────────────┘   ║
║                                                               ║
║  ┌───────────────────────────────────────────────────────┐   ║
║  │ 🌞 MITTAGESSEN                                        │   ║
║  │ ┌───────────────────────────────────────────────────┐ │   ║
║  │ │  ╭────╮   Kürbissuppe mit Ingwer              ⋮   │ │   ║  ← MealCard
║  │ │  │ 🖼️ │   35 Min · 2 Portionen                    │ │   ║
║  │ │  ╰────╯                                           │ │   ║
║  │ └───────────────────────────────────────────────────┘ │   ║
║  └───────────────────────────────────────────────────────┘   ║
║                                                               ║
║  ┌───────────────────────────────────────────────────────┐   ║
║  │ 🌙 ABENDESSEN                                         │   ║
║  │ ┌───────────────────────────────────────────────────┐ │   ║
║  │ │  ╭────╮                                           │ │   ║
║  │ │  │ +  │   Hinzufügen                              │ │   ║
║  │ │  ╰────╯                                           │ │   ║
║  │ └───────────────────────────────────────────────────┘ │   ║
║  └───────────────────────────────────────────────────────┘   ║
║                                                               ║
╚═══════════════════════════════════════════════════════════════╝
```

### Technische Details

| Aspekt | Implementierung |
|--------|-----------------|
| **Container** | `DraggableScrollableSheet` in `showModalBottomSheet` |
| **Initial Size** | `initialChildSize: 0.7` |
| **Max Size** | `maxChildSize: 0.9` |
| **Min Size** | `minChildSize: 0.4` |
| **Day Swipe** | `PageView` mit `PageController` |
| **Content** | Bestehende `MealCard` & `EmptyMealSlot` Widgets |

### Swipe zwischen Tagen

```dart
// PageView für horizontales Swipen
PageView.builder(
  controller: _pageController,
  itemCount: 28,  // Gleicher Range wie Calendar
  onPageChanged: (index) => setState(() => _selectedIndex = index),
  itemBuilder: (context, index) {
    final date = _startDate.add(Duration(days: index));
    return _DayContent(date: date, meals: _mealsForDate(date));
  },
)
```

---

## 6. Interaktionen

### Übersicht

| Aktion | Widget | Ergebnis |
|--------|--------|----------|
| Tap Day Card | `DayCard` | Öffnet `DayDetailSheet` |
| Tap "+" im Calendar | `DayCard` | Öffnet `AddMealSheet` für Slot |
| Tap "+" im Sheet | `EmptyMealSlot` | Öffnet `AddMealSheet` für Slot |
| Tap Meal im Sheet | `MealCard` | Navigiert zu Recipe Detail |
| Swipe horizontal (Calendar) | `ScrollWeekCalendar` | Scrollt durch Tage |
| Swipe horizontal (Sheet) | `DayDetailSheet` | Wechselt Tag |
| Tap "Heute" Button | Header | Scrollt zu heute |
| Tap ◀ ▶ Pfeile | Header | ±7 Tage springen |
| Drag Sheet down | `DayDetailSheet` | Schliesst Sheet |

### Swipe vs Tap

```
Calendar "+" Tap → Quick Add (direkt AddMealSheet)
Calendar Card Tap → Detail View (DayDetailSheet mit allen Infos)
```

---

## 7. Implementierungs-Reihenfolge

### Phase 1: Core Widgets
1. `DayCard` - Einzelne Tageskarte
2. `ScrollWeekCalendar` - Horizontaler Kalender
3. Update `WeekOverviewView` - Integration

### Phase 2: Bottom Sheet
4. `DayDetailSheet` - Detail-Ansicht als Sheet
5. Swipe-Navigation im Sheet

### Phase 3: Cleanup
6. Entferne `day_tile.dart`
7. Entferne `day_detail_view.dart`
8. Update `weekplan_screen.dart` (vereinfachen)

---

## 8. Best Practices (aus Research)

### Horizontal Scroll Calendar
- `ListView.builder` mit fester `itemExtent` für Performance
- `ScrollController.initialScrollOffset` für initiale Position
- Optional: `PageScrollPhysics()` für Snap-Effekt

**Sources:**
- [Flutter ListView docs](https://api.flutter.dev/flutter/widgets/ListView-class.html)
- [Scroll to specific position](https://medium.com/flutterworld/flutter-how-to-scroll-to-a-specific-position-in-listview-9ff9333ed4e)

### Bottom Sheet
- `isScrollControlled: true` für variable Höhe
- `DraggableScrollableSheet` für Drag-Verhalten
- `ClampingScrollPhysics()` für kontrolliertes Scrollen

**Sources:**
- [Custom Draggable Modal Bottom Sheet](https://medium.com/@soojlee0701/custom-draggable-modal-bottom-sheet-in-flutter-7139429c1442)
- [Top 5 BottomSheet Mistakes](https://medium.com/easy-flutter/top-5-common-bottomsheet-mistakes-flutter-developers-make-and-how-to-avoid-them-447a6b991e52)

### Scroll Physics
- `PageScrollPhysics` für Snap-to-Item
- Kombinierbar: `BouncingScrollPhysics().applyTo(PageScrollPhysics())`

**Sources:**
- [PageScrollPhysics class](https://api.flutter.dev/flutter/widgets/PageScrollPhysics-class.html)
- [Scroll Physics in Flutter](https://medium.com/@gauravswarankar/scroll-physics-in-flutter-e264593e0ee0)

---

## 9. Nicht im Scope

- Drag & Drop für Meals verschieben
- Multi-Select für Bulk-Aktionen
- Kalender-Sync (Google/Apple)
- Landscape-Layout

---

## 10. Metriken für Erfolg

- [ ] Alle 28 Tage sichtbar via Scroll
- [ ] Heute initial zentriert
- [ ] Meals pro Tag auf einen Blick
- [ ] Quick-Add via "+" funktioniert
- [ ] Detail-Sheet zeigt Bilder/Infos
- [ ] Swipe zwischen Tagen im Sheet
- [ ] Stats-Bar weiterhin sichtbar
- [ ] AI Planer FAB weiterhin funktional
