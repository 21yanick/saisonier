# Phase 15: Smart Weekplan Assistant (Premium)

**Status:** ✅ Implementiert
**Prerequisite:** Phase 14 (AI Rezept-Generator, AI Infrastruktur) ✅
**Letztes Update:** 2025-12-10
**Backend deployed:** Ausstehend

## Changelog

### 2025-12-10
- **Flexible Datumsauswahl**: Statt fixer Mo-So Wochenauswahl jetzt 14-Tage-Picker ab heute
- **Feste Rezepte**: User kann Rezepte explizit für Slots/Tage pinnen
- **Existierende Mahlzeiten**: Bereits geplante Slots werden geschützt (nicht überschrieben)
- **Slot-Reihenfolge**: Frühstück → Mittag → Abend (mit Icons wie im Homescreen)
- **Haushalts-Portionen**: Rezepte werden mit korrekter Portionenzahl gespeichert

---

## 1. Vision

Der Smart Weekplan Assistant ist mehr als ein "Rezept-Zuweiser". Er ist ein **persönlicher Meal-Planner der mitdenkt** - er versteht den Kontext der Woche, plant strategisch, erklärt seine Entscheidungen und passt sich im Dialog an.

### 1.1 Was ihn "smart" macht

| Feature | Beschreibung |
|---------|--------------|
| **Kontext-Verständnis** | KI analysiert "Mo Stress, Do Gäste, Poulet da" |
| **Strategisches Planen** | Reste-Verwertung, Zutaten-Effizienz, Wochentag-Kontext |
| **Begründungen** | Jedes Rezept hat ein "Warum gerade hier?" |
| **Conversational** | Bei Anpassungen: Dialog statt neu starten |
| **Insights** | "Das habe ich für dich optimiert" |

### 1.2 Die drei Säulen

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                          │
│  SÄULE 1: SMART MODAL                                                    │
│  ─────────────────────                                                   │
│  Strukturierter Input (Tage, Slots, Toggles, Chips)                      │
│  + Natürlicher Input (Freitext: "Was steht diese Woche an?")             │
│                                                                          │
│  SÄULE 2: INTELLIGENTE PLANUNG                                           │
│  ─────────────────────────────                                           │
│  KI analysiert Kontext, plant strategisch, erklärt Entscheidungen        │
│  Nicht "7 Rezepte", sondern "durchdachter Plan für DEINE Woche"          │
│                                                                          │
│  SÄULE 3: CONVERSATIONAL REFINEMENT                                      │
│  ──────────────────────────────────                                      │
│  Bei Anpassungswunsch: Dialog pro Tag/Mahlzeit                           │
│  KI versteht Problem, schlägt Alternativen vor                           │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 2. User Flow

### 2.1 Übersicht

```
SCHRITT 1          SCHRITT 2              SCHRITT 3
Modal Input    →   Intelligenter Plan  →  Conversational (optional)
                   mit Begründungen       Refinement

[Tage wählen]      [Mo: Poulet-Geschn.]   [💬 "Gast mag kein
[Slots wählen]      💭 "Poulet verwerten"      Kürbis..."]
[Kontext text]
[Inspiration]      [Di: Reis-Bowl]        [🤖 "Verstehe! Wie
[Boosts]            💭 "Reste nutzen"          wärs mit..."]

      ↓                   ↓                      ↓
  "Plan erstellen"   "Übernehmen"          "Das nehm ich"
                     oder [💬] pro Tag
```

### 2.2 Schritt 1: Smart Modal

```
┌─────────────────────────────────────────────────────────────┐
│  ✨ Wochenplan-Assistent                              [X]   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  Ich kenn dich:                                     │    │
│  │  👥 2 Personen · 🥬 Vegetarisch · ⏱️ Max 30min      │    │
│  │  🚫 Laktose, Nüsse                                  │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  Was steht diese Woche an?                                  │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ Mo+Di Stress, Do kommen 4 Gäste, hab noch Poulet    │    │
│  │ und Lauch im Kühlschrank                            │    │
│  └─────────────────────────────────────────────────────┘    │
│  ℹ️ Je mehr du mir sagst, desto besser kann ich planen      │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  Inspiration (optional)                                     │
│  [🎲 Überrasch mich] [⚡ Schnelle Woche] [💰 Budget]        │
│  [🥗 Leichte Woche] [🍝 Comfort]                            │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  Welche Tage? (← scrollbar, 14 Tage ab heute →)            │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ [Di✓] [Mi✓] [Do✓] [Fr✓] [Sa✓] [So ] [Mo ] ...      │    │
│  │  10    11    12    13    14    15    16             │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  Welche Mahlzeiten?                                         │
│  [  Frühstück  ] [✓ Mittagessen] [✓ Abendessen]            │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  Bevorzugen:                                                │
│  [☐ Meine Favoriten ⭐] [☐ Meine Rezepte 👤]               │
│                                                             │
│  Für diesen Plan:                                           │
│  [☐ Nur Vegetarisch] [☐ Nur Vegan] [☐ Alles max 30min]     │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  Feste Rezepte                                         (i)  │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ 📌 Birchermüesli                                    │ ✕  │
│  │    Frühstück • Jeden Tag                            │    │
│  └─────────────────────────────────────────────────────┘    │
│  [+ Rezept hinzufügen]                                      │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              ✨ Plan erstellen                       │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 2.3 Schritt 2: Intelligenter Plan mit Begründungen

```
┌─────────────────────────────────────────────────────────────┐
│  ← Zurück                              Dein Wochenplan      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  🧠 Ich hab deinen Kontext analysiert:                      │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ • Mo+Di = wenig Zeit → schnelle Rezepte             │    │
│  │ • Do = 4 Gäste → festliches Rezept, 4 Portionen     │    │
│  │ • Poulet + Lauch → einbauen, Food Waste vermeiden   │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  📅 MONTAG                                                  │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  🍽️ Abendessen                                      │    │
│  │  ┌─────────────────────────────────────────────┐    │    │
│  │  │ [IMG] │ Poulet-Geschnetzeltes       ⏱️ 25min│    │    │
│  │  │       │ Mit Reis und frischem Gemüse       │    │    │
│  │  └─────────────────────────────────────────────┘    │    │
│  │                                                     │    │
│  │  💭 "Dein Poulet wird verwertet + schnell weil      │    │
│  │      du wenig Zeit hast"                            │    │
│  │                                             [💬]    │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  📅 DIENSTAG                                                │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  🍽️ Abendessen                                      │    │
│  │  ┌─────────────────────────────────────────────┐    │    │
│  │  │ [IMG] │ Poulet-Reis-Bowl            ⏱️ 15min│    │    │
│  │  │       │ Mit Gemüse und Sojasauce           │    │    │
│  │  └─────────────────────────────────────────────┘    │    │
│  │                                                     │    │
│  │  💭 "Reste von Montag clever genutzt = Zero Waste   │    │
│  │      + ultra-schnell für deinen stressigen Tag"     │    │
│  │                                             [💬]    │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  📅 MITTWOCH                                                │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  🍽️ Abendessen                                      │    │
│  │  ┌─────────────────────────────────────────────┐    │    │
│  │  │ [IMG] │ Lauch-Quiche                ⏱️ 45min│    │    │
│  │  │       │ Mit frischem Blattsalat            │    │    │
│  │  └─────────────────────────────────────────────┘    │    │
│  │                                                     │    │
│  │  💭 "Dein Lauch wird verwendet + Mitte der Woche    │    │
│  │      hast du etwas mehr Zeit"                       │    │
│  │                                             [💬]    │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  📅 DONNERSTAG  👥 4 Gäste                                  │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  🍽️ Abendessen                                      │    │
│  │  ┌─────────────────────────────────────────────┐    │    │
│  │  │ [IMG] │ Festliches Kürbis-Risotto   ⏱️ 50min│    │    │
│  │  │       │ Mit gerösteten Kürbiskernen  👥 4   │    │    │
│  │  └─────────────────────────────────────────────┘    │    │
│  │                                                     │    │
│  │  💭 "Für deine Gäste - beeindruckend und Kürbis     │    │
│  │      hat gerade Hochsaison!"                        │    │
│  │                                             [💬]    │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  📅 FREITAG                                                 │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  🍽️ Abendessen                                      │    │
│  │  ┌─────────────────────────────────────────────┐    │    │
│  │  │ [IMG] │ One-Pot Pasta               ⏱️ 25min│    │    │
│  │  │       │ Alles in einem Topf                │    │    │
│  │  └─────────────────────────────────────────────┘    │    │
│  │                                                     │    │
│  │  💭 "TGIF! Nach dem Gäste-Kochen gestern was        │    │
│  │      Entspanntes mit wenig Abwasch"                 │    │
│  │                                             [💬]    │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  💡 Meine Strategie diese Woche:                            │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ ✓ Poulet + Lauch aus dem Kühlschrank verwertet      │    │
│  │ ✓ Reste-Verwertung spart ~20min am Dienstag         │    │
│  │ ✓ 3 saisonale Gemüse im Plan (Kürbis, Lauch, Wirz)  │    │
│  │ ✓ Festliches Gäste-Rezept am Donnerstag             │    │
│  │ ✓ Nach Gäste-Stress was Entspanntes am Freitag      │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  ┌───────────────────┐      ┌─────────────────────────────┐ │
│  │   Alles neu 🔄    │      │     ✓ Plan übernehmen       │ │
│  └───────────────────┘      └─────────────────────────────┘ │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 2.4 Schritt 3: Conversational Refinement

