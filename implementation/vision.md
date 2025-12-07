# Saisonier – Product Vision

**Version:** 2.0  
**Status:** Strategic Roadmap  
**Datum:** Dezember 2025

---

## 1. Executive Summary

Saisonier entwickelt sich vom **Saisonkalender** zum **intelligenten Meal-Planning-Hub** für die Schweiz. Die App kombiniert saisonale Ernährung mit KI-gestützter Wochenplanung und nahtloser Einkaufsintegration.

**Vision Statement:**
> *"Saisonier macht saisonales Kochen so einfach, dass es zur Gewohnheit wird – von der Inspiration bis zur Einkaufsliste."*

**Kernprinzip:** Alles funktioniert auch ohne KI. Premium-User erhalten intelligente Automatisierung.

---

## 2. Aktueller Stand (MVP v1.0)

### 2.1 Implementierte Features

| Feature | Beschreibung | Status |
|---------|--------------|--------|
| Seasonal Feed | Immersiver vertikaler Feed mit saisonalen "Heroes" | ✅ Done |
| Katalog Grid | Effiziente Übersicht mit Echtzeit-Suche | ✅ Done |
| Detail View | Rezepte, Saison-Visualisierung, Gyroscope-Cards | ✅ Done |
| Offline-First | Drift (SQLite) + PocketBase Sync | ✅ Done |
| User Auth | Guest Mode + Account mit Cloud-Sync | ✅ Done |
| Favoriten | Lokal + Cloud-Synchronisation | ✅ Done |

### 2.2 Technischer Stack

- **Frontend:** Flutter (Cross-Platform)
- **State:** Riverpod (AsyncNotifier, Code Generation)
- **Backend:** PocketBase (Auth, Database, Files)
- **Local DB:** Drift (SQLite, Offline-First)
- **Routing:** GoRouter (Type-Safe, Deep Links)
- **Models:** Freezed (Immutable Data Classes)

---

## 3. Produkt-Vision: Das Ökosystem

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            USER PROFILE                                      │
│     Allergien │ Diät │ Haushalt │ Kinder │ Kochskill │ Bring! Account       │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
          ┌─────────────────────────┼─────────────────────────┐
          ▼                         ▼                         ▼
┌─────────────────────┐   ┌─────────────────────┐   ┌─────────────────────┐
│      REZEPTE        │   │     WOCHENPLAN      │   │      EINKAUF        │
│                     │   │                     │   │                     │
│  • Kuratiert        │──▶│  • 7-Tage Ansicht   │──▶│  • Bring! Sync      │
│  • Eigene erstellen │   │  • Manuell planen   │   │  • Mengen addieren  │
│  • AI generiert     │   │  • AI Vorschläge    │   │  • Kategorisiert    │
│  • Familie teilen   │   │  • Filter/Constraints│   │                     │
└─────────────────────┘   └─────────────────────┘   └─────────────────────┘
          ▲                         ▲                         
          │                         │                         
          └───────────┬─────────────┘                         
                      │                                       
             ┌────────▼────────┐                              
             │   SAISONIER AI  │                              
             │                 │                              
             │  • Wochenplaner │                              
             │  • Rezept-Gen   │                              
             │  • Bild-Gen     │                              
             └─────────────────┘                              
```

---

## 4. Feature-Spezifikation

### 4.1 Erweitertes User Profile

**Zweck:** Personalisierung aller Empfehlungen und AI-Outputs.

```dart
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String userId,
    
    // Haushalt
    required int householdSize,
    required int childrenCount,
    List<int>? childrenAges,
    
    // Ernährung
    required List<Allergen> allergens,
    required DietType diet,
    List<String>? dislikes,
    
    // Kochen
    required CookingSkill skill,
    required int maxCookingTimeMin,
    
    // Externe Dienste
    String? bringEmail,
    String? bringListUuid,
  }) = _UserProfile;
}

