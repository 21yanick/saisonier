# Phase 14: AI Rezept-Generator (Premium)

**Status:** ✅ Fertig (100%)
**Prerequisite:** Phase 13 (Einkaufslisten-Export) ✅
**Dependencies:** Premium Onboarding Flow (Teil dieser Phase)
**Letztes Update:** 2025-12-09

---

## 1. Übersicht

Diese Phase etabliert die AI-Infrastruktur für Saisonier und implementiert den ersten AI-Feature: den Rezept-Generator. Sie beinhaltet auch das Premium Onboarding für das erweiterte AI-Profil.

### 1.1 Scope

| Component | Beschreibung | Status |
|-----------|--------------|--------|
| ai_profiles Collection | PocketBase Schema | ✅ Fertig |
| ai_requests Collection | Request Logging | ✅ Fertig |
| AI Service Backend | Node.js + Gemini Proxy | ✅ Fertig |
| Drift Migration v7 | AIProfiles Table | ✅ Fertig |
| Premium Onboarding | 5-Screen Wizard | ✅ Fertig |
| AI FAB Component | Wiederverwendbarer FAB | ✅ Fertig |
| Paywall Sheet | Premium Upsell | ✅ UI Fertig |
| Recipe Generation Modal v2 | Erweitertes UI mit Inspiration/Free-Form/Overrides | ✅ Fertig |
| Recipe Review Flow | Generiertes Rezept prüfen & speichern | ✅ Fertig |
| Learning Context | Implizites Lernen | ✅ Fertig |
| Profile Settings Link | Setup abschliessen Button | ✅ Fertig |
| Onboarding Enums erweitern | HealthGoal/NutritionFocus/Equipment | ✅ Fertig |
| Onboarding UX verbessern | Likes-Feld, Complete Screen | ✅ Fertig |
| Backend Prompt v2 | Alle Profile-Daten, dynamische Saison-Gemüse | ✅ Fertig |
| Onboarding Auto-Redirect | Nach Premium-Kauf | ❌ Offen (später) |
| Subscription Integration | RevenueCat | ❌ Offen (später) |

---

## 2. Datenmodell

### 2.1 PocketBase Collection: `ai_profiles`

**Status:** ✅ Implementiert

```javascript
// backend/pb_schema/ai_collections.json
{
  "name": "ai_profiles",
  "type": "base",
  "fields": [
    { "name": "user_id", "type": "relation", "collectionId": "_pb_users_auth_", "cascadeDelete": true },
    { "name": "cuisine_preferences", "type": "json" },     // ["italian", "asian", "swiss"]
    { "name": "flavor_profile", "type": "json" },          // ["spicy", "creamy", "hearty"]
    { "name": "likes", "type": "json" },                   // ["Pasta", "Suppen"]
    { "name": "protein_preferences", "type": "json" },     // ["chicken", "tofu", "fish"]
    { "name": "budget_level", "type": "select", "values": ["budget", "normal", "premium"] },
    { "name": "meal_prep_style", "type": "select", "values": ["daily", "mealPrep", "mixed"] },
    { "name": "cooking_days_per_week", "type": "number" },
    { "name": "health_goals", "type": "json" },            // ["loseWeight", "moreEnergy"]
    { "name": "nutrition_focus", "type": "select", "values": ["highProtein", "lowCarb", "balanced", "vegetableFocus", "lowSugar", "wholesome"] },
    { "name": "equipment", "type": "json" },               // ["oven", "mixer", "airfryer"]
    { "name": "learning_context", "type": "json" },        // AILearningContext object
    { "name": "onboarding_completed", "type": "bool" }
  ],
  "listRule": "@request.auth.id = user_id",
  "viewRule": "@request.auth.id = user_id",
  "createRule": "@request.auth.id != ''",
  "updateRule": "@request.auth.id = user_id",
  "deleteRule": "@request.auth.id = user_id"
}
```

### 2.2 PocketBase Collection: `ai_requests`

**Status:** ✅ Implementiert

```javascript
// Logging & Quota Tracking
{
  "name": "ai_requests",
  "type": "base",
  "fields": [
    { "name": "user_id", "type": "relation", "collectionId": "_pb_users_auth_" },
    { "name": "request_type", "type": "select", "values": ["recipe_gen", "weekplan_gen", "image_gen"] },
    { "name": "prompt_hash", "type": "text" },
    { "name": "tokens_used", "type": "number" },
    { "name": "response_data", "type": "json" },
    { "name": "success", "type": "bool" },
    { "name": "error_message", "type": "text" }
  ],
  "listRule": "@request.auth.id = user_id",
  "viewRule": "@request.auth.id = user_id",
  "createRule": null,  // Only AI Service can create
  "updateRule": null,
  "deleteRule": null
}
```

Setup-Script: `backend/setup_ai_collections.sh`