Wenn der User bei einem Tag [💬] klickt:

```
┌─────────────────────────────────────────────────────────────┐
│  💬 Donnerstag anpassen                               [X]   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Aktuell: Festliches Kürbis-Risotto (4 Pers.)               │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  👤 Einer der Gäste mag keinen Kürbis.                      │
│     Hast du was anderes Festliches?                         │
│                                                             │
│  🤖 Verstehe! Für 4 Gäste ohne Kürbis hätte ich:            │
│                                                             │
│     ┌─────────────────────────────────────────────────┐     │
│     │ Wirz-Rouladen                          ⏱️ 55min │     │
│     │ Klassisch, herzhaft - beeindruckt immer!        │     │
│     │                                      [Wählen]   │     │
│     └─────────────────────────────────────────────────┘     │
│                                                             │
│     ┌─────────────────────────────────────────────────┐     │
│     │ Pilz-Risotto                           ⏱️ 45min │     │
│     │ Auch cremig, aber ohne Kürbis                   │     │
│     │                                      [Wählen]   │     │
│     └─────────────────────────────────────────────────┘     │
│                                                             │
│     ┌─────────────────────────────────────────────────┐     │
│     │ Lauch-Gratin                           ⏱️ 40min │     │
│     │ Passt zu deinem Lauch im Kühlschrank!           │     │
│     │                                      [Wählen]   │     │
│     └─────────────────────────────────────────────────┘     │
│                                                             │
│  ─────────────────────────────────────────────────────────  │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ Oder sag mir was du dir vorstellst...               │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Datenmodelle

### 3.1 Enums

```dart
// lib/features/ai/domain/enums/ai_enums.dart

/// Inspiration-Chips für schnelle Auswahl
enum WeekplanInspiration {
  surprise,      // 🎲 Überrasch mich
  quickWeek,     // ⚡ Schnelle Woche (alle max 30min)
  budgetWeek,    // 💰 Budget-Woche
  lightWeek,     // 🥗 Leichte Woche
  comfortWeek,   // 🍝 Comfort-Woche
}

extension WeekplanInspirationX on WeekplanInspiration {
  String get emoji => switch (this) {
    WeekplanInspiration.surprise => '🎲',
    WeekplanInspiration.quickWeek => '⚡',
    WeekplanInspiration.budgetWeek => '💰',
    WeekplanInspiration.lightWeek => '🥗',
    WeekplanInspiration.comfortWeek => '🍝',
  };

  String get label => switch (this) {
    WeekplanInspiration.surprise => 'Überrasch mich',
    WeekplanInspiration.quickWeek => 'Schnelle Woche',
    WeekplanInspiration.budgetWeek => 'Budget-Woche',
    WeekplanInspiration.lightWeek => 'Leichte Woche',
    WeekplanInspiration.comfortWeek => 'Comfort-Woche',
  };
}

/// Erkannter Tages-Kontext (von KI analysiert)
enum DayContext {
  busy,          // Wenig Zeit
  relaxed,       // Mehr Zeit
  guests,        // Gäste kommen
  leftover,      // Reste-Tag
  mealPrep,      // Vorbereitung für morgen
  tgif,          // Freitag-Feeling
  weekend,       // Wochenende
}
```

### 3.2 Request Model

```dart
// lib/features/ai/domain/models/smart_weekplan_request.dart