enum Allergen { gluten, lactose, nuts, eggs, soy, shellfish, fish }
enum DietType { omnivore, vegetarian, vegan, pescatarian, flexitarian }
enum CookingSkill { beginner, intermediate, advanced }
```

**UI-Komponenten:**
- Onboarding-Flow für Ersteinrichtung
- Settings-Screen für Anpassungen
- Quick-Edit in der Wochenplan-Ansicht

---

### 4.2 Rezept-System

**Drei Rezept-Quellen:**

| Quelle | Beschreibung | Verfügbarkeit |
|--------|--------------|---------------|
| **Kuratiert** | Von Saisonier, qualitätsgeprüft | Free |
| **User** | Selbst erstellt oder importiert | Free |
| **AI-generiert** | Von Gemini erstellt, user-approved | Premium |

**Erweitertes Datenmodell:**

```dart
@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    required String id,
    required String title,
    String? subtitle,
    
    // Verknüpfungen
    required List<String> vegetableIds,
    
    // Metadaten
    required RecipeSource source,
    String? userId,
    String? familyId,
    required bool isPublic,
    
    // Zubereitung
    required int timeMin,
    required int servings,
    required Difficulty difficulty,
    required List<Ingredient> ingredients,
    required List<String> steps,
    String? tips,
    
    // Eignung
    required bool isKidFriendly,
    required bool isQuickMeal,
    required List<Allergen> containsAllergens,
    required DietType suitableFor,
    List<String>? tags,
    
    // Bilder
    String? imageUrl,
    String? aiGeneratedImageUrl,
  }) = _Recipe;
}

enum RecipeSource { curated, user, ai }
enum Difficulty { easy, medium, hard }
```

---

### 4.3 Wochenplanung

**Datenmodell:**

```dart
@freezed
class WeekPlan with _$WeekPlan {
  const factory WeekPlan({
    required String id,
    required String viserId,
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

@freezed
class PlannedMeal with _$PlannedMeal {
  const factory PlannedMeal({
    required String recipeId,
    required int servings,
    String? note,
  }) = _PlannedMeal;
}

enum MealSlot { breakfast, lunch, dinner }
```

**Funktionen:**

| Funktion | Free | Premium |
|----------|------|---------|
| Manuelles Drag & Drop | ✅ | ✅ |
| Rezept-Suche mit Filtern | ✅ | ✅ |
| "Nur Saisonales" Filter | ✅ | ✅ |
| AI "Plane meine Woche" | ❌ | ✅ |
| Meal-Prep Vorschläge | ❌ | ✅ |

---

### 4.4 Bring! Integration

**Technische Basis:** Inoffizielle REST API (https://api.getbring.com/rest/)

**Implementierung:**

```dart
class BringApiClient {
  static const _baseUrl = 'https://api.getbring.com/rest';
  
  String? _bearerToken;
  String? _userUuid;
  
  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/v2/bringauth'),
      body: {'email': email, 'password': password},
    );
    final data = jsonDecode(response.body);
    _bearerToken = data['access_token'];
    _userUuid = data['uuid'];
  }
  
  Future<List<BringList>> loadLists() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/bringusers/$_userUuid/lists'),
      headers: {'Authorization': 'Bearer $_bearerToken'},
    );
    return (jsonDecode(response.body)['lists'] as List)
        .map((e) => BringList.fromJson(e))
        .toList();
  }
  
  Future<void> saveItem(String listUuid, String item, String? spec) async {
    await http.put(
      Uri.parse('$_baseUrl/v2/bringlists/$listUuid'),
      headers: {
        'Authorization': 'Bearer $_bearerToken',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'uuid=${Uuid().v4()}&itemId=$item&spec=${spec ?? ""}',
    );
  }
  
  Future<void> batchAddItems(String listUuid, List<ShoppingItem> items) async {
    // Batch-API für mehrere Items gleichzeitig
  }
}
```

**Smart Aggregation (Premium):**

```
Wochenplan enthält:
├─ Montag: Rüebli-Risotto (200g Rüebli)
├─ Mittwoch: Rüebli-Suppe (300g Rüebli)
├─ Donnerstag: Pasta (2 Zwiebeln)
└─ Freitag: Salat (1 Zwiebel)