### 2.3 Drift Table: `AIProfiles`

**Status:** ✅ Implementiert (Schema v7)

```dart
// lib/features/ai/data/local/ai_profiles_table.dart
class AIProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  // ... (vollständig implementiert)
}
```

---

## 3. AI Service Backend

**Status:** ✅ Fertig implementiert

### 3.1 Architektur

Eigenständiger Node.js Service als Docker Container:

```
backend/ai_service/
├── index.js           # Express Server
├── Dockerfile         # Container Build
├── package.json       # Dependencies (express, cors, pocketbase)
└── .env               # GEMINI_API_KEY, GEMINI_MODEL
```

### 3.2 Docker Compose

```yaml
# backend/docker-compose.yml
services:
  pocketbase:
    # ... PocketBase Config

  ai_service:
    build: ./ai_service
    container_name: saisonier_ai
    ports:
      - "3001:3001"
    environment:
      - GEMINI_API_KEY=${GEMINI_API_KEY}
      - GEMINI_MODEL=${GEMINI_MODEL:-gemini-2.5-flash}
      - POCKETBASE_URL=https://saisonier-api.21home.ch
```

### 3.3 API Endpoints

| Endpoint | Beschreibung | Status |
|----------|--------------|--------|
| `GET /health` | Health Check | ✅ |
| `POST /api/ai/generate-recipe` | Rezept generieren | ✅ |
| `POST /api/ai/generate-weekplan` | Wochenplan generieren | ✅ (für Phase 15) |
| `GET /api/ai/quota` | Image Quota Status | ✅ (für Phase 16) |

### 3.4 Auth Flow

1. Flutter sendet PocketBase JWT im Authorization Header
2. AI Service dekodiert JWT, prüft Expiry
3. AI Service prüft ob User `ai_profiles` Record hat (= Premium)
4. Bei Erfolg: Request an Gemini API

### 3.5 Prompt Building v2

Der AI Service baut kontextreiche Prompts mit **allen** verfügbaren Daten:

**User Profile (PocketBase: user_profiles):**
- `allergens` → "ABSOLUT VERMEIDEN: Nüsse, Laktose"
- `diet` → "Basis-Ernährungsform: vegetarisch"
- `dislikes` → "VERMEIDEN: Rosenkohl, Leber"
- `skill` → Beeinflusst Rezept-Schwierigkeit
- `max_cooking_time_min` → Max. Kochzeit
- `household_size` → Portionen-Anzahl
- `children_count` → Kindgerechte Optionen

**AI Profile (PocketBase: ai_profiles):**
- `cuisine_preferences` → "Lieblings-Küchen: Italienisch, Asiatisch"
- `flavor_profile` → "Geschmack: cremig, würzig"
- `protein_preferences` → "Bevorzugte Proteine: Poulet, Tofu"
- `budget_level` → Beeinflusst Zutaten-Auswahl
- `nutrition_focus` → "Ernährungs-Fokus: High Protein"
- `health_goals` → "Ziele: Mehr Energie, Mehr Gemüse"
- `equipment` → "Verfügbare Geräte: Airfryer, Thermomix"
- `likes` → "Mag besonders: Pasta, Risotto"
- `learning_context.rejectedSuggestions` → "NICHT vorschlagen: Lauch"
- `learning_context.acceptedSuggestions` → "Positiv bewertet: Randen, Kürbis"

**Request Parameters (v2 - erweitert):**
- `seasonal_vegetables` → User-Auswahl oder leer (AI wählt)
- `style` → comfort/quick/healthy/festive/onePot/budget
- `category` → main/side/soup/salad/dessert/snack
- `free_form_request` → Freitext-Wunsch
- `additional_ingredients` → Zusätzliche Zutaten
- `inspiration` → surprise/quick/onePot/kidFriendly/forGuests
- `force_vegetarian` → Override für dieses Rezept
- `force_vegan` → Override für dieses Rezept
- `force_quick` → Max 30 min Override
- `cuisine_override` → Küche Override (z.B. "asian" statt Profil)
- `protein_override` → Protein Override
- `nutrition_override` → Fokus Override

**Dynamische Daten:**
- Saisonales Gemüse wird **aus DB geladen** (`vegetables` Collection)
- Aktueller Monat wird automatisch erkannt

---

## 4. Flutter Client

### 4.1 AppConfig

**Status:** ✅ Implementiert

```dart
// lib/core/config/app_config.dart
static String get aiServiceUrl {
  const envUrl = String.fromEnvironment('AI_URL');
  if (envUrl.isNotEmpty) return envUrl;

  if (Platform.isAndroid) return 'http://10.0.2.2:3001';
  return 'http://127.0.0.1:3001';
}
```

### 4.2 AIService Client

**Status:** ✅ Implementiert (v2 - erweitert)

