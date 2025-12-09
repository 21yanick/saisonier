# Phase 15: AI Wochenplaner (Premium)

**Status:** Geplant
**Prerequisite:** Phase 14 (AI Rezept-Generator, AI Infrastruktur)

---

## 1. Übersicht

Der AI Wochenplaner ist das Kernfeature für Premium User. Er erstellt automatisch einen kompletten Wochenplan basierend auf Saison, Profil und Präferenzen.

### 1.1 Kernkonzept

```
┌──────────────────────────────────────────────────────────────────┐
│                      AI WOCHENPLANER FLOW                         │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  1. USER TIPPT FAB               2. MODAL ÖFFNET                  │
│  ┌─────────────────┐            ┌─────────────────────┐          │
│  │   Wochenplan    │            │  Ich kenn dich:     │          │
│  │   [Plan Grid]   │ ──FAB──▶  │  • 2 Pers, veggie   │          │
│  │                 │            │  • Max 30min        │          │
│  └─────────────────┘            │                     │          │
│                                  │  Welche Tage?       │          │
│                                  │  [Mo✓][Di✓][Mi]... │          │
│                                  └─────────────────────┘          │
│                                            │                      │
│                                            ▼                      │
│  3. AI GENERIERT                 4. VORSCHAU & REVIEW             │
│  ┌─────────────────┐            ┌─────────────────────┐          │
│  │  PocketBase     │            │  Dein Wochenplan:   │          │
│  │  ──▶ Gemini     │ ──JSON──▶ │  Mo: Lauch-Risotto  │          │
│  │  ──▶ Response   │            │  Di: Wirz-Curry     │          │
│  └─────────────────┘            │  ...                │          │
│                                  │  [Nochmal] [Übernehmen]│       │
│                                  └─────────────────────┘          │
│                                            │                      │
│                                            ▼                      │
│                                  5. DIREKT IN WOCHENPLAN          │
│                                  ┌─────────────────────┐          │
│                                  │  planned_meals      │          │
│                                  │  werden erstellt    │          │
│                                  └─────────────────────┘          │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

### 1.2 Scope

| Component | Beschreibung |
|-----------|--------------|
| Weekplan AI Modal | UI für Plan-Anfrage |
| Context Builder | Sammelt alle relevanten User-Daten |
| PocketBase Hook | Server-side Wochenplan-Generation |
| Plan Preview Screen | Review vor Übernahme |
| Direct Integration | Schreibt direkt in PlannedMeals |
| Regenerate Feature | Einzelne Tage neu generieren |

---

## 2. Weekplan AI Modal

### 2.1 Modal UI

```
┌─────────────────────────────────┐
│  🧑‍🍳 Wochenplan-Assistent   [X]  │
├─────────────────────────────────┤
│                                 │
│  Ich kenn dich schon:           │
│  ┌─────────────────────────────┐│
│  │ 👥 2 Personen               ││
│  │ 🥬 Vegetarisch              ││
│  │ ⏱️ Max 30 Min               ││
│  │ 🚫 Keine Nüsse              ││
│  └─────────────────────────────┘│
│                                 │
│  ─────────────────────────────  │
│                                 │
│  Welche Tage soll ich füllen?   │
│                                 │
│  [Mo✓] [Di✓] [Mi✓] [Do✓] [Fr✓] │
│  [Sa ] [So ]                    │
│                                 │
│  Bereits geplant: Di Mittag     │
│  (wird nicht überschrieben)     │
│                                 │
│  ─────────────────────────────  │
│                                 │
│  Welche Mahlzeiten?             │
│  [  Frühstück  ]                │
│  [✓ Mittagessen ]               │
│  [✓ Abendessen  ]               │
│                                 │
│  ─────────────────────────────  │
│                                 │
│  Noch was Spezielles?           │
│  ┌─────────────────────────────┐│
│  │ viel Protein, wenig Carbs   ││
│  └─────────────────────────────┘│
│                                 │
│        [🧑‍🍳 Plan erstellen]       │
│                                 │
└─────────────────────────────────┘
```

### 2.2 State Management

```dart
// lib/features/ai/presentation/widgets/weekplan_ai_modal.dart

class WeekplanAIModal extends ConsumerStatefulWidget {}