@freezed
class SmartWeekplanRequest with _$SmartWeekplanRequest {
  const factory SmartWeekplanRequest({
    // Strukturierte Daten (Modal)
    required List<String> selectedDates,      // ISO dates: ["2025-12-10", "2025-12-11", ...]
    required List<String> selectedSlots,      // breakfast, lunch, dinner
    WeekplanInspiration? inspiration,
    @Default(false) bool boostFavorites,
    @Default(false) bool boostOwnRecipes,
    @Default(false) bool forceVegetarian,
    @Default(false) bool forceVegan,
    @Default(false) bool forceQuick,          // Alle max 30min
    Cuisine? cuisineOverride,

    // Natürlicher Kontext (Freitext)
    String? weekContext,                       // "Mo+Di Stress, Do Gäste..."

    // Automatisch - bereits geplante Slots
    @Default([]) List<ExistingMealInfo> existingMeals,

    // Feste Rezepte (User hat explizit gepinnt)
    @Default([]) List<FixedRecipeInfo> fixedRecipes,
  }) = _SmartWeekplanRequest;

  factory SmartWeekplanRequest.fromJson(Map<String, dynamic> json) =>
      _$SmartWeekplanRequestFromJson(json);
}

@freezed
class ExistingMealInfo with _$ExistingMealInfo {
  const factory ExistingMealInfo({
    required String date,
    required String slot,
    required String title,
  }) = _ExistingMealInfo;

  factory ExistingMealInfo.fromJson(Map<String, dynamic> json) =>
      _$ExistingMealInfoFromJson(json);
}

@freezed
class FixedRecipeInfo with _$FixedRecipeInfo {
  const factory FixedRecipeInfo({
    required String recipeId,
    required String recipeTitle,
    required String slot,
    required List<String> dates,    // ISO dates where this recipe is fixed
  }) = _FixedRecipeInfo;

  factory FixedRecipeInfo.fromJson(Map<String, dynamic> json) =>
      _$FixedRecipeInfoFromJson(json);
}
```

### 3.3 Response Model

```dart
// lib/features/ai/domain/models/smart_weekplan_response.dart

@freezed
class SmartWeekplanResponse with _$SmartWeekplanResponse {
  const factory SmartWeekplanResponse({
    required ContextAnalysis contextAnalysis,
    required List<PlannedDay> weekplan,
    required Map<String, dynamic> recipes,    // Full recipe data by ID
    required StrategyInsights strategy,
    @Default(0) int eligibleRecipeCount,
  }) = _SmartWeekplanResponse;

  factory SmartWeekplanResponse.fromJson(Map<String, dynamic> json) =>
      _$SmartWeekplanResponseFromJson(json);
}

@freezed
class ContextAnalysis with _$ContextAnalysis {
  const factory ContextAnalysis({
    @Default({}) Map<String, String> timeConstraints,  // {"monday": "busy"}
    @Default({}) Map<String, EventInfo> events,        // {"thursday": {...}}
    @Default([]) List<String> ingredientsToUse,        // ["poulet", "lauch"]
    String? displaySummary,                            // Für UI
  }) = _ContextAnalysis;

  factory ContextAnalysis.fromJson(Map<String, dynamic> json) =>
      _$ContextAnalysisFromJson(json);
}

@freezed
class EventInfo with _$EventInfo {
  const factory EventInfo({
    required String type,        // "guests", "birthday", etc.
    int? guestCount,
  }) = _EventInfo;

  factory EventInfo.fromJson(Map<String, dynamic> json) =>
      _$EventInfoFromJson(json);
}

@freezed
class PlannedDay with _$PlannedDay {
  const factory PlannedDay({
    required String date,
    required String dayName,
    String? dayContext,                              // "busy", "guests", etc.
    required Map<String, PlannedMealSlot> meals,
  }) = _PlannedDay;

  factory PlannedDay.fromJson(Map<String, dynamic> json) =>
      _$PlannedDayFromJson(json);
}

@freezed
class PlannedMealSlot with _$PlannedMealSlot {
  const factory PlannedMealSlot({
    String? recipeId,                    // DB-Rezept
    GeneratedRecipe? generatedRecipe,    // Oder neu generiert
    required String reasoning,           // WICHTIG: Warum dieses Rezept?
  }) = _PlannedMealSlot;

  factory PlannedMealSlot.fromJson(Map<String, dynamic> json) =>
      _$PlannedMealSlotFromJson(json);
}

@freezed
class StrategyInsights with _$StrategyInsights {
  const factory StrategyInsights({
    @Default([]) List<String> insights,    // Bullet-Points für UI
    @Default(0) int seasonalCount,
    @Default(0) int favoritesUsed,
    String? estimatedTotalTime,
  }) = _StrategyInsights;

  factory StrategyInsights.fromJson(Map<String, dynamic> json) =>
      _$StrategyInsightsFromJson(json);
}
```

### 3.4 Refine Response Model

```dart
// lib/features/ai/domain/models/refine_meal_response.dart

@freezed
class RefineMealResponse with _$RefineMealResponse {
  const factory RefineMealResponse({
    required String response,                    // KI-Antwort Text
    required List<MealSuggestion> suggestions,   // 2-3 Alternativen
  }) = _RefineMealResponse;

  factory RefineMealResponse.fromJson(Map<String, dynamic> json) =>
      _$RefineMealResponseFromJson(json);
}

@freezed
class MealSuggestion with _$MealSuggestion {
  const factory MealSuggestion({
    String? recipeId,                    // DB-Rezept
    GeneratedRecipe? generatedRecipe,    // Oder neu generiert
    required String title,
    required String reasoning,
    int? cookTimeMin,
  }) = _MealSuggestion;

  factory MealSuggestion.fromJson(Map<String, dynamic> json) =>
      _$MealSuggestionFromJson(json);
}
```

---

## 4. Backend API

### 4.1 Haupt-Endpoint: Smart Weekplan Generation

```javascript
// backend/ai_service/index.js