```dart
// lib/features/ai/data/repositories/ai_service.dart
class AIService {
  /// Generate a recipe with full context and override options.
  Future<GeneratedRecipe> generateRecipe({
    required List<String> seasonalVegetables,
    required RecipeStyle style,
    RecipeCategory category = RecipeCategory.main,
    String? freeFormRequest,
    String? additionalIngredients,
    RecipeInspiration? inspiration,
    bool forceVegetarian = false,
    bool forceVegan = false,
    bool forceQuick = false,
    Cuisine? cuisineOverride,
    Protein? proteinOverride,
    NutritionFocus? nutritionOverride,
  }) async { ... }
}
```

### 4.3 AIProfileRepository

**Status:** ✅ Implementiert

```dart
// lib/features/ai/data/repositories/ai_profile_repository.dart
class AIProfileRepository {
  Future<AIProfile?> getProfile(String userId);
  Future<AIProfile> createOrUpdateProfile(String userId, AIProfile profile);
  Future<void> updateLearningContext(String userId, AILearningContext context);
  Future<void> addAcceptedSuggestion(String userId, String suggestion);
  Future<void> addRejectedSuggestion(String userId, String suggestion);
}
```

---

## 5. Premium Onboarding Flow

**Status:** ✅ UI fertig, ❌ Trigger fehlt

### 5.1 Screen Flow (5 Screens)

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   Welcome    │───▶│   Cuisine    │───▶│  Lifestyle   │
│  (Screen 1)  │    │  (Screen 2)  │    │  (Screen 3)  │
└──────────────┘    └──────────────┘    └──────────────┘
       │                                        │
       │ "Später"                               ▼
       │                            ┌──────────────┐
       ▼                            │    Goals     │
 [Speichert leeres                  │  (Screen 4)  │
  ai_profile mit                    │  (Optional)  │
  onboarding_completed              └──────────────┘
  = false]                                  │
                                            ▼
                                  ┌──────────────┐
                                  │   Complete   │
                                  │  (Screen 5)  │
                                  │  (Summary)   │
                                  └──────────────┘
```

### 5.2 Implementierte Screens

| Screen | File | Inhalt | Status |
|--------|------|--------|--------|
| Welcome | `welcome_step.dart` | Willkommen + "Los geht's" / "Später" | ✅ |
| Cuisine | `cuisine_step.dart` | Küchen, Geschmack, Proteinquellen | ✅ |
| Lifestyle | `lifestyle_step.dart` | Budget, Kochstil, Tage/Woche | ✅ |
| Goals | `goals_step.dart` | Gesundheitsziele, Ernährung, Equipment | ✅ |
| Complete | `complete_step.dart` | Summary Card mit User + AI Profile | ✅ |

### 5.3 Was noch fehlt

**Onboarding Trigger:**
- `needsOnboarding` Provider existiert, wird aber nirgends verwendet
- Kein automatischer Redirect nach Premium-Kauf
- Kein Weg um zum Onboarding zu kommen (ausser manuell `/premium-onboarding`)

**Fortsetzen nach "Später":**
- User kann Onboarding überspringen
- Es gibt keinen Weg, das Onboarding später fortzusetzen
- Sollte: In Profile Settings "AI Chef einrichten" Button zeigen wenn `onboarding_completed = false`

---

## 6. AI FAB Component

**Status:** ✅ Implementiert

### 6.1 Widget

```dart
// lib/features/ai/presentation/widgets/ai_fab.dart
class AIFab extends ConsumerWidget {
  // Prüft isPremiumProvider
  // Zeigt _LockedFab oder _UnlockedFab
}
```

### 6.2 Paywall Sheet

Zeigt sich bei Tap auf locked FAB:
- Premium Features Liste
- "Premium testen" Button
- Preis: CHF 5.90 / Monat

**TODO:** Button navigiert noch nirgendwo hin (Subscription Flow fehlt)

### 6.3 Placement

| Screen | FAB Action | Status |
|--------|------------|--------|
| MyRecipesScreen | Opens Recipe Generation Modal | ✅ |
| WeekplanScreen | Opens Weekplan AI Modal | ❌ (Phase 15) |

---

## 7. Recipe Generation Modal v2

**Status:** ✅ Fertig (Dezember 2024 - Überarbeitet)

### 7.1 UI Layout

```dart
// lib/features/ai/presentation/widgets/recipe_generation_modal.dart
```

```
┌──────────────────────────────────────────────────┐
│  ✨ Rezept-Ideen                          [X]   │
├──────────────────────────────────────────────────┤
│                                                  │
│  Inspiration                                     │
│  [🎲 Überrasch mich] [⚡ Schnell] [🍲 One-Pot]   │
│  [👶 Kinderfreundlich] [🎉 Für Gäste]            │
│                                                  │
│  ──────────────────────────────────────────────  │
│                                                  │
│  Was schwebt dir vor? (optional)                 │
│  ┌──────────────────────────────────────────┐    │
│  │ z.B. "Ein cremiges Gratin mit Lauch"     │    │
│  └──────────────────────────────────────────┘    │
│                                                  │
│  Saisonal im Dezember (optional)                 │
│  ← [Lauch] [Wirz] [Kürbis] [Randen] [+6] →      │
│     ↑ horizontal scrollbar                       │
│                                                  │
│  Zutaten die du verwenden willst (optional)      │
│  ┌──────────────────────────────────────────┐    │
│  │ z.B. Kartoffeln, Rahm, Speck             │    │
│  └──────────────────────────────────────────┘    │
│                                                  │
│  ──────────────────────────────────────────────  │
│                                                  │
│  Kategorie              Stil                     │
│  [Hauptgericht ▼]       [🍲 Comfort Food ▼]      │
│                                                  │
│  Für dieses Rezept:                              │
│  [☐ Vegetarisch] [☐ Vegan] [☐ Max 30 Min]       │
│                                                  │
│  ▸ Erweiterte Optionen                           │
│  ┌──────────────────────────────────────────┐    │
│  │ Küche:   [Profil: Italienisch ▼]         │    │
│  │ Protein: [Profil: Poulet ▼]              │    │
│  │ Fokus:   [Profil: Ausgewogen ▼]          │    │
│  └──────────────────────────────────────────┘    │
│                                                  │
│  ┌──────────────────────────────────────────┐    │
│  │        ✨ Rezept generieren               │    │
│  └──────────────────────────────────────────┘    │
│                                                  │
└──────────────────────────────────────────────────┘
```

### 7.2 Features

| Feature | Beschreibung |
|---------|--------------|
| **Inspiration Chips** | Quick-Actions: Überrasch mich, Schnell, One-Pot, Kinderfreundlich, Für Gäste |
| **Free-Form Input** | Freier Text für Wunschgericht ("Ein cremiges Gratin") |
| **Saisonales Gemüse** | Horizontal scrollbar, optional - AI wählt selbst wenn leer |
| **Kategorie Dropdown** | Hauptgericht, Beilage, Suppe, Salat, Dessert, Snack |
| **Stil Dropdown** | 6 Stile mit Emoji: Comfort, Schnell, Gesund, Festlich, One-Pot, Budget |
| **Quick Toggles** | Vegetarisch/Vegan/Max 30 Min - überschreibt Profil für dieses Rezept |
| **Erweiterte Optionen** | Küche/Protein/Fokus Override - zeigt Profil-Wert als Default |

### 7.3 Neue Enums

```dart
// lib/features/ai/domain/enums/ai_enums.dart