class _WeekplanAIModalState extends ConsumerState<WeekplanAIModal> {
  // Selected days (default: next 5 weekdays)
  Set<int> selectedDays = {1, 2, 3, 4, 5}; // Mon-Fri

  // Selected meal slots
  Set<MealSlot> selectedSlots = {MealSlot.lunch, MealSlot.dinner};

  // Free text for special requests
  String specialRequest = '';

  // Loading state
  bool isGenerating = false;

  // Existing meals (to show "already planned")
  List<PlannedMeal> existingMeals = [];
}
```

### 2.3 Day Selection Logic

```dart
void initializeSelectedDays() {
  final now = DateTime.now();
  final aiProfile = ref.read(aiProfileProvider);

  // Pre-select based on learning context
  if (aiProfile?.learningContext.activeCookingDays.isNotEmpty ?? false) {
    selectedDays = Set.from(aiProfile!.learningContext.activeCookingDays);
  } else {
    // Default: cookingDaysPerWeek starting from today
    final daysToSelect = aiProfile?.cookingDaysPerWeek ?? 5;
    selectedDays = {};
    for (var i = 0; i < 7 && selectedDays.length < daysToSelect; i++) {
      final day = (now.weekday + i - 1) % 7 + 1;
      if (day <= 5) { // Weekdays only by default
        selectedDays.add(day);
      }
    }
  }
}
```

---

## 3. Context Builder

### 3.1 Full Context Assembly

```dart
// lib/features/ai/application/ai_context_builder.dart

@riverpod
class AIContextBuilder extends _$AIContextBuilder {

  Future<WeekplanAIContext> buildForWeekplan({
    required Set<int> selectedDays,
    required Set<MealSlot> selectedSlots,
    required String specialRequest,
  }) async {
    final userId = ref.read(authProvider).userId!;

    // Load all relevant data in parallel
    final results = await Future.wait([
      ref.read(userProfileRepositoryProvider).get(userId),
      ref.read(aiProfileRepositoryProvider).get(userId),
      ref.read(vegetableRepositoryProvider).getSeasonalForMonth(DateTime.now().month),
      ref.read(weekplanRepositoryProvider).getCurrentWeek(userId),
      ref.read(recipeRepositoryProvider).getFavorites(userId),
    ]);

    final userProfile = results[0] as UserProfile;
    final aiProfile = results[1] as AIProfile?;
    final seasonalVegetables = results[2] as List<Vegetable>;
    final existingPlan = results[3] as List<PlannedMeal>;
    final favoriteRecipes = results[4] as List<Recipe>;

    return WeekplanAIContext(
      // Safety constraints
      allergens: userProfile.allergens,
      diet: userProfile.diet,
      dislikes: userProfile.dislikes,

      // Household
      householdSize: userProfile.householdSize,
      childrenCount: userProfile.childrenCount,
      childrenAges: userProfile.childrenAges,

      // Cooking constraints
      maxCookingTimeMin: userProfile.maxCookingTimeMin,
      skill: userProfile.skill,

      // Premium preferences
      cuisinePreferences: aiProfile?.cuisinePreferences ?? [],
      flavorProfile: aiProfile?.flavorProfile ?? [],
      budgetLevel: aiProfile?.budgetLevel ?? BudgetLevel.normal,
      mealPrepStyle: aiProfile?.mealPrepStyle ?? MealPrepStyle.mixed,
      nutritionFocus: aiProfile?.nutritionFocus ?? NutritionFocus.balanced,
      healthGoals: aiProfile?.healthGoals ?? [],
      equipment: aiProfile?.equipment ?? [],

      // Learning context
      topIngredients: aiProfile?.learningContext.topIngredients ?? [],
      rejectedSuggestions: aiProfile?.learningContext.rejectedSuggestions ?? [],
      acceptedSuggestions: aiProfile?.learningContext.acceptedSuggestions ?? [],

      // Current data
      seasonalVegetables: seasonalVegetables.map((v) => v.name).toList(),
      existingPlan: existingPlan,
      favoriteRecipeStyles: _extractStyles(favoriteRecipes),

      // Request specifics
      selectedDays: selectedDays.toList(),
      selectedSlots: selectedSlots.map((s) => s.name).toList(),
      specialRequest: specialRequest,
      weekStartDate: _getWeekStart(),
    );
  }
}
```

### 3.2 Context Model

```dart
@freezed
class WeekplanAIContext with _$WeekplanAIContext {
  const factory WeekplanAIContext({
    // Safety (never violate)
    required List<Allergen> allergens,
    required DietType diet,
    required List<String> dislikes,

    // Household
    required int householdSize,
    required int childrenCount,
    List<int>? childrenAges,

    // Constraints
    required int maxCookingTimeMin,
    required CookingSkill skill,

    // Preferences
    required List<Cuisine> cuisinePreferences,
    required List<FlavorProfile> flavorProfile,
    required BudgetLevel budgetLevel,
    required MealPrepStyle mealPrepStyle,
    required NutritionFocus nutritionFocus,
    required List<HealthGoal> healthGoals,
    required List<KitchenEquipment> equipment,

    // Learning
    required List<String> topIngredients,
    required List<String> rejectedSuggestions,
    required List<String> acceptedSuggestions,

    // Current data
    required List<String> seasonalVegetables,
    required List<PlannedMeal> existingPlan,
    required List<String> favoriteRecipeStyles,

    // Request
    required List<int> selectedDays,
    required List<String> selectedSlots,
    required String specialRequest,
    required DateTime weekStartDate,
  }) = _WeekplanAIContext;
}
```

---

## 4. PocketBase AI Hook

### 4.1 Endpoint

```javascript
// backend/pb_hooks/ai_handler.js