→ Bring! Einkaufsliste:
  • Rüebli: 500g
  • Zwiebeln: 3 Stück
```

---

### 4.5 AI-Features (Premium)

#### 4.5.1 AI Wochenplaner

**Input:**
- User Profile (Allergien, Diät, Haushalt)
- Constraints (Zeit, Budget, Skill)
- Saisonale Verfügbarkeit
- Bisherige Favoriten

**Prompt-Strategie:**

```dart
String buildWeekPlanPrompt(WeekPlanRequest request) => '''
Du bist ein Schweizer Ernährungsexperte und Meal-Planner.

KONTEXT:
- Haushalt: ${request.profile.householdSize} Personen
- Kinder: ${request.profile.childrenCount} (Alter: ${request.profile.childrenAges?.join(', ')})
- Allergien: ${request.profile.allergens.join(', ')}
- Diät: ${request.profile.diet}
- Max. Kochzeit: ${request.profile.maxCookingTimeMin} Minuten
- Kochskill: ${request.profile.skill}

SAISONALES GEMÜSE (Dezember, Schweiz):
${request.seasonalVegetables.map((v) => '- ${v.name}').join('\n')}

AUFGABE:
Erstelle einen Wochenplan für ${request.meals.join(', ')} von ${request.startDate} bis ${request.endDate}.

ANFORDERUNGEN:
- Nur saisonales Gemüse verwenden
- Kinderfreundliche Optionen wenn Kinder vorhanden
- Allergien strikt beachten
- Abwechslung über die Woche
- Zutaten wiederverwenden wo sinnvoll (Meal-Prep)

OUTPUT FORMAT (JSON):
{
  "days": [
    {
      "date": "2025-12-09",
      "meals": {
        "lunch": {"recipeTitle": "...", "servings": 4, "mainVegetable": "..."},
        "dinner": {"recipeTitle": "...", "servings": 4, "mainVegetable": "..."}
      }
    }
  ],
  "shoppingList": [...],
  "mealPrepTips": [...]
}
''';
```

#### 4.5.2 AI Rezept-Generator

**Use Cases:**
- "Gib mir ein schnelles Rezept mit Lauch"
- "Kinderfreundliches Abendessen ohne Milch"
- "Was kann ich mit Wirz und Kartoffeln machen?"

#### 4.5.3 AI Bildgenerierung

**Modell:** Nano Banana Pro (Gemini 3 Pro Image)

**Vorteile:**
- Hochwertige Food-Photography
- Akkurates Text-Rendering (für Overlays)
- 2K/4K Auflösung

**Prompt-Template:**

```dart
String buildRecipeImagePrompt(Recipe recipe) => '''
Professional food photography of: ${recipe.title}

Style: appetizing, natural lighting, shallow depth of field
Setting: rustic Swiss kitchen, wooden table, fresh herbs
Composition: hero shot, 45-degree angle, garnished
Mood: warm, inviting, homemade

Main ingredients visible: ${recipe.ingredients.take(3).map((i) => i.item).join(', ')}
''';
```

---

## 5. Technische Architektur

### 5.1 AI Provider Abstraction (PocketBase Proxy)

**Architektur:**
App -> PocketBase (API Client) -> Google Gemini API.
Der API Key liegt sicher auf dem Server (PocketBase Umgebungsvariablen).

**App Logic:**

```dart
// Die App ruft nur noch PocketBase auf
final result = await pb.collection('ai_generation').create({
  'prompt': '...',
  'type': 'recipe_gen',
});
```

**PocketBase Logic (Hooks):**
Ein serverseitiger Hook (JS/Go) fängt den Create-Request ab, validiert ihn, ruft Gemini auf und speichert das Ergebnis.

**Vorteile:**
- Kein Firebase nötig.
- API Key sicher.
- Volle Kontrolle über ratelimits.

### 5.2 Subscription Management

**Provider:** RevenueCat

**Entitlements:**

| Entitlement ID | Beschreibung |
|----------------|--------------|
| `premium` | Premium-Plan aktiv |
| `pro` | Pro-Plan aktiv |

**Implementation:**

```dart
@riverpod
class SubscriptionService extends _$SubscriptionService {
  @override
  Future<SubscriptionState> build() async {
    final customerInfo = await Purchases.getCustomerInfo();
    return SubscriptionState(
      isPremium: customerInfo.entitlements.active.containsKey('premium'),
      isPro: customerInfo.entitlements.active.containsKey('pro'),
      expirationDate: customerInfo.entitlements.active['premium']?.expirationDate,
    );
  }
  