enum RecipeStyle {
  comfort,   // 🍲 Comfort Food - Herzhaft & wärmend
  quick,     // ⚡ Schnell & Einfach - Max. 30 Minuten
  healthy,   // 🥗 Gesund & Leicht - Kalorienarm & frisch
  festive,   // 🎉 Festlich - Für besondere Anlässe
  onePot,    // 🍳 One-Pot - Wenig Abwasch
  budget,    // 💰 Budget-freundlich - Günstige Zutaten
}

enum RecipeCategory {
  main,      // Hauptgericht
  side,      // Beilage
  soup,      // Suppe
  salad,     // Salat
  dessert,   // Dessert
  snack,     // Snack
}

enum RecipeInspiration {
  surprise,      // 🎲 Überrasch mich
  quick,         // ⚡ Schnell
  onePot,        // 🍲 One-Pot
  kidFriendly,   // 👶 Kinderfreundlich
  forGuests,     // 🎉 Für Gäste
}
```

### 7.4 Flow

1. Modal öffnet (DraggableScrollableSheet, 90% Höhe)
2. User kann:
   - Inspiration-Chip antippen (setzt automatisch passenden Stil)
   - Free-Form Wunsch eingeben
   - Saisonales Gemüse auswählen (horizontal scroll)
   - Zusätzliche Zutaten eingeben
   - Kategorie und Stil wählen
   - Quick-Toggles aktivieren (Override)
   - Erweiterte Optionen: Küche/Protein/Fokus override
3. "Rezept generieren" sendet Request an AI Service
4. Bei Erfolg: Modal schliesst → RecipeReviewScreen

### 7.5 Modal-Protection während Generierung

**Problem:** User konnte während der AI-Generierung das Modal schliessen → API-Call läuft weiter, aber das generierte Rezept geht verloren (API-Kosten verschwendet).

**Lösung:** Drei-Ebenen-Schutz implementiert:

| Mechanismus | Property | Beschreibung |
|-------------|----------|--------------|
| `showModalBottomSheet` | `enableDrag: false` | Verhindert Drag am Hintergrund |
| `showModalBottomSheet` | `isDismissible: false` | Verhindert Tap ausserhalb |
| `DraggableScrollableSheet` | `shouldCloseOnMinExtent: false` | **Kritisch:** Verhindert Schliessen beim Ziehen nach unten |
| `DraggableScrollableSheet` | `snap: true, snapSizes: [0.5, 0.9]` | Sheet snappt zu definierten Größen |
| `PopScope` | `canPop: !_isGenerating` | Verhindert Back-Button während Generierung |
| X-Button | `onPressed: _isGenerating ? null : ...` | Deaktiviert während Generierung |

**Verhalten:**
- Modal nur via X-Button schließbar (nicht durch Wischen)
- Während Generierung: X-Button ausgegraut, Back-Button zeigt SnackBar-Hinweis
- Sheet kann auf 50% minimiert werden, schliesst aber nicht

### 7.6 Inspiration-Effekte

| Chip | Effekt |
|------|--------|
| 🎲 Überrasch mich | Leert Gemüse-Auswahl + Free-Form |
| ⚡ Schnell | Setzt `forceQuick=true` + Stil auf "Schnell" |
| 🍲 One-Pot | Setzt Stil auf "One-Pot" |
| 👶 Kinderfreundlich | Wird im Prompt als Instruktion übergeben |
| 🎉 Für Gäste | Setzt Stil auf "Festlich" |

---

## 8. Recipe Review Flow

**Status:** ✅ Fertig

### 8.1 Screen

```dart
// lib/features/ai/presentation/screens/recipe_review_screen.dart
```

Features:
- AI Badge ("AI-generiert")
- Editierbarer Titel
- Portionen-Stepper (skaliert Zutaten automatisch)
- Zutaten-Liste
- Zubereitungs-Schritte
- Profi-Tipp Box
- Bottom Actions: [Verwerfen] [Nochmal] [Speichern]

### 8.2 Actions

| Action | Behavior | Learning Context |
|--------|----------|------------------|
| Verwerfen | Close | `addRejectedSuggestion(mainVegetable)` |
| Nochmal | Re-generate | `addRejectedSuggestion(mainVegetable)` |
| Speichern | Create Recipe | `addAcceptedSuggestion(mainVegetable)` |

---

## 9. Learning Context

**Status:** ✅ Implementiert

### 9.1 Datenstruktur

```dart
// lib/features/ai/domain/models/ai_learning_context.dart
@freezed
class AILearningContext with _$AILearningContext {
  const factory AILearningContext({
    @Default([]) List<String> acceptedSuggestions,
    @Default([]) List<String> rejectedSuggestions,
    @Default([]) List<String> topIngredients,
    @Default(0) int totalAIRequests,
    DateTime? lastAIInteraction,
  }) = _AILearningContext;
}
```

### 9.2 Updates

- `addAcceptedSuggestion()`: Bei Rezept speichern
- `addRejectedSuggestion()`: Bei Verwerfen/Nochmal
- `rejectedSuggestions` werden im Prompt an Gemini übergeben ("NICHT vorschlagen")

---

## 10. File Structure (Implementiert)

```
lib/features/ai/
├── data/
│   ├── dtos/
│   │   └── ai_profile_dto.dart          ✅
│   ├── local/
│   │   └── ai_profiles_table.dart       ✅
│   └── repositories/
│       ├── ai_profile_repository.dart   ✅
│       └── ai_service.dart              ✅
│
├── domain/
│   ├── models/
│   │   ├── ai_profile.dart              ✅
│   │   ├── ai_learning_context.dart     ✅
│   │   └── generated_recipe.dart        ✅
│   └── enums/
│       └── ai_enums.dart                ✅
│
└── presentation/
    ├── controllers/
    │   ├── ai_profile_controller.dart       ✅
    │   └── premium_onboarding_controller.dart ✅
    ├── screens/
    │   ├── premium_onboarding_screen.dart   ✅
    │   └── recipe_review_screen.dart        ✅
    └── widgets/
        ├── ai_fab.dart                      ✅
        ├── recipe_generation_modal.dart     ✅
        └── onboarding_steps/
            ├── welcome_step.dart            ✅
            ├── cuisine_step.dart            ✅
            ├── lifestyle_step.dart          ✅
            ├── goals_step.dart              ✅
            └── complete_step.dart           ✅