routerAdd("POST", "/api/ai/generate-weekplan", async (c) => {
  const user = c.get("authRecord");
  if (!user) {
    return c.json(401, { error: "Unauthorized" });
  }

  // Premium check
  const aiProfile = await $app.dao().findFirstRecordByData("ai_profiles", "user_id", user.id);
  if (!aiProfile) {
    return c.json(403, { error: "Premium required" });
  }

  const body = $apis.requestInfo(c).data;

  // Build comprehensive prompt
  const prompt = buildWeekplanPrompt(body);

  // Call Gemini
  const response = await callGemini(prompt, {
    temperature: 0.8, // Slightly more creative for variety
    maxOutputTokens: 4096, // Longer for full week
  });

  // Log request
  await logAIRequest(user.id, "weekplan_gen", response.usage);

  return c.json(200, { weekplan: response.plan });
});
```

### 4.2 Prompt Template

```javascript
function buildWeekplanPrompt(context) {
  const existingMealsInfo = context.existingPlan
    .map(m => `${m.date} ${m.slot}: ${m.customTitle || 'Rezept geplant'}`)
    .join('\n');

  return `
Du bist ein Schweizer Ernährungsexperte und Meal-Planner. Erstelle einen Wochenplan.

## STRIKTE REGELN (NIEMALS VERLETZEN)
- Allergene ABSOLUT VERMEIDEN: ${context.allergens.join(", ") || "keine"}
- Ernährungsform STRIKT einhalten: ${context.diet}
- Dislikes VERMEIDEN: ${context.dislikes.join(", ") || "keine"}
- NICHT vorschlagen: ${context.rejectedSuggestions.join(", ") || "nichts"}

## HAUSHALT
- Personen: ${context.householdSize}
- Kinder: ${context.childrenCount}${context.childrenAges?.length ? ` (Alter: ${context.childrenAges.join(", ")})` : ''}
- Kochskill: ${context.skill}
- Max. Kochzeit pro Mahlzeit: ${context.maxCookingTimeMin} Minuten

## PRÄFERENZEN
- Lieblings-Küchen: ${context.cuisinePreferences.join(", ") || "alle"}
- Geschmacksprofil: ${context.flavorProfile.join(", ") || "ausgewogen"}
- Budget: ${context.budgetLevel}
- Kochstil: ${context.mealPrepStyle}
- Ernährungs-Fokus: ${context.nutritionFocus}
- Ziele: ${context.healthGoals.join(", ") || "keine besonderen"}
- Equipment: ${context.equipment.join(", ") || "Standard-Küche"}

## SAISONALES GEMÜSE (Dezember, Schweiz)
Verfügbar: ${context.seasonalVegetables.join(", ")}
Bevorzugt (User mag): ${context.topIngredients.join(", ") || "keine Präferenz"}

## BEREITS GEPLANT (NICHT ÜBERSCHREIBEN)
${existingMealsInfo || "Nichts geplant"}

## ANFRAGE
- Tage: ${context.selectedDays.map(d => ['', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'][d]).join(", ")}
- Mahlzeiten: ${context.selectedSlots.join(", ")}
- Woche startet: ${context.weekStartDate.toISOString().split('T')[0]}
- Spezielle Wünsche: ${context.specialRequest || "keine"}

## WICHTIGE RICHTLINIEN
1. Jede Mahlzeit verwendet mindestens 1 saisonales Gemüse
2. Abwechslung über die Woche (nicht 3x Pasta)
3. Kinderfreundliche Optionen wenn Kinder dabei
4. Meal-Prep berücksichtigen: Zutaten wiederverwenden wo sinnvoll
5. Gesamte Kochzeit pro Mahlzeit MUSS unter ${context.maxCookingTimeMin} Min sein

## OUTPUT FORMAT (JSON)
{
  "weekplan": [
    {
      "date": "2025-12-09",
      "dayName": "Montag",
      "meals": {
        "lunch": {
          "title": "Lauch-Risotto",
          "description": "Cremiges Risotto mit saisonalem Lauch",
          "mainVegetable": "Lauch",
          "prepTimeMin": 10,
          "cookTimeMin": 25,
          "servings": ${context.householdSize},
          "difficulty": "easy",
          "isVegetarian": true,
          "isVegan": false,
          "category": "main",
          "ingredients": [
            {"item": "Risotto-Reis", "amount": "300", "unit": "g"},
            {"item": "Lauch", "amount": "2", "unit": "Stangen"}
          ],
          "steps": ["Schritt 1...", "Schritt 2..."]
        },
        "dinner": {
          "title": "...",
          ...
        }
      }
    },
    {
      "date": "2025-12-10",
      "dayName": "Dienstag",
      "meals": { ... }
    }
  ],
  "mealPrepTips": [
    "Lauch am Sonntag vorbereiten für Mo & Mi",
    "Risotto-Reste am Di als Arancini verwenden"
  ],
  "shoppingListSummary": {
    "vegetables": ["Lauch: 4 Stangen", "Wirz: 1 Kopf"],
    "staples": ["Risotto-Reis: 600g", "Gemüsebrühe: 1.5L"],
    "dairy": ["Parmesan: 100g", "Butter: 50g"]
  }
}

Antworte NUR mit dem JSON, ohne Markdown.
`;
}
```

---

## 5. Plan Preview Screen

### 5.1 UI Layout

```
┌─────────────────────────────────┐
│  ← Zurück      Dein Wochenplan  │
├─────────────────────────────────┤
│                                 │
│  📅 Montag, 9. Dez              │
│  ┌─────────────────────────────┐│
│  │ 🍽️ Mittag                   ││
│  │ Lauch-Risotto               ││
│  │ ⏱️ 35 Min  👥 2 Pers        ││
│  │                    [🔄]     ││
│  └─────────────────────────────┘│
│  ┌─────────────────────────────┐│
│  │ 🌙 Abend                    ││
│  │ Wirz-Curry mit Reis         ││
│  │ ⏱️ 30 Min  👥 2 Pers        ││
│  │                    [🔄]     ││
│  └─────────────────────────────┘│
│                                 │
│  📅 Dienstag, 10. Dez           │
│  ┌─────────────────────────────┐│
│  │ 🍽️ Mittag                   ││
│  │ Kürbissuppe                 ││
│  │ ...                         ││
│  └─────────────────────────────┘│
│                                 │
│  ─────────────────────────────  │
│                                 │
│  💡 Meal-Prep Tipps             │
│  • Lauch am Sonntag vorbereiten │
│  • Reis für Mo & Di kochen      │
│                                 │
│  ─────────────────────────────  │
│                                 │
│  [Alles neu]    [✓ Übernehmen]  │
│                                 │
└─────────────────────────────────┘
```

### 5.2 Regenerate Single Day

```dart
// Per-day regenerate button [🔄]
Future<void> regenerateDay(int dayIndex) async {
  setState(() => regeneratingDay = dayIndex);

  try {
    final context = await ref.read(aiContextBuilderProvider).buildForSingleDay(
      date: weekplan[dayIndex].date,
      slots: weekplan[dayIndex].meals.keys.toList(),
      excludeRecipes: weekplan.map((d) => d.meals.values.map((m) => m.title)).expand((x) => x).toList(),
    );

    final newDay = await ref.read(aiServiceProvider).regenerateDay(context);

    setState(() {
      weekplan[dayIndex] = newDay;
    });

    // Track rejection for learning
    final oldDay = weekplan[dayIndex];
    for (final meal in oldDay.meals.values) {
      await ref.read(aiProfileRepositoryProvider).addRejectedSuggestion(meal.mainVegetable);
    }

  } finally {
    setState(() => regeneratingDay = null);
  }
}
```

---

## 6. Direct Integration

### 6.1 Save to PlannedMeals

```dart
// lib/features/ai/application/weekplan_save_service.dart