  Future<bool> canUseAiFeature() async {
    final state = await future;
    return state.isPremium || state.isPro;
  }
  
  Future<int> getMonthlyImageLimit() async {
    final state = await future;
    if (state.isPro) return -1; // Unbegrenzt
    if (state.isPremium) return 10;
    return 0;
  }
}
```

---

## 6. Monetarisierung

### 6.1 Pricing-Modell

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│  🆓 FREE                             │  ⭐ PREMIUM                          │
│  CHF 0.–                             │  CHF 5.90 / Monat                    │
│                                      │  (CHF 59.– / Jahr)                   │
│  ─────────────────────────────────   │  ─────────────────────────────────   │
│                                      │                                      │
│  ✓ Saisonkalender (Feed + Grid)     │  ✓ Alles aus Free                    │
│  ✓ Alle Gemüse-Details              │                                      │
│  ✓ Kuratierte Rezepte               │  ✨ AI Wochenplaner                  │
│  ✓ Eigene Rezepte erstellen         │  ✨ AI Rezept-Generator              │
│  ✓ Favoriten (Sync)                 │  ✨ 10 AI-Bilder / Monat (2K)        │
│  ✓ User Profile                     │  ✨ Smart Einkaufslisten-Aggregation │
│  ✓ Bring! Verbindung                │  ✨ Meal-Prep Vorschläge             │
│  ✓ Manueller Wochenplan             │                                      │
│  ✓ Einzelne Rezepte → Bring!        │                                      │
│                                      │                                      │
├──────────────────────────────────────┼──────────────────────────────────────┤
│                                      │                                      │
│                                      │  💎 PRO                              │
│                                      │  CHF 12.90 / Monat                   │
│                                      │  (CHF 119.– / Jahr)                  │
│                                      │  ─────────────────────────────────   │
│                                      │                                      │
│                                      │  ✓ Alles aus Premium                 │
│                                      │                                      │
│                                      │  ✨ Unbegrenzte AI-Bilder (4K)       │
│                                      │  ✨ Familien-Profile (bis 5)         │
│                                      │  ✨ Geteilte Wochenpläne             │
│                                      │  ✨ Ernährungs-Insights              │
│                                      │  ✨ PDF Export                       │
│                                      │  ✨ Priority Support                 │
│                                      │                                      │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 6.2 Kosten-Kalkulation

**API-Kosten pro User/Monat:**

| Feature | Premium | Pro |
|---------|---------|-----|
| Text AI (Wochenpläne, Rezepte) | ~$0.05 | ~$0.10 |
| Bilder (10x 2K vs. 20x 4K avg.) | ~$1.34 | ~$4.80 |
| **Total API** | **~$1.39** | **~$4.90** |

**Marge:**

| | Premium (CHF 5.90) | Pro (CHF 12.90) |
|---|---|---|
| Einnahmen (USD) | ~$6.60 | ~$14.45 |
| API-Kosten | -$1.39 | -$4.90 |
| Store Fee (30%) | -$1.98 | -$4.34 |
| RevenueCat (~1%) | -$0.07 | -$0.14 |
| **Netto-Marge** | **$3.16** | **$5.07** |
| **Marge %** | **48%** | **35%** |

### 6.3 Paywall UX

```
┌─────────────────────────────────────────┐
│                                         │
│  ✨ Premium Feature                     │
│                                         │
│  Der AI-Wochenplaner erstellt dir      │
│  automatisch einen Plan basierend auf:  │
│                                         │
│  🥬 Was gerade Saison hat              │
│  👨‍👩‍👧 Deinem Haushalt                    │
│  🚫 Deinen Allergien                   │
│  ⏱️ Deiner verfügbaren Zeit            │
│                                         │
│  ───────────────────────────────────    │
│                                         │
│  ⭐ Premium: CHF 5.90/Monat            │
│  💎 Pro: CHF 12.90/Monat               │
│                                         │
│  [🎁 7 Tage gratis testen]             │
│                                         │
│  [Manuell planen (Free)]               │
│                                         │
└─────────────────────────────────────────┘
```

---

## 7. Implementierungs-Roadmap

### Phase 9: Profile+ (Erweitertes User Profile)

**Status:** Done

**Scope:**
- [x] UserProfile Datenmodell erweitern
- [x] Onboarding-Flow für Profilsetup
- [x] Settings-Screen mit allen Optionen
- [x] PocketBase Schema Update

---

### Phase 10: Bring! Integration

**Status:** Done

**Scope:**
- [x] BringApiClient implementieren (mit API-Key Headers)
- [x] Login-Flow in Settings (inkl. Social-Login Hilfe)
- [x] Auto-Auswahl der Default-Liste
- [x] "Auf Einkaufsliste" Button bei Rezepten
- [x] Credential Storage (flutter_secure_storage)

---

### Phase 11: User Rezepte

**Status:** Done

**Scope:**
- [x] Recipe Datenmodell erweitern (source, userId, servings, difficulty)
- [x] Rezept-Editor UI (dynamische Zutaten/Schritte)
- [x] Bild-Upload (image_picker)
- [x] "Meine Rezepte" Tab (3. Tab in Navigation)
- [x] CRUD-Operationen (Create, Update, Delete)

---

### Phase 12: Wochenplan Basic

**Status:** Geplant  
**Aufwand:** 2-3 Wochen

**Scope:**
- [ ] WeekPlan Datenmodell
- [ ] Kalender-UI (7-Tage-Ansicht)
- [ ] Drag & Drop Rezepte
- [ ] Portionen anpassen
- [ ] Saisonale Filter

---

### Phase 13: Einkaufslisten-Export

**Status:** Geplant  
**Aufwand:** 1 Woche

**Scope:**
- [ ] Zutaten aus Wochenplan aggregieren
- [ ] Mengen addieren (gleiche Zutaten)
- [ ] Kategorisierung
- [ ] Batch-Export zu Bring!

---

### Phase 14: AI Rezept-Generator (Premium)

**Status:** Geplant  
**Aufwand:** 2 Wochen

**Scope:**
- [ ] Firebase AI Logic Setup
- [ ] Gemini Provider implementieren
- [ ] Prompt Engineering
- [ ] UI für Rezept-Generierung
- [ ] Review & Speichern Flow
- [ ] Entitlement Check

---

### Phase 15: AI Wochenplaner (Premium)

**Status:** Geplant  
**Aufwand:** 2-3 Wochen

**Scope:**
- [ ] Wochenplan-Prompt Builder
- [ ] Structured Output Parsing
- [ ] Constraint-UI
- [ ] Vorschau & Anpassen
- [ ] Meal-Prep Suggestions

---

### Phase 16: AI Bildgenerierung (Premium)

**Status:** Geplant  
**Aufwand:** 1-2 Wochen

**Scope:**
- [ ] Nano Banana Pro Integration
- [ ] Food Photography Prompts
- [ ] Image Caching
- [ ] Usage Tracking & Limits
- [ ] Fallback zu Placeholder

---

### Phase 17: Familien-Features (Pro)

**Status:** Geplant  
**Aufwand:** 3-4 Wochen

**Scope:**
- [ ] Multi-Profile Support
- [ ] Familien-Gruppe in PocketBase
- [ ] Geteilte Rezeptsammlung
- [ ] Geteilter Wochenplan
- [ ] Kinder-spezifische Einstellungen
- [ ] Ernährungs-Insights

---

### Phase 18: Monetarisierung

**Status:** Geplant  
**Aufwand:** 2 Wochen

**Scope:**
- [ ] RevenueCat Integration
- [ ] App Store / Play Store Produkte
- [ ] Paywall UI
- [ ] Entitlement Guards
- [ ] Free Trial (7 Tage)
- [ ] Analytics & Conversion Tracking

---

## 8. Technische Voraussetzungen

### 8.1 Neue Dependencies

```yaml
dependencies:
  # AI (via PocketBase - no extra dep needed)
  
  # Subscriptions
  purchases_flutter: ^9.x
  
  # HTTP (für Bring! API)
  http: ^1.x
  
  # Storage (für Credentials)
  flutter_secure_storage: ^9.x