```

---

## 11. Onboarding Verbesserungen (TODO)

### 11.1 Enum-Erweiterungen

**Keine PocketBase Migration nötig** - alle Felder sind `type: json` und speichern beliebige Strings.

#### HealthGoal (erweitern)

```dart
enum HealthGoal {
  loseWeight,        // Abnehmen
  gainMuscle,        // Muskelaufbau
  moreEnergy,        // Mehr Energie
  eatHealthy,        // Gesund essen
  moreVegetables,    // Mehr Gemüse essen ← NEU (on-brand!)
  immuneSystem,      // Immunsystem stärken ← NEU
  betterDigestion,   // Bessere Verdauung ← NEU
  none;
}
```

#### NutritionFocus (erweitern)

```dart
enum NutritionFocus {
  highProtein,       // High Protein
  lowCarb,           // Low Carb
  balanced,          // Ausgewogen
  vegetableFocus,    // Viel Gemüse ← NEU (on-brand!)
  lowSugar,          // Wenig Zucker ← NEU
  wholesome;         // Vollwertig ← NEU
}
```

#### KitchenEquipment (erweitern)

```dart
enum KitchenEquipment {
  // Bestehend
  oven,              // Backofen
  mixer,             // Standmixer
  airfryer,          // Airfryer
  steamCooker,       // Dampfgarer
  instantPot,        // Instant Pot
  grill,             // Grill
  // Neu
  thermomix,         // Thermomix/Küchenmaschine ← NEU
  wok,               // Wok ← NEU
  slowCooker,        // Slow Cooker ← NEU
  raclette,          // Raclette-Gerät 🇨🇭 ← NEU
  fondue;            // Fondue-Set 🇨🇭 ← NEU
}
```

**Equipment-Logik im AI Prompt:**
- Equipment wird als **positiver Hinweis** verwendet ("User hat diese Geräte")
- KEINE Ausschluss-Logik ("kein Backofen = keine Auflauf-Rezepte" wäre zu restriktiv)
- Dient der AI als Inspiration für passende Rezepte

### 11.2 Cuisine Step Verbesserungen

**Likes-Feld hinzufügen:**

Das `likes` Feld existiert im Schema, wird aber nicht abgefragt.

```
┌─────────────────────────────────────────┐
│  Was isst du am liebsten?               │
│                                         │
│  Küchen:                                │
│  [Italienisch✓] [Asiatisch] [Schweizer] │
│  ...                                    │
│                                         │
│  Geschmacksprofil:                      │
│  [Cremig✓] [Würzig✓] [Herzhaft]         │
│  ...                                    │
│                                         │
│  Was magst du besonders?                │  ← NEU
│  ┌─────────────────────────────────────┐│
│  │ Pasta, Risotto, Currys, Suppen     ││
│  └─────────────────────────────────────┘│
│  (Freitext → likes Array)               │
│                                         │
└─────────────────────────────────────────┘
```

### 11.3 Goals Step Verbesserungen

**User Profile Dislikes anzeigen:**

Da Dislikes bereits im User Profile existieren, im Goals Step zur Erinnerung anzeigen:

```
┌─────────────────────────────────────────┐
│  Hast du besondere Ziele?               │
│                                         │
│  ⚠️ Aus deinem Profil:                  │  ← NEU
│  Dislikes: Rosenkohl, Leber             │
│  [Bearbeiten]                           │
│                                         │
│  Gesundheitsziele:                      │
│  ...                                    │
└─────────────────────────────────────────┘
```

### 11.4 Complete Step Überarbeitung

**Vollständige Zusammenfassung aller Daten:**

```
┌──────────────────────────────────────────┐
│  🧑‍🍳  Perfekt! Ich kenne dich jetzt:      │
├──────────────────────────────────────────┤
│                                          │
│  HAUSHALT (aus User Profile)             │
│  👥 3 Personen, 1 Kind                   │
│  🚫 Keine Nüsse, Laktose                 │
│  🥬 Vegetarisch                          │
│  👎 Mag nicht: Rosenkohl, Leber          │
│                                          │
│  ──────────────────────────────────────  │
│                                          │
│  GESCHMACK                               │
│  🍽️ Italienisch, Asiatisch, Schweizer    │
│  😋 Cremig, Herzhaft, Würzig             │
│  🥩 Tofu, Hülsenfrüchte, Eier            │
│  ❤️ Mag besonders: Pasta, Risotto        │
│                                          │
│  ──────────────────────────────────────  │
│                                          │
│  LIFESTYLE                               │
│  💰 Budget: Normal                       │
│  📅 4x pro Woche kochen                  │
│  🍱 Mix aus frisch & Meal Prep           │
│                                          │
│  ──────────────────────────────────────  │
│                                          │
│  ZIELE                                   │
│  🎯 Mehr Energie, Mehr Gemüse essen      │
│  🥗 Ernährung: Ausgewogen                │
│                                          │
│  ──────────────────────────────────────  │
│                                          │
│  KÜCHE                                   │
│  🔧 Backofen, Airfryer, Raclette         │
│                                          │
└──────────────────────────────────────────┘
│                                          │
│       ✨ Ich bin bereit! ✨               │
│                                          │
│   [ Rezept erstellen ]                   │
│                                          │
└──────────────────────────────────────────┘
```

---

## 12. AI Kontext & Datenfluss

### 12.1 Aktueller Datenfluss (funktioniert)

```
┌─────────────────────────────────────────────────────────────┐
│                    PROMPT BUILDING                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  USER PROFILE (PocketBase: user_profiles)                   │
│  ├── allergens        → "NIEMALS verwenden: Nüsse, Laktose" │
│  ├── diet             → "Ernährungsform: vegetarisch"       │
│  ├── dislikes         → "VERMEIDEN: Rosenkohl, Leber"       │
│  ├── skill            → Beeinflusst Rezept-Schwierigkeit    │
│  ├── max_cooking_time → "Max. 30 Minuten"                   │
│  └── household_size   → Portionen-Anzahl                    │
│                                                             │
│  AI PROFILE (PocketBase: ai_profiles)                       │
│  ├── cuisine_preferences → "Liebt: Italienisch, Asiatisch"  │
│  ├── flavor_profile      → "Geschmack: cremig, würzig"      │
│  ├── budget_level        → Beeinflusst Zutaten-Auswahl      │
│  ├── likes               → "Mag besonders: Pasta, Risotto"  │
│  └── learning_context                                       │
│      └── rejectedSuggestions → "NICHT vorschlagen: Lauch"   │
│                                                             │
│  REQUEST PARAMETERS                                         │
│  ├── seasonal_vegetables → Vom User gewähltes Gemüse        │
│  ├── additional_ingredients → Freitext-Eingabe              │
│  └── style               → quick/comfort/healthy/festive    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │   Gemini API    │
                    │   (2.5 Flash)   │
                    └─────────────────┘
                              │
                              ▼
                    ┌─────────────────┐
                    │  Rezept JSON    │
                    └─────────────────┘