@riverpod
class WeekplanSaveService extends _$WeekplanSaveService {

  Future<void> saveGeneratedPlan(GeneratedWeekplan plan) async {
    final userId = ref.read(authProvider).userId!;
    final db = ref.read(appDatabaseProvider);
    final pb = ref.read(pocketbaseProvider);

    // Batch create all meals
    await db.batch((batch) async {
      for (final day in plan.weekplan) {
        for (final entry in day.meals.entries) {
          final slot = entry.key;
          final meal = entry.value;

          final plannedMeal = PlannedMeal(
            id: Uuid().v4(),
            userId: userId,
            date: DateTime.parse(day.date),
            slot: slot,
            // Store full recipe in customTitle for now
            // Or create Recipe first, then reference
            customTitle: meal.title,
            servings: meal.servings,
          );

          batch.insert(db.plannedMeals, plannedMeal.toCompanion());
        }
      }
    });

    // Sync to PocketBase
    for (final day in plan.weekplan) {
      for (final entry in day.meals.entries) {
        await pb.collection('planned_meals').create(body: {
          'user_id': userId,
          'date': day.date,
          'slot': entry.key,
          'custom_title': entry.value.title,
          'servings': entry.value.servings,
        });
      }
    }

    // Update learning context
    await _updateLearningFromPlan(plan);

    // Show success
    ref.read(snackbarProvider).show('Wochenplan gespeichert!');
  }