app.post('/api/ai/generate-smart-weekplan', authMiddleware, premiumMiddleware, async (req, res) => {
  console.log('=== SMART WEEKPLAN GENERATION START ===');

  try {
    const userId = req.userId;
    const request = req.body;

    // 1. User-Daten laden
    const userProfile = await getUserProfile(userId);
    const aiProfile = req.aiProfile;

    // 2. Passende Rezepte filtern
    const eligibleRecipes = await getEligibleRecipes(userId, {
      forceVegetarian: request.force_vegetarian,
      forceVegan: request.force_vegan,
      forceQuick: request.force_quick,
      boostFavorites: request.boost_favorites,
      boostOwnRecipes: request.boost_own_recipes,
      inspiration: request.inspiration,
    });

    console.log(`Found ${eligibleRecipes.length} eligible recipes`);

    // 3. Rezept-Summaries für Prompt bauen
    const userFavoriteIds = await getUserFavoriteRecipeIds(userId);
    const userOwnIds = eligibleRecipes.filter(r => r.user_id === userId).map(r => r.id);
    const recipeSummaries = buildRecipeSummaries(eligibleRecipes, userFavoriteIds, userOwnIds);

    // 4. Kontext für Prompt
    const context = {
      ...request,
      household_size: userProfile?.household_size || 2,
      children_count: userProfile?.children_count || 0,
      diet: userProfile?.diet,
      skill: userProfile?.skill,
      max_time: request.force_quick ? 30 : (userProfile?.max_cooking_time_min || 60),
      allergens: userProfile?.allergens || [],
      cuisine_preferences: aiProfile?.cuisine_preferences,
      flavor_profile: aiProfile?.flavor_profile,
    };

    // 5. Smart Prompt bauen und Gemini aufrufen
    const prompt = buildSmartWeekplanPrompt(context, recipeSummaries);
    console.log('Prompt length:', prompt.length);

    const geminiResponse = await callGemini(prompt, {
      temperature: 0.7,
      maxOutputTokens: 4096,
    });

    const result = geminiResponse.result;

    // 6. Vollständige Rezepte laden
    const recipeIds = [];
    for (const day of result.weekplan) {
      for (const meal of Object.values(day.meals)) {
        if (meal.recipeId) recipeIds.push(meal.recipeId);
      }
    }

    const fullRecipes = {};
    for (const id of [...new Set(recipeIds)]) {
      try {
        const recipe = await pb.collection('recipes').getOne(id);
        fullRecipes[id] = recipe;
      } catch (e) {
        console.error(`Recipe ${id} not found`);
      }
    }

    // 7. Logging
    await logAIRequest(userId, 'smart_weekplan', geminiResponse.usage?.totalTokens, true);

    // 8. Response
    res.json({
      contextAnalysis: result.contextAnalysis,
      weekplan: result.weekplan,
      recipes: fullRecipes,
      strategy: result.strategy,
      eligibleRecipeCount: eligibleRecipes.length,
    });

  } catch (e) {
    console.error('Smart weekplan generation error:', e);
    await logAIRequest(req.userId, 'smart_weekplan', 0, false, e.message);
    res.status(500).json({
      error: 'Weekplan generation failed',
      message: e.message,
    });
  }
});
```

### 4.2 Refine-Endpoint: Conversational

```javascript
// backend/ai_service/index.js

app.post('/api/ai/refine-meal', authMiddleware, premiumMiddleware, async (req, res) => {
  try {
    const { current_plan, day, slot, user_message, conversation_history } = req.body;

    // Passende Rezepte laden (ohne bereits verwendete)
    const usedRecipeIds = current_plan
      .flatMap(d => Object.values(d.meals))
      .filter(m => m.recipeId)
      .map(m => m.recipeId);

    const eligibleRecipes = await getEligibleRecipes(req.userId, {});
    const availableRecipes = eligibleRecipes.filter(r => !usedRecipeIds.includes(r.id));

    // Aktuelles Rezept finden
    const currentDay = current_plan.find(d => d.date === day);
    const currentMeal = currentDay?.meals[slot];

    // Prompt für Refinement
    const prompt = buildRefinementPrompt({
      currentMeal,
      userMessage: user_message,
      conversationHistory: conversation_history,
      availableRecipes: availableRecipes.slice(0, 30),
      dayContext: currentDay?.dayContext,
    });

    const response = await callGemini(prompt, {
      temperature: 0.8,
      maxOutputTokens: 1024,
    });

    // Vollständige Rezepte für Suggestions laden
    const suggestions = response.result.suggestions || [];
    for (const suggestion of suggestions) {
      if (suggestion.recipeId) {
        try {
          const recipe = await pb.collection('recipes').getOne(suggestion.recipeId);
          suggestion.recipe = recipe;
        } catch (e) {
          console.error(`Recipe ${suggestion.recipeId} not found`);
        }
      }
    }

    await logAIRequest(req.userId, 'refine_meal', response.usage?.totalTokens, true);

    res.json({
      response: response.result.response,
      suggestions: suggestions,
    });

  } catch (e) {
    console.error('Refine meal error:', e);
    res.status(500).json({ error: e.message });
  }
});
```

### 4.3 Smart Prompt Builder

```javascript
// backend/ai_service/index.js