```

### 12.2 Learning Context Updates

| User Aktion | Learning Context Update |
|-------------|-------------------------|
| Rezept **speichern** | `acceptedSuggestions.add(mainVegetable)` |
| Rezept **verwerfen** | `rejectedSuggestions.add(mainVegetable)` |
| Rezept **nochmal** | `rejectedSuggestions.add(mainVegetable)` |

`rejectedSuggestions` werden im Prompt als "NICHT vorschlagen" markiert.

### 12.3 Was FEHLT (Option B - Erweiterter Kontext)

```
┌─────────────────────────────────────────────────────────────┐
│              ERWEITERTER KONTEXT (TODO)                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. FAVORITEN-REZEPTE                                       │
│     ❌ Aktuell: AI kennt Favoriten nicht                    │
│     ✅ Ziel: SELECT title FROM recipes WHERE is_favorite    │
│     → "User mag: Risotto, Pasta Carbonara, Ramen"           │
│                                                             │
│  2. SAISONALES GEMÜSE (dynamisch)                           │
│     ❌ Aktuell: Hardcoded im Weekplan-Prompt                │
│     ✅ Ziel: SELECT name FROM vegetables WHERE month IN     │
│     → Dynamisch basierend auf aktuellem Monat               │
│                                                             │
│  3. KÜRZLICH GENERIERTE REZEPTE                             │
│     ❌ Aktuell: Kann Duplikate generieren                   │
│     ✅ Ziel: SELECT title FROM recipes WHERE source = 'ai'  │
│     → "Nicht nochmal: Lauch-Risotto (letzte Woche)"         │
│                                                             │
│  4. TOP INGREDIENTS (berechnet)                             │
│     ❌ Aktuell: topIngredients bleibt leer                  │
│     ✅ Ziel: Häufigste Zutaten aus Favoriten extrahieren    │
│     → "Verwendet oft: Parmesan, Knoblauch, Olivenöl"        │
│                                                             │
│  5. WOCHENPLAN-KONTEXT                                      │
│     ❌ Aktuell: Kein Bezug zu bereits geplanten Mahlzeiten  │
│     ✅ Ziel: Diese Woche bereits geplant berücksichtigen    │
│     → Keine Dopplungen, Zutaten wiederverwenden             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 12.4 Implementation Roadmap (Option B)