  Future<void> _updateLearningFromPlan(GeneratedWeekplan plan) async {
    final ingredients = <String>[];
    final categories = <String, int>{};

    for (final day in plan.weekplan) {
      for (final meal in day.meals.values) {
        ingredients.add(meal.mainVegetable);
        categories[meal.category] = (categories[meal.category] ?? 0) + 1;
      }
    }

    await ref.read(aiProfileRepositoryProvider).updateLearningContext(
      acceptedSuggestions: ingredients,
      categoryUsage: categories,
      activeCookingDays: plan.weekplan.map((d) => DateTime.parse(d.date).weekday).toList(),
    );
  }
}
```

### 6.2 Option: Create Recipes

Für eine reichhaltigere Integration können generierte Mahlzeiten auch als vollständige Rezepte gespeichert werden:

```dart
Future<void> saveAsRecipes(GeneratedWeekplan plan) async {
  for (final day in plan.weekplan) {
    for (final meal in day.meals.values) {
      // Create recipe
      final recipe = await ref.read(recipeRepositoryProvider).create(
        Recipe(
          id: Uuid().v4(),
          title: meal.title,
          description: meal.description,
          prepTimeMin: meal.prepTimeMin,
          cookTimeMin: meal.cookTimeMin,
          servings: meal.servings,
          difficulty: meal.difficulty,
          ingredients: meal.ingredients,
          steps: meal.steps,
          category: meal.category,
          source: RecipeSource.ai,
          userId: userId,
          isVegetarian: meal.isVegetarian,
          isVegan: meal.isVegan,
        ),
      );

      // Create planned meal with recipe reference
      await ref.read(weekplanRepositoryProvider).create(
        PlannedMeal(
          id: Uuid().v4(),
          userId: userId,
          date: DateTime.parse(day.date),
          slot: slot,
          recipeId: recipe.id, // Reference!
          servings: meal.servings,
        ),
      );
    }
  }
}
```

---

## 7. Shopping List Integration

### 7.1 Generate from Plan

Der AI-Planner liefert bereits eine `shoppingListSummary`. Diese kann direkt zur Einkaufsliste hinzugefügt werden:

```dart
Future<void> addToShoppingList(ShoppingListSummary summary) async {
  final items = <ShoppingItem>[];

  for (final veg in summary.vegetables) {
    items.add(ShoppingItem.fromString(veg, category: 'Gemüse'));
  }
  for (final staple in summary.staples) {
    items.add(ShoppingItem.fromString(staple, category: 'Vorrat'));
  }
  for (final dairy in summary.dairy) {
    items.add(ShoppingItem.fromString(dairy, category: 'Milchprodukte'));
  }

  await ref.read(shoppingListRepositoryProvider).addAll(items);

  // Optionally export to Bring!
  if (ref.read(bringConnectionProvider).isConnected) {
    await ref.read(bringServiceProvider).batchAdd(items);
  }
}
```

---

## 8. File Structure

```
lib/features/ai/
├── application/
│   ├── ai_context_builder.dart
│   └── weekplan_save_service.dart
│
├── presentation/
│   ├── widgets/
│   │   └── weekplan_ai_modal.dart
│   └── screens/
│       └── weekplan_preview_screen.dart
│
└── domain/
    └── models/
        ├── weekplan_ai_context.dart
        └── generated_weekplan.dart