function buildSmartWeekplanPrompt(context, recipeSummaries) {
  const dayNames = ['', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag'];
  const selectedDaysStr = context.selected_days.map(d => dayNames[d]).join(', ');

  // Existierende Mahlzeiten
  const existingMealsInfo = context.existing_meals?.length > 0
    ? context.existing_meals.map(m => `- ${m.date} ${m.slot}: ${m.title}`).join('\n')
    : 'Keine';

  return `
Du bist ein persönlicher Schweizer Meal-Planner der STRATEGISCH denkt.

## DEINE AUFGABE

Erstelle einen DURCHDACHTEN Wochenplan. Nicht "7 zufällige Rezepte", sondern
einen Plan der zur WOCHE dieses Users passt.

## USER-KONTEXT DIESE WOCHE

"${context.week_context || 'Keine besonderen Angaben'}"

ANALYSIERE diesen Kontext und extrahiere:
- Zeit-Constraints: Welche Tage sind stressig/entspannt?
- Events: Gäste, Geburtstage, besondere Anlässe?
- Vorhandene Zutaten: Was muss verwertet werden?
- Explizite Wünsche: Was will der User diese Woche?

## USER-PROFIL (IMMER EINHALTEN)

- Haushalt: ${context.household_size} Personen${context.children_count > 0 ? ` (davon ${context.children_count} Kinder)` : ''}
- Ernährung: ${context.diet || 'omnivor'}
- Allergene: ${context.allergens?.join(', ') || 'keine'} → NIEMALS verwenden!
- Max. Zeit pro Rezept: ${context.max_time} Minuten
- Kochskill: ${context.skill || 'beginner'}

## PRÄFERENZEN

- Lieblings-Küchen: ${context.cuisine_preferences?.join(', ') || 'alle'}
- Geschmack: ${context.flavor_profile?.join(', ') || 'ausgewogen'}
${context.inspiration ? `- Inspiration: ${context.inspiration}` : ''}
${context.boost_favorites ? '- FAVORITEN bevorzugen!' : ''}
${context.boost_own_recipes ? '- EIGENE REZEPTE bevorzugen!' : ''}

## STRATEGISCHES DENKEN

Für JEDEN Tag, überlege:

1. ZEIT: Was weisst du über diesen Tag? (aus week_context)
   - "Stress" / "wenig Zeit" → schnelles Rezept
   - "Homeoffice" / "frei" → mehr Zeit ok

2. EVENT: Passiert was Besonderes?
   - Gäste → festlich, mehr Portionen
   - Geburtstag → besonderes Rezept

3. VORHER: Was wurde gestern gekocht?
   - Reste nutzbar? → Reste-Verwertung!
   - Gleiche Zutat? → Variation statt Wiederholung

4. NACHHER: Kann ich was für morgen vorbereiten?
   - Reis für 2 Tage kochen
   - Gemüse vorbereiten

5. ZUTATEN: Welche vorhandenen Zutaten einbauen?
   - Food Waste vermeiden!
   - User hat erwähnt: [aus week_context]

6. SAISON: Was ist gerade frisch?
   - Saisonale Rezepte (🌿) bevorzugen

## BEREITS GEPLANT (NICHT ÜBERSCHREIBEN)

${existingMealsInfo}

## ANFRAGE

- Tage: ${selectedDaysStr}
- Mahlzeiten: ${context.selected_slots.join(', ')}
- Woche startet: ${context.week_start_date}

## VERFÜGBARE REZEPTE

Legende: ⭐=Favorit, 👤=Eigenes Rezept, 🌿=Saisonal
${recipeSummaries}

Wähle NUR aus dieser Liste (IDs exakt übernehmen).
Ausnahme: Wenn KEIN passendes Rezept existiert, darfst du ein neues generieren.

## OUTPUT FORMAT (JSON)

{
  "contextAnalysis": {
    "timeConstraints": {
      "monday": "busy",
      "tuesday": "busy",
      "wednesday": "relaxed"
    },
    "events": {
      "thursday": { "type": "guests", "guestCount": 4 }
    },
    "ingredientsToUse": ["poulet", "lauch"],
    "displaySummary": "Mo+Di wenig Zeit, Do Gäste, Poulet+Lauch verwerten"
  },
  "weekplan": [
    {
      "date": "2025-12-09",
      "dayName": "Montag",
      "dayContext": "busy",
      "meals": {
        "dinner": {
          "recipeId": "abc123",
          "reasoning": "Dein Poulet wird verwertet + schnell weil du wenig Zeit hast"
        }
      }
    },
    {
      "date": "2025-12-10",
      "dayName": "Dienstag",
      "dayContext": "busy",
      "meals": {
        "dinner": {
          "recipeId": "def456",
          "reasoning": "Reste von Montag clever genutzt = Zero Waste + ultra-schnell"
        }
      }
    }
  ],
  "strategy": {
    "insights": [
      "Poulet + Lauch aus dem Kühlschrank verwertet",
      "Reste-Verwertung spart ~20min am Dienstag",
      "3 saisonale Gemüse im Plan (Kürbis, Lauch, Wirz)",
      "Festliches Gäste-Rezept am Donnerstag"
    ],
    "seasonalCount": 3,
    "favoritesUsed": 2,
    "estimatedTotalTime": "3.5h für die Woche"
  }
}

## WICHTIG ZU DEN REASONINGS

Die "reasoning" zeigt dem User dass du MITDENKST. Sie muss:
- Kurz sein (1-2 Sätze max)
- Den Bezug zum Kontext zeigen
- Praktischen Mehrwert erklären

GUTE Reasonings:
- "Dein Poulet wird verwertet + schnell weil du wenig Zeit hast"
- "Reste von gestern als Bowl = Zero Waste + ultra-schnell"
- "Für deine Gäste - beeindruckend und Kürbis hat Hochsaison!"
- "TGIF - nach dem Gäste-Kochen was Entspanntes mit wenig Abwasch"
- "Dein Lauch wird verwendet + Mitte der Woche mehr Zeit"

SCHLECHTE Reasonings:
- "Ein leckeres Gericht"
- "Passt gut"
- "Vegetarisches Rezept"
- "Schnell zubereitet" (zu generisch)

Antworte NUR mit dem JSON, ohne Markdown.
`;
}
```

### 4.4 Refinement Prompt Builder

```javascript
function buildRefinementPrompt(context) {
  const recipeSummaries = context.availableRecipes
    .map(r => `[${r.id}] ${r.title} (${(r.prep_time_min || 0) + (r.cook_time_min || 0)}min)`)
    .join('\n');

  return `
Du bist ein hilfsbereiter Meal-Planner im Gespräch mit dem User.

## AKTUELLES REZEPT
${context.currentMeal?.title || 'Nicht bekannt'}
Reasoning war: "${context.currentMeal?.reasoning || ''}"
Tages-Kontext: ${context.dayContext || 'normal'}

## USER-NACHRICHT
"${context.userMessage}"

## DEINE AUFGABE
1. Verstehe was der User will/nicht will
2. Schlage 2-3 passende Alternativen vor
3. Erkläre kurz warum jede Alternative passt

## VERFÜGBARE REZEPTE
${recipeSummaries}

## OUTPUT FORMAT (JSON)

{
  "response": "Verstehe! Für [Situation] hätte ich:",
  "suggestions": [
    {
      "recipeId": "abc123",
      "title": "Rezeptname",
      "reasoning": "Warum das passt (1 Satz)",
      "cookTimeMin": 35
    },
    {
      "recipeId": "def456",
      "title": "Alternative",
      "reasoning": "Warum das auch passt",
      "cookTimeMin": 40
    }
  ]
}

Sei freundlich und hilfreich. Wenn der User was Spezifisches will das nicht in der
Liste ist, kannst du ausnahmsweise ein neues Rezept generieren (dann recipeId: null
und generatedRecipe: {...} hinzufügen).

Antworte NUR mit dem JSON.
`;
}
```

### 4.5 Recipe Filter Service

```javascript
// backend/ai_service/index.js

async function getEligibleRecipes(userId, filters) {
  const userProfile = await getUserProfile(userId);

  // 1. Alle Rezepte laden (curated + user's own)
  let recipes = await pb.collection('recipes').getFullList({
    filter: `source = "curated" || user_id = "${userId}"`,
  });

  // 2. Hard-Filter: Allergene
  if (userProfile?.allergens?.length > 0) {
    recipes = recipes.filter(r => {
      for (const allergen of userProfile.allergens) {
        const fieldName = `contains_${allergen}`;
        if (r[fieldName] === true) return false;
      }
      return true;
    });
  }

  // 3. Hard-Filter: Diät
  if (filters.forceVegan || userProfile?.diet === 'vegan') {
    recipes = recipes.filter(r => r.is_vegan);
  } else if (filters.forceVegetarian || userProfile?.diet === 'vegetarian') {
    recipes = recipes.filter(r => r.is_vegetarian);
  }

  // 4. Hard-Filter: Max Kochzeit
  const maxTime = filters.forceQuick ? 30 : (userProfile?.max_cooking_time_min || 60);
  recipes = recipes.filter(r => (r.prep_time_min + r.cook_time_min) <= maxTime);

  // 5. Hard-Filter: Skill-Level
  const skillOrder = { 'easy': 1, 'medium': 2, 'hard': 3 };
  const userSkillLevel = skillOrder[userProfile?.skill] || 2;
  recipes = recipes.filter(r => {
    const recipeSkill = skillOrder[r.difficulty] || 1;
    return recipeSkill <= userSkillLevel;
  });

  // 6. Soft-Scoring
  const currentMonth = new Date().getMonth() + 1;
  const seasonalVegetableIds = await getSeasonalVegetableIds(currentMonth);
  const userFavoriteIds = await getUserFavoriteRecipeIds(userId);

  recipes = recipes.map(r => {
    let score = 1.0;

    // Saison-Boost (1.5x)
    if (seasonalVegetableIds.includes(r.vegetable_id)) {
      score *= 1.5;
      r._isSeasonal = true;
    }

    // Favoriten-Boost (2x wenn aktiviert)
    if (filters.boostFavorites && userFavoriteIds.includes(r.id)) {
      score *= 2.0;
      r._isFavorite = true;
    }

    // Eigene-Rezepte-Boost (1.8x wenn aktiviert)
    if (filters.boostOwnRecipes && r.user_id === userId) {
      score *= 1.8;
      r._isOwn = true;
    }

    // Inspiration-Boosts
    if (filters.inspiration === 'budgetWeek') {
      if (r.tags?.includes('budget') || r.tags?.includes('günstig')) score *= 1.5;
    }
    if (filters.inspiration === 'comfortWeek') {
      if (r.tags?.includes('comfort') || r.tags?.includes('herzhaft')) score *= 1.5;
    }
    if (filters.inspiration === 'lightWeek') {
      if (r.tags?.includes('leicht') || r.tags?.includes('gesund')) score *= 1.5;
    }

    return { ...r, _score: score };
  });

  // 7. Sortieren und limitieren
  recipes.sort((a, b) => b._score - a._score);
  return recipes.slice(0, 50);
}

function buildRecipeSummaries(recipes, userFavoriteIds, userOwnIds) {
  const byCategory = {
    main: [], side: [], soup: [], salad: [],
    breakfast: [], dessert: [], snack: [],
  };

  for (const r of recipes) {
    const cat = r.category || 'main';
    if (!byCategory[cat]) byCategory[cat] = [];

    const totalTime = (r.prep_time_min || 0) + (r.cook_time_min || 0);
    const flags = [];
    if (r.is_vegetarian) flags.push('veg');
    if (r.is_vegan) flags.push('vegan');
    if (r._isFavorite) flags.push('⭐');
    if (r._isOwn) flags.push('👤');
    if (r._isSeasonal) flags.push('🌿');

    const summary = `[${r.id}] ${r.title} (${totalTime}min${flags.length ? ', ' + flags.join(' ') : ''})`;
    byCategory[cat].push(summary);
  }

  let output = '';
  const catNames = {
    main: 'Hauptgerichte', side: 'Beilagen', soup: 'Suppen',
    salad: 'Salate', breakfast: 'Frühstück', dessert: 'Desserts', snack: 'Snacks',
  };

  for (const [cat, items] of Object.entries(byCategory)) {
    if (items.length > 0) {
      output += `\n### ${catNames[cat] || cat}\n`;
      output += items.map(i => `• ${i}`).join('\n');
      output += '\n';
    }
  }

  return output;
}

async function getSeasonalVegetableIds(month) {
  const vegetables = await pb.collection('vegetables').getFullList({
    filter: `months ~ "${month}"`,
  });
  return vegetables.map(v => v.id);
}

async function getUserFavoriteRecipeIds(userId) {
  // TODO: Implementieren basierend auf is_favorite oder separater Tabelle
  return [];
}
```

---

## 5. Flutter Implementation

### 5.1 AI Service erweitern

```dart
// lib/features/ai/data/repositories/ai_service.dart

/// Generate a smart weekly meal plan with context understanding.
Future<SmartWeekplanResponse> generateSmartWeekplan({
  required List<int> selectedDays,
  required List<String> selectedSlots,
  String? weekContext,
  WeekplanInspiration? inspiration,
  bool boostFavorites = false,
  bool boostOwnRecipes = false,
  bool forceVegetarian = false,
  bool forceVegan = false,
  bool forceQuick = false,
  Cuisine? cuisineOverride,
  List<PlannedMeal>? existingMeals,
}) async {
  final now = DateTime.now();
  final weekStart = now.subtract(Duration(days: now.weekday - 1));

  final response = await _post('/api/ai/generate-smart-weekplan', {
    'selected_days': selectedDays,
    'selected_slots': selectedSlots,
    'week_context': weekContext,
    'inspiration': inspiration?.name,
    'boost_favorites': boostFavorites,
    'boost_own_recipes': boostOwnRecipes,
    'force_vegetarian': forceVegetarian,
    'force_vegan': forceVegan,
    'force_quick': forceQuick,
    'cuisine_override': cuisineOverride?.name,
    'existing_meals': existingMeals?.map((m) => {
      'date': m.date.toIso8601String().split('T')[0],
      'slot': m.slot.name,
      'title': m.customTitle ?? 'Geplant',
    }).toList() ?? [],
    'week_start_date': weekStart.toIso8601String().split('T')[0],
  });

  return SmartWeekplanResponse.fromJson(response);
}

/// Refine a single meal through conversation.
Future<RefineMealResponse> refineMeal({
  required List<PlannedDay> currentPlan,
  required String day,
  required String slot,
  required String userMessage,
  List<Map<String, String>>? conversationHistory,
}) async {
  final response = await _post('/api/ai/refine-meal', {
    'current_plan': currentPlan.map((d) => d.toJson()).toList(),
    'day': day,
    'slot': slot,
    'user_message': userMessage,
    'conversation_history': conversationHistory ?? [],
  });

  return RefineMealResponse.fromJson(response);
}
```

### 5.2 File Structure (Implementiert)

```
lib/features/ai/
├── data/
│   └── repositories/
│       └── ai_service.dart                  # ✅ generateSmartWeekplan(), refineMeal(), getEligibleRecipeCount()
│
├── domain/
│   ├── enums/
│   │   └── ai_enums.dart                    # ✅ WeekplanInspiration Enum hinzugefügt
│   │
│   └── models/
│       ├── smart_weekplan_response.dart     # ✅ SmartWeekplanResponse, ContextAnalysis, PlannedDay, etc.
│       ├── refine_meal_response.dart        # ✅ RefineMealResponse, MealSuggestion
│       └── fixed_recipe.dart                # ✅ FixedRecipe Model (gepinnte Rezepte)
│
└── presentation/
    ├── widgets/
    │   ├── weekplan_ai_modal.dart           # ✅ Schritt 1 (14-Tage-Picker, Feste Rezepte)
    │   ├── meal_refine_sheet.dart           # ✅ Schritt 3 (Bottom Sheet)
    │   └── fixed_recipe_sheet.dart          # ✅ Bottom Sheet für Rezept-Pinning
    │
    └── screens/
        └── smart_weekplan_screen.dart       # ✅ Schritt 2 (Preview mit Slot-Icons)

lib/features/weekplan/
└── presentation/
    └── screens/
        └── weekplan_screen.dart             # ✅ FAB-Integration mit AIFab

backend/ai_service/
└── index.js                                 # ✅ Alle Endpoints inkl. fixed_recipes
```

**Anmerkungen:**
- Die ursprünglich geplanten separaten Widget-Dateien wurden direkt integriert (KISS-Prinzip)
- `fixed_recipe.dart` und `fixed_recipe_sheet.dart` sind neue Dateien für das "Feste Rezepte" Feature

---

## 6. Error Handling

### 6.1 Error Scenarios

| Error | Verhalten | UI |
|-------|-----------|-----|
| `notEnoughRecipes` | Warnung, trotzdem generieren | Dialog mit Hinweis |
| `contextParseError` | Ignorieren, normal planen | - |
| `generationFailed` | Retry anbieten | "Nochmal versuchen" Button |
| `recipeNotFound` | Mahlzeit überspringen | Hinweis im Plan |
| `quotaExceeded` | Limit anzeigen | Premium-Upgrade Dialog |
| `networkError` | Offline-Hinweis | "Keine Verbindung" |

### 6.2 Minimum Recipe Check

```dart
// Im Modal vor dem Generieren
void _onGeneratePressed() async {
  // Check eligible count first
  final count = await ref.read(aiServiceProvider).getEligibleRecipeCount(/* filters */);
  final required = _selectedDays.length * _selectedSlots.length;

  if (count < required) {
    final proceed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Wenige Rezepte verfügbar'),
        content: Text(
          'Es wurden nur $count passende Rezepte gefunden, '
          'aber du brauchst $required für deinen Plan.\n\n'
          'Der Plan wird trotzdem erstellt, aber einige Rezepte '
          'könnten sich wiederholen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Trotzdem erstellen'),
          ),
        ],
      ),
    );

    if (proceed != true) return;
  }

  _generatePlan();
}
```

---

## 7. Acceptance Criteria

### Must Have ✅

- [x] Smart Modal mit Freitext-Kontext-Input
- [x] Profil-Summary Card ("Ich kenn dich")
- [x] Inspiration Chips (5 Optionen)
- [x] Tage- und Slot-Auswahl
- [x] Boost-Toggles (Favoriten, Eigene)
- [x] Backend: Context-Analyse im Prompt
- [x] Backend: Strategisches Planen mit Reasonings
- [x] Preview: Kontext-Analyse anzeigen ("Ich hab verstanden...")
- [x] Preview: Jedes Rezept mit Reasoning
- [x] Preview: Strategie-Insights
- [x] Conversational Refinement pro Mahlzeit ([💬] Button)
- [x] Plan speichern mit recipeId-Referenzen
- [x] Allergene werden NIEMALS verletzt (Hard-Filter im Backend)

### Should Have ✅

- [x] "Alles neu" Button im Preview (→ "Neu" im AppBar)
- [x] Loading-Animation während Generation
- [x] Frühstück als Slot-Option
- [x] Eligible Recipe Count im Modal anzeigen
- [ ] Dismiss-Protection während Generation (TODO)
- [ ] Erweiterte Optionen UI (Cuisine Override - Backend ready)

### Nice to Have

- [ ] Animated reveal der Tage im Preview
- [ ] Rezept-Quick-View (Tap auf Rezept → Details)
- [ ] Einkaufsliste direkt aus Preview generieren
- [ ] Conversation-History im Refinement
- [ ] "Das Rezept merken" aus Preview

---

## 8. Implementation Checklist

### Phase 15a: Backend (Smart Generation) ✅
- [x] `getEligibleRecipes()` mit allen Filtern - `backend/ai_service/index.js:256`
- [x] `buildRecipeSummaries()` mit Flags - `backend/ai_service/index.js:356`
- [x] `buildSmartWeekplanPrompt()` mit Context-Analyse - `backend/ai_service/index.js:399`
- [x] `/api/ai/generate-smart-weekplan` Endpoint - `backend/ai_service/index.js:869`
- [x] `/api/ai/eligible-recipe-count` Endpoint - `backend/ai_service/index.js:976`
- [x] Response mit contextAnalysis, weekplan, strategy

### Phase 15b: Backend (Refinement) ✅
- [x] Refinement Prompt in Endpoint integriert
- [x] `/api/ai/refine-meal` Endpoint - `backend/ai_service/index.js:992`
- [x] Suggestions mit Reasonings und Recipe-Loading

### Phase 15c: Flutter Models ✅
- [x] `WeekplanInspiration` Enum - `lib/features/ai/domain/enums/ai_enums.dart:360`
- [x] `SmartWeekplanResponse` Model - `lib/features/ai/domain/models/smart_weekplan_response.dart`
- [x] `RefineMealResponse` Model - `lib/features/ai/domain/models/refine_meal_response.dart`
- [x] Code Generation (`make generate`)

### Phase 15d: Flutter AI Service ✅
- [x] `generateSmartWeekplan()` Methode - `lib/features/ai/data/repositories/ai_service.dart:136`
- [x] `refineMeal()` Methode - `lib/features/ai/data/repositories/ai_service.dart:167`
- [x] `getEligibleRecipeCount()` Methode - `lib/features/ai/data/repositories/ai_service.dart:186`

### Phase 15e: Flutter Modal (Schritt 1) ✅
- [x] `WeekplanAIModal` Widget - `lib/features/ai/presentation/widgets/weekplan_ai_modal.dart`
- [x] ProfileSummaryCard (integriert in Modal)
- [x] WeekContextInput (Freitext)
- [x] InspirationChips (5 Optionen)
- [x] **Flexible 14-Tage-Datumsauswahl** (horizontaler Picker ab heute)
- [x] Slot-Auswahl (Frühstück/Mittag/Abend)
- [x] BoostToggles (Favoriten, Eigene Rezepte)
- [x] Override-Toggles (Vegetarisch, Vegan, Max 30min)
- [x] **Feste Rezepte Sektion** (Rezepte pinnen)
- [x] Generate Button mit Loading
- [x] Existierende Mahlzeiten werden automatisch erkannt

### Phase 15e2: Feste Rezepte Feature ✅
- [x] `FixedRecipe` Model - `lib/features/ai/domain/models/fixed_recipe.dart`
- [x] `FixedRecipeSheet` Bottom Sheet - `lib/features/ai/presentation/widgets/fixed_recipe_sheet.dart`
- [x] Slot-Auswahl (Frühstück/Mittag/Abend)
- [x] Rezeptsuche mit Allergen-Warnungen
- [x] "Jeden Tag" vs "Bestimmte Tage" Option
- [x] Backend: `fixed_recipes` im Prompt
- [x] Backend: Programmatische Injektion (nicht KI vertrauen)

### Phase 15f: Flutter Preview (Schritt 2) ✅
- [x] `SmartWeekplanScreen` - `lib/features/ai/presentation/screens/smart_weekplan_screen.dart`
- [x] ContextAnalysisCard ("Ich hab verstanden...")
- [x] DayPlanCard mit Reasoning und Context-Badge
- [x] **Slot-Reihenfolge**: Frühstück → Mittag → Abend
- [x] **Slot-Icons** wie im Homescreen (wb_twilight, light_mode, dark_mode)
- [x] StrategyInsightsCard ("Meine Strategie")
- [x] "Plan übernehmen" Button (mit korrekter Portionenzahl)
- [x] "Neu" Button für Regeneration
- [x] Deutsche Wochentage (Montag, Dienstag, ...)

### Phase 15g: Flutter Refinement (Schritt 3) ✅
- [x] `MealRefineSheet` (Bottom Sheet) - `lib/features/ai/presentation/widgets/meal_refine_sheet.dart`
- [x] Chat-Input mit Send-Button
- [x] AI-Response Anzeige
- [x] Suggestion-Cards mit Bild, Reasoning, Zeit
- [x] "Wählen" Button pro Suggestion

### Phase 15h: Integration ✅
- [x] AIFab im WeekplanScreen mit "AI Planer" Label - `lib/features/weekplan/presentation/screens/weekplan_screen.dart`
- [x] Save-Logic in SmartWeekplanScreen (speichert via WeekplanRepository)
- [x] Navigation Modal → Preview → zurück zum WeekplanScreen

---

## 9. Kosten-Schätzung

| Aktion | Tokens (ca.) | Kosten (Gemini Flash) |
|--------|--------------|----------------------|
| Smart Generation | 3000-4000 | ~$0.001-0.002 |
| Refinement | 500-1000 | ~$0.0005 |
| Typische Session | 4000-6000 | ~$0.002-0.003 |

→ Pro Wochenplan-Erstellung: ca. $0.002-0.003 (sehr günstig!)

---

## 10. Implementierte Dateien

### Backend
| Datei | Beschreibung |
|-------|--------------|
| `backend/ai_service/index.js` | Alle Endpoints inkl. `fixed_recipes` Verarbeitung |

### Flutter Models
| Datei | Beschreibung |
|-------|--------------|
| `lib/features/ai/domain/enums/ai_enums.dart` | `WeekplanInspiration` Enum |
| `lib/features/ai/domain/models/smart_weekplan_response.dart` | Response-Models (Freezed) |
| `lib/features/ai/domain/models/refine_meal_response.dart` | Refinement-Models (Freezed) |
| `lib/features/ai/domain/models/fixed_recipe.dart` | **NEU**: Feste Rezepte Model |

### Flutter Service
| Datei | Beschreibung |
|-------|--------------|
| `lib/features/ai/data/repositories/ai_service.dart` | `generateSmartWeekplan()`, `refineMeal()`, `fixedRecipes` Parameter |

### Flutter UI
| Datei | Beschreibung |
|-------|--------------|
| `lib/features/ai/presentation/widgets/weekplan_ai_modal.dart` | Schritt 1: 14-Tage-Picker, Feste Rezepte |
| `lib/features/ai/presentation/widgets/fixed_recipe_sheet.dart` | **NEU**: Bottom Sheet für Rezept-Pinning |
| `lib/features/ai/presentation/screens/smart_weekplan_screen.dart` | Schritt 2: Preview mit Slot-Icons |
| `lib/features/ai/presentation/widgets/meal_refine_sheet.dart` | Schritt 3: Refinement |
| `lib/features/weekplan/presentation/screens/weekplan_screen.dart` | FAB-Integration |

---

## 11. Feature: Feste Rezepte (Pinned Recipes)

### Problemstellung
User fragte: "Ich will jeden Morgen Birchermüesli" - aber die KI wählte andere Rezepte. Keyword-Extraktion aus Freitext ist fragil und fehleranfällig.

### Lösung
Explizites Pinnen von Rezepten durch den User:

```
┌─────────────────────────────────────────────────────────────┐
│  Feste Rezepte                                         (i)  │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ 📌 Birchermüesli                                    │ ✕  │
│  │    Frühstück • Jeden Tag                            │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ 📌 Spaghetti Bolognese                              │ ✕  │
│  │    Abendessen • Do 12, Fr 13                        │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
│  [+ Rezept hinzufügen]                                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Technische Umsetzung

1. **Frontend**: User wählt Rezept → Slot → Tage
2. **API**: `fixed_recipes` Array wird mitgeschickt
3. **Prompt**: KI wird informiert diese Slots zu ÜBERSPRINGEN
4. **Backend**: Nach KI-Antwort werden feste Rezepte **programmatisch injiziert** (nicht KI vertrauen!)
5. **Response**: Feste Rezepte erscheinen mit Reasoning "Von dir fix eingeplant"

### Vorteile
- Deterministisch: User bekommt exakt was er will
- Keine Keyword-Extraktion nötig
- KI kann sich auf die restlichen Slots konzentrieren
- Kombinierbar mit Kontext-Input ("Do Gäste, aber Birchermüesli fix jeden Morgen")

---

## 12. Nächste Schritte

1. **Backend deployen** - `backend/ai_service/` auf Live-Server
2. **E2E Test** - Vollständigen Flow im Emulator testen
3. **Prompt-Tuning** - Reasonings verbessern basierend auf echten Tests
4. **Nice-to-Have Features** - Falls Zeit: Animated Reveals, Quick-View

---

*Phase 15 - Smart Weekplan Assistant*
*Status: ✅ Implementiert*
*Stand: 2025-12-10*