| Prio | Feature | Änderung | Aufwand |
|------|---------|----------|---------|
| 1 | Saisonales Gemüse dynamisch | AI Service: Query vegetables Collection | Klein |
| 2 | Favoriten als Kontext | AI Service: Query recipes WHERE is_favorite | Mittel |
| 3 | Duplikate vermeiden | AI Service: Query recipes WHERE source='ai' | Klein |
| 4 | topIngredients berechnen | Backend Job oder On-Demand Berechnung | Mittel |
| 5 | Wochenplan-Kontext | AI Service: Query planned_meals für Woche | Mittel |

---

## 13. Acceptance Criteria

### Must Have (✅ Alle erledigt)

- [x] ai_profiles Collection in PocketBase erstellt
- [x] ai_requests Collection in PocketBase erstellt
- [x] AI Service Backend (Node.js + Gemini)
- [x] ai_profiles Drift Table + Repository implementiert
- [x] Premium Onboarding Flow (5 Screens) UI funktioniert
- [x] AI FAB erscheint nur für Premium User
- [x] Non-Premium User sehen Paywall bei FAB-Tap
- [x] Recipe Generation Modal funktioniert
- [x] AI Service ruft Gemini API auf
- [x] Generierte Rezepte sind valides JSON
- [x] Rezepte können gespeichert werden mit `source: user`
- [x] Learning Context wird bei Accept/Reject aktualisiert
- [x] Profile Settings: "Setup abschliessen" Link existiert
- [x] Onboarding Enums erweitert (HealthGoal, NutritionFocus, Equipment)
- [x] Cuisine Step: Likes-Freitextfeld
- [x] Complete Step: Vollständige Zusammenfassung
- [x] Onboarding Navigation Bug gefixt
- [x] Onboarding kann erneut geöffnet werden (Präferenzen bearbeiten)
- [x] **Recipe Generation Modal v2: Inspiration Chips**
- [x] **Recipe Generation Modal v2: Free-Form Wunsch**
- [x] **Recipe Generation Modal v2: Kategorie-Auswahl**
- [x] **Recipe Generation Modal v2: 6 Stil-Optionen (inkl. One-Pot, Budget)**
- [x] **Recipe Generation Modal v2: Quick Toggles (Vegetarisch/Vegan/Max 30 Min)**
- [x] **Recipe Generation Modal v2: Erweiterte Optionen (Cuisine/Protein/Fokus Override)**
- [x] **Recipe Generation Modal v2: Saisonales Gemüse optional + horizontal scroll**
- [x] **Backend Prompt v2: Alle AI Profile Daten (healthGoals, nutritionFocus, equipment, likes)**
- [x] **Backend: Dynamische saisonale Gemüse aus DB**
- [x] **Backend: Override-Logik für Vegetarisch/Vegan/Quick/Cuisine/Protein/Fokus**
- [x] **Modal: Dismiss-Protection während AI-Generierung (shouldCloseOnMinExtent, PopScope, etc.)**
- [x] **PocketBase Schema: nutrition_focus erweitert um vegetableFocus, lowSugar, wholesome**
- [x] **Debug-Logging: AIProfileRepository mit debugPrint für Fehleranalyse**