```

---

## 9. Acceptance Criteria

### Must Have
- [ ] Weekplan AI Modal mit Day/Slot Auswahl
- [ ] Context Builder sammelt alle relevanten Daten
- [ ] PocketBase Hook generiert validen Wochenplan
- [ ] Plan Preview zeigt alle generierten Mahlzeiten
- [ ] "Übernehmen" schreibt direkt in PlannedMeals
- [ ] Existierende Einträge werden NICHT überschrieben
- [ ] Allergien werden NIEMALS verletzt

### Should Have
- [ ] "Einzelnen Tag neu generieren" Feature
- [ ] Meal-Prep Tipps werden angezeigt
- [ ] Einkaufsliste kann direkt generiert werden
- [ ] Loading States während Generation
- [ ] Pre-Selection basierend auf Learning Context

### Nice to Have
- [ ] Animated Plan Generation (progressive reveal)
- [ ] Swipe to dismiss single meal
- [ ] "Dieses Rezept merken" direkt aus Preview
- [ ] Wochenplan als PDF exportieren

---

## 10. Error Handling

```dart
// Common error scenarios

enum WeekplanError {
  noSeasonalVegetables,  // Edge case: empty DB
  generationFailed,       // Gemini error
  invalidResponse,        // JSON parse error
  quotaExceeded,          // Too many requests
  networkError,           // Offline
}

String getErrorMessage(WeekplanError error) {
  switch (error) {
    case WeekplanError.generationFailed:
      return 'Der Plan konnte nicht erstellt werden. Bitte versuch es nochmal.';
    case WeekplanError.quotaExceeded:
      return 'Du hast dein monatliches Limit erreicht.';
    case WeekplanError.networkError:
      return 'Keine Internetverbindung. Wochenplan braucht Online-Zugang.';
    default:
      return 'Ein Fehler ist aufgetreten.';
  }
}
```

---

## 11. Analytics Events

```dart
// Track for optimization
analytics.logEvent('weekplan_ai_started', {
  'selected_days': selectedDays.length,
  'selected_slots': selectedSlots.length,
  'has_special_request': specialRequest.isNotEmpty,
});

analytics.logEvent('weekplan_ai_completed', {
  'meals_generated': totalMeals,
  'generation_time_ms': duration,
});

analytics.logEvent('weekplan_ai_accepted', {
  'meals_saved': savedMeals,
  'days_regenerated': regeneratedDays,
});
```

---

*Phase 15 - AI Wochenplaner*
*Prerequisite: Phase 14 (AI Infrastructure)*
*Estimated Effort: 2 Wochen*