```

### 8.2 PocketBase Setup
1. `GEMINI_API_KEY` als Environment Variable setzen.
2. `pb_hooks` Ordner erstellen.
3. JavaScript Hook `ai instructions.pb.js` anlegen.

### 8.3 RevenueCat Setup

1. RevenueCat Account erstellen
2. App Store Connect Produkte anlegen
3. Google Play Console Produkte anlegen
4. Entitlements konfigurieren
5. API Keys in App integrieren

---

## 9. Risiken & Mitigationen

| Risiko | Wahrscheinlichkeit | Impact | Mitigation |
|--------|-------------------|--------|------------|
| Bring! API bricht | Mittel | Hoch | Fallback zu manueller Liste, eigene Listen-Funktion |
| AI-Kosten explodieren | Niedrig | Hoch | Usage Limits, Monitoring, günstigere Modelle als Fallback |
| Gemini Downtime | Niedrig | Mittel | Graceful Degradation, Caching, Offline-Fallback |
| Store Rejection | Niedrig | Hoch | Guidelines befolgen, Soft Launch |
| Geringe Conversion | Mittel | Mittel | Paywall A/B Testing, Feature-Iteration |

---

## 10. Erfolgsmetriken

### 10.1 Engagement

| Metrik | Ziel (6 Monate) |
|--------|-----------------|
| WAU (Weekly Active Users) | 5'000 |
| Rezepte erstellt / User | 3 |
| Wochenpläne erstellt / Woche | 1.5 |
| Bring! Exports / Woche | 2 |

### 10.2 Monetarisierung

| Metrik | Ziel (6 Monate) |
|--------|-----------------|
| Free → Premium Conversion | 5% |
| Premium → Pro Upsell | 15% |
| Monthly Churn | < 8% |
| ARPU (Average Revenue Per User) | CHF 1.20 |

### 10.3 Qualität

| Metrik | Ziel |
|--------|------|
| App Store Rating | ≥ 4.5 ⭐ |
| Crash-Free Rate | ≥ 99.5% |
| AI-Zufriedenheit (Thumbs up) | ≥ 80% |

---

## 11. Anhang

### A. Wettbewerbs-Analyse

| App | Stärken | Schwächen | Differenzierung Saisonier |
|-----|---------|-----------|---------------------------|
| Eat This Much | AI Meal Planning | Kein CH-Fokus, keine Saisonalität | Schweizer Saisonkalender |
| Mealime | Schöne UI, Rezepte | Keine AI, kein Offline | Offline-First, AI-powered |
| Bring! | Beste Einkaufsliste | Keine Rezepte/Planung | Integration statt Konkurrenz |

### B. User Personas

**Persona 1: Sarah (32), berufstätige Mutter**
- 2 Kinder (4 und 7 Jahre)
- Wenig Zeit zum Planen
- Möchte gesund und saisonal kochen
- → Pro Plan (Familien-Features)

**Persona 2: Marco (28), Hobbykoch**
- Single-Haushalt
- Experimentierfreudig
- Sucht Inspiration
- → Premium Plan

**Persona 3: Elena (45), Gesundheitsbewusst**
- Laktoseintoleranz
- Plant gerne voraus
- Nutzt Bring! bereits
- → Premium Plan

---

*Dokument erstellt: Dezember 2025*  
*Nächste Review: Q1 2026*