### Later (Post-MVP)

- [ ] Onboarding Auto-Redirect nach Premium-Kauf
- [ ] RevenueCat Integration
- [ ] Erweiterter AI Kontext (Option B) - siehe 12.4:
  - [ ] Favoriten-Rezepte als Kontext
  - [ ] Duplikate vermeiden (kürzlich generierte Rezepte)
  - [ ] topIngredients berechnen
  - [ ] Wochenplan-Kontext

### Nice to Have

- [ ] Animation beim Generieren (Typing effect)
- [ ] Haptic Feedback bei Success
- [ ] Share generated recipe (before saving)
- [ ] Goals Step: User Profile Dislikes anzeigen/bearbeiten

---

## 14. Offene Punkte (Später)

### 14.1 Premium Onboarding Auto-Trigger

Der `needsOnboarding` Provider existiert:

```dart
@riverpod
bool needsOnboarding(Ref ref) {
  final aiProfile = ref.watch(aIProfileControllerProvider);
  final profile = aiProfile.valueOrNull;
  if (profile == null) return false;
  return !profile.onboardingCompleted;
}
```

**Für später:** In `MainScreen` oder Router: Wenn `isPremium && needsOnboarding` → Redirect zu `/premium-onboarding`

### 14.2 RevenueCat Integration (Später)

RevenueCat für Mobile In-App Purchases:
- Abstrahiert Apple App Store / Google Play Store
- Receipt Validation
- Cross-Platform Subscription Status
- Webhooks für Backend

**Flow nach Kauf:**
1. RevenueCat Webhook → PocketBase
2. PocketBase erstellt leeres `ai_profile` mit `onboarding_completed = false`
3. App erkennt `isPremium && needsOnboarding`
4. Auto-Redirect zu `/premium-onboarding`

---

## 15. Migration Notes

### 15.1 Schema Version Bump

**Durchgeführt:** Drift 6 → 7

```dart
// app_database.dart
@override
int get schemaVersion => 7;

@override
MigrationStrategy get migration => MigrationStrategy(
  onUpgrade: (m, from, to) async {
    // ...
    if (from < 7) {
      await m.createTable(aIProfiles);
    }
  },
);
```

### 15.2 PocketBase Setup

```bash
./backend/setup_ai_collections.sh [URL] [ADMIN_EMAIL] [ADMIN_PASSWORD]
```

---

*Phase 14 - AI Rezept-Generator*
*Stand: 2024-12-09*
