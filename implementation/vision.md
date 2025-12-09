# Saisonier - Product Vision

**Version:** 3.0
**Status:** Strategic Roadmap (AI Integration)
**Datum:** Dezember 2025

---

## 1. Executive Summary

Saisonier entwickelt sich vom **Saisonkalender** zum **intelligenten Meal-Planning-Hub** für die Schweiz. Die App kombiniert saisonale Ernährung mit KI-gestützter Wochenplanung und nahtloser Einkaufsintegration.

**Vision Statement:**
> *"Saisonier macht saisonales Kochen so einfach, dass es zur Gewohnheit wird - von der Inspiration bis zur Einkaufsliste."*

**Kernprinzip:** Alles funktioniert auch ohne KI. Premium-User erhalten intelligente Automatisierung, die sich an ihre Präferenzen anpasst und mit der Zeit lernt.

**AI-Philosophie:**
> *"Kein Chat-Bot, sondern kontextueller Assistent. Die AI kennt dich, deine Familie, deine Saison - und liefert Ergebnisse direkt in deinen Plan."*

---

## 2. Aktueller Stand (MVP Complete + Phase 12)

### 2.1 Implementierte Features

| Feature | Beschreibung | Status |
|---------|--------------|--------|
| Seasonal Feed | Immersiver vertikaler Feed mit saisonalen "Heroes" | Done |
| Katalog Grid | Effiziente Übersicht mit Echtzeit-Suche | Done |
| Detail View | Rezepte, Saison-Visualisierung, Gyroscope-Cards | Done |
| Offline-First | Drift (SQLite) + PocketBase Sync | Done |
| User Auth | Guest Mode + Account mit Cloud-Sync | Done |
| Favoriten | Lokal + Cloud-Synchronisation | Done |
| User Profile | Haushalt, Allergien, Diät, Kochskill | Done |
| Bring! Integration | Einkaufsliste sync | Done |
| User Recipes | CRUD für eigene Rezepte | Done |
| Wochenplan | Manuelles Meal Planning | Done |

### 2.2 Technischer Stack

- **Frontend:** Flutter (Cross-Platform)
- **State:** Riverpod (AsyncNotifier, Code Generation)
- **Backend:** PocketBase (Auth, Database, Files, AI Proxy)
- **Local DB:** Drift (SQLite, Offline-First)
- **Routing:** GoRouter (Type-Safe, Deep Links)
- **Models:** Freezed (Immutable Data Classes)
- **AI:** Gemini API via PocketBase Proxy

---

## 3. AI Integration Konzept

### 3.1 Warum nicht einfach ChatGPT?

| ChatGPT | Saisonier AI |
|---------|--------------|
| "Gib mir einen Wochenplan" | Kennt deinen Haushalt, Allergien, was Saison hat |
| Ergebnis: Text-Wall | Ergebnis: Direkt im Wochenplan |
| Copy-Paste Zutaten | Ein Tap -> Bring! Export |
| Jedes Mal neu erklären | Lernt aus deinem Verhalten |
| Generic global | Swiss-focused (Wirz, Rüebli, Nüsslisalat) |

**Der Mehrwert:** Kontextuelle Integration. Die AI ist kein separates Tool, sondern versteht den User und seine Daten.

### 3.2 AI Interaction Paradigma: Contextual FAB

**Entscheidung:** Kein Chat-Interface, sondern kontextuelle AI-Actions via Floating Action Button (FAB).

```
┌─────────────────────────────────────────────────────────────────┐
│                        AI FAB KONZEPT                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Screen: Wochenplan          Screen: Rezepte                     │
│  ┌─────────────────┐         ┌─────────────────┐                │
│  │                 │         │                 │                │
│  │   [Plan Grid]   │         │  [Recipe List]  │                │
│  │                 │         │                 │                │
│  │           [FAB] │         │           [FAB] │                │
│  └─────────────────┘         └─────────────────┘                │
│         │                           │                           │
│         ▼                           ▼                           │
│  ┌─────────────────┐         ┌─────────────────┐                │
│  │ Plan-Assistent  │         │ Rezept-Ideen    │                │
│  │                 │         │                 │                │
│  │ • Welche Tage?  │         │ • Saison-Gemüse │                │
│  │ • Mahlzeiten?   │         │ • Was hast du?  │                │
│  │ • Extras?       │         │ • Art?          │                │
│  │                 │         │                 │                │
│  │ [Generieren]    │         │ [Generieren]    │                │
│  └─────────────────┘         └─────────────────┘                │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Vorteile:**
- Strukturierter Input (Checkboxen + optionaler Freitext)
- Kontext ist vorausgefüllt (Profil, Saison)
- Ergebnis landet direkt in der App (kein Copy-Paste)
- Klare Actions statt offener Chat

### 3.3 AI Persönlichkeit

**Ton:** Neutral-freundlich mit Swiss Touch, leicht Coach-artig

- **Nicht:** "Hier ist dein Plan." (zu kalt)
- **Nicht:** "OMG das wird so lecker!!!" (zu übertrieben)
- **Richtig:** "Ich hab dir einen Plan mit viel saisonalem Gemüse zusammengestellt. Lauch und Wirz sind gerade mega frisch!"

### 3.4 Reaktiv vs. Proaktiv

**Entscheidung:** Primär reaktiv (kostensparender, weniger nervig)

| Verhalten | Implementierung |
|-----------|-----------------|
| **Reaktiv** | AI nur wenn User FAB tippt |
| **Passiv-Hint** | "Dein Plan ist leer" Badge (kein AI-Call) |
| **Kein Push** | Keine proaktiven Notifications mit AI-Content |

---

## 4. User Profile Architektur

### 4.1 Zwei-Tier Profil System

```
┌─────────────────────────────────────────────────────────────────┐
│  user_profiles (Free + Premium)                                  │
├─────────────────────────────────────────────────────────────────┤
│  • householdSize, childrenCount, childrenAges                   │
│  • allergens (STRICT)                                           │
│  • diet (vegetarian, vegan, etc.)                               │
│  • dislikes                                                      │
│  • skill, maxCookingTimeMin                                     │
│  • bringListUuid                                                │
└─────────────────────────────────────────────────────────────────┘
                              +
┌─────────────────────────────────────────────────────────────────┐
│  ai_profiles (Premium Only - separate Collection)                │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  EXPLIZIT (User gibt ein via Premium Onboarding):               │
│  • cuisinePreferences: [Italienisch, Asiatisch, Schweizer]      │
│  • flavorProfile: [würzig, cremig, herzhaft]                    │
│  • likes: ["Pasta", "Suppen", "Eintöpfe"]                       │
│  • proteinPreferences: [Poulet, Fisch, Tofu]                    │
│  • budgetLevel: sparsam / normal / premium                      │
│  • mealPrepStyle: täglich / meal-prep / mix                     │
│  • cookingDaysPerWeek: 4                                        │
│  • healthGoals: [mehr Energie, gesund essen]                    │
│  • nutritionFocus: balanced / high-protein / low-carb           │
│  • equipment: [Ofen, Mixer, Airfryer]                           │
│                                                                  │
│  IMPLIZIT (System lernt automatisch):                           │
│  • learningContext.topIngredients                               │
│  • learningContext.categoryUsage                                │
│  • learningContext.acceptedSuggestions                          │
│  • learningContext.rejectedSuggestions                          │
│  • learningContext.activeCookingDays                            │
│  • learningContext.avgServings                                  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 4.2 Warum separate ai_profiles Collection?

1. **Clean Separation** - AI-Daten isoliert
2. **Free User Overhead** - Kein leerer Premium-Ballast
3. **Premium-Check einfach** - Eintrag existiert = Premium aktiv
4. **GDPR-freundlich** - "AI-Daten löschen" ohne Profilverlust
5. **Evolution** - AI-Schema kann sich unabhängig entwickeln

---

## 5. Premium Onboarding Flow

Wenn User Premium kauft, wird der "AI Chef Setup" gestartet:

### Screen 1: Welcome
```
┌─────────────────────────────────┐
│                                 │
│  🎉 Willkommen bei Premium!     │
│                                 │
│  Lass uns deinen persönlichen   │
│  AI Chef einrichten.            │
│                                 │
│  Je mehr ich über dich weiss,   │
│  desto besser werden meine      │
│  Vorschläge.                    │
│                                 │
│  [Los geht's]    [Später]       │
│                                 │
└─────────────────────────────────┘
```

### Screen 2: Küche & Geschmack
```
┌─────────────────────────────────┐
│  Was isst du am liebsten?       │
│  (Mehrfachauswahl)              │
│                                 │
│  [Italienisch]  [Schweizer]     │
│  [Asiatisch]    [Mexikanisch]   │
│  [Indisch]      [Mediterran]    │
│                                 │
│  ─────────────────────────────  │
│                                 │
│  Geschmacksprofil:              │
│  [Würzig] [Mild] [Cremig]       │
│  [Knusprig] [Herzhaft]          │
│                                 │
│                      [Weiter]   │
└─────────────────────────────────┘
```

### Screen 3: Budget & Stil
```
┌─────────────────────────────────┐
│  Wie kochst du am liebsten?     │
│                                 │
│  Budget:                        │
│  ○ Sparsam (Basics, günstig)    │
│  ● Normal (gute Zutaten)        │
│  ○ Premium (Spezialitäten ok)   │
│                                 │
│  ─────────────────────────────  │
│                                 │
│  Kochstil:                      │
│  ○ Täglich frisch kochen        │
│  ○ Meal Prep (vorkochen)        │
│  ● Mix aus beidem               │
│                                 │
│  Wie oft pro Woche?             │
│  [−]  4 Tage  [+]               │
│                                 │
│                      [Weiter]   │
└─────────────────────────────────┘
```

### Screen 4: Ziele (Optional)
```
┌─────────────────────────────────┐
│  Hast du besondere Ziele?       │
│  (Optional)                     │
│                                 │
│  [ ] Abnehmen                   │
│  [ ] Mehr Energie               │
│  [ ] Muskelaufbau               │
│  [✓] Einfach gesund essen       │
│                                 │
│  ─────────────────────────────  │
│                                 │
│  Ernährungs-Fokus:              │
│  ○ High Protein                 │
│  ○ Low Carb                     │
│  ● Ausgewogen                   │
│                                 │
│  [Skip]              [Weiter]   │
└─────────────────────────────────┘
```

### Screen 5: Fertig!
```
┌─────────────────────────────────┐
│                                 │
│         🧑‍🍳                      │
│                                 │
│  Perfekt! Ich kenne dich jetzt: │
│                                 │
│  • 2-Personen Haushalt          │
│  • Vegetarisch, keine Nüsse     │
│  • Liebst Italienisch & Asien   │
│  • Budget: Normal               │
│  • 4x pro Woche kochen          │
│                                 │
│  Ich bin bereit!                │
│                                 │
│       [Zum Wochenplan]          │
│                                 │
└─────────────────────────────────┘
```

---

## 6. AI Features (Premium)

### 6.1 Wochenplan AI (Phase 15)

**Trigger:** FAB im Wochenplan-Screen

**Modal UI:**
```
┌─────────────────────────────────┐
│  🧑‍🍳 Wochenplan-Assistent        │
├─────────────────────────────────┤
│                                 │
│  Ich kenn dich:                 │
│  • 2 Personen, vegetarisch      │
│  • Max 30min Kochzeit           │
│  • Keine Nüsse                  │
│                                 │
│  ─────────────────────────────  │
│                                 │
│  Welche Tage?                   │
│  [Mo✓] [Di✓] [Mi✓] [Do ] [Fr✓] │
│                                 │
│  Mahlzeiten:                    │
│  [✓ Mittag] [✓ Abendessen]     │
│                                 │
│  Extras? (optional)             │
│  ┌─────────────────────────────┐│
│  │ viel Protein diese Woche   ││
│  └─────────────────────────────┘│
│                                 │
│        [🧑‍🍳 Plan erstellen]       │
│                                 │
└─────────────────────────────────┘
```

**Output:** Strukturierter Plan direkt in PlannedMeals gespeichert.

### 6.2 Rezept-Generator AI (Phase 14)

**Trigger:** FAB im Rezepte-Screen

**Modal UI:**
```
┌─────────────────────────────────┐
│  🧑‍🍳 Rezept-Ideen                │
├─────────────────────────────────┤
│                                 │
│  Aktuell Saison:                │
│  [Lauch] [Wirz] [Randen] [+3]   │
│                                 │
│  Was hast du da? (optional)     │
│  ┌─────────────────────────────┐│
│  │ Kartoffeln, Zwiebeln        ││
│  └─────────────────────────────┘│
│                                 │
│  Art:                           │
│  [Schnell] [Comfort] [Gesund]   │
│                                 │
│        [🧑‍🍳 Rezept generieren]   │
│                                 │
└─────────────────────────────────┘
```

**Output:** Vollständiges Rezept zum Review, dann als `source: ai` speichern.

### 6.3 AI Bildgenerierung (Phase 16)

**Trigger:** Im Rezept-Editor für AI-generierte Rezepte

**Quota:** 10 Bilder/Monat (Premium), Unlimited (Pro)

---

## 7. Technische Architektur

### 7.1 AI Provider (PocketBase Proxy)

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│   Flutter App                                                    │
│   ┌──────────────────────────────────────────────────────────┐  │
│   │  AIService                                                │  │
│   │  • generateWeekPlan(context, options)                     │  │
│   │  • generateRecipe(context, options)                       │  │
│   │  • generateImage(recipe)                                  │  │
│   └──────────────────────────────────────────────────────────┘  │
│                              │                                   │
│                              ▼                                   │
│   ┌──────────────────────────────────────────────────────────┐  │
│   │  PocketBase Client                                        │  │
│   │  pb.collection('ai_requests').create({...})              │  │
│   └──────────────────────────────────────────────────────────┘  │
│                                                                  │
└──────────────────────────────│───────────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────────┐
│  PocketBase Server                                               │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  pb_hooks/ai_handler.js                                   │   │
│  │                                                           │   │
│  │  onRecordBeforeCreate('ai_requests'):                     │   │
│  │  1. Validate user is Premium (check ai_profiles exists)   │   │
│  │  2. Check quota (ai_requests count this month)            │   │
│  │  3. Build prompt with full context                        │   │
│  │  4. Call Gemini API                                       │   │
│  │  5. Parse & validate response                             │   │
│  │  6. Return structured result                              │   │
│  └──────────────────────────────────────────────────────────┘   │
│                              │                                   │
│                              ▼                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Gemini API (gemini-2.0-flash / gemini-pro)              │   │
│  │  GEMINI_API_KEY in Environment                            │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Vorteile:**
- API Key sicher auf Server
- Rate Limiting server-side
- Premium-Check server-side (kein Client-Bypass)
- Logging & Analytics zentral

### 7.2 Context Building

```dart
class AIContextBuilder {
  Future<AIContext> build(String userId) async {
    final userProfile = await userProfileRepo.get(userId);
    final aiProfile = await aiProfileRepo.get(userId);
    final seasonalVegetables = await vegetableRepo.getSeasonal(DateTime.now().month);
    final favorites = await vegetableRepo.getFavorites(userId);
    final existingPlan = await weekplanRepo.getCurrentWeek(userId);

    return AIContext(
      // Safety (never violate)
      allergens: userProfile.allergens,
      diet: userProfile.diet,
      dislikes: userProfile.dislikes,

      // Household
      householdSize: userProfile.householdSize,
      childrenCount: userProfile.childrenCount,

      // Constraints
      maxCookingTime: userProfile.maxCookingTimeMin,
      skill: userProfile.skill,

      // Premium preferences
      cuisines: aiProfile?.cuisinePreferences ?? [],
      flavors: aiProfile?.flavorProfile ?? [],
      budget: aiProfile?.budgetLevel ?? BudgetLevel.normal,

      // Learned
      topIngredients: aiProfile?.learningContext.topIngredients ?? [],
      rejectedSuggestions: aiProfile?.learningContext.rejectedSuggestions ?? [],

      // Current data
      seasonalVegetables: seasonalVegetables,
      favorites: favorites,
      existingPlan: existingPlan,
    );
  }
}
```

---

## 8. Monetarisierung

### 8.1 Pricing

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                  │
│  🆓 FREE                           ⭐ PREMIUM                    │
│  CHF 0.–                           CHF 5.90 / Monat             │
│                                    (CHF 59.– / Jahr)            │
│  ─────────────────────────────     ─────────────────────────    │
│                                                                  │
│  ✓ Saisonkalender                  ✓ Alles aus Free             │
│  ✓ Alle Rezepte (kuratiert)                                     │
│  ✓ Eigene Rezepte erstellen        ✨ Premium AI Onboarding     │
│  ✓ Favoriten (Sync)                ✨ AI Wochenplaner           │
│  ✓ User Profile (Basis)            ✨ AI Rezept-Generator       │
│  ✓ Bring! Verbindung               ✨ 10 AI-Bilder / Monat      │
│  ✓ Manueller Wochenplan            ✨ Smart Einkaufsaggregation │
│  ✓ Einzelne Rezepte -> Bring!      ✨ Implizites Lernen         │
│                                                                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│                               💎 PRO                             │
│                               CHF 12.90 / Monat                  │
│                               (CHF 119.– / Jahr)                 │
│                               ─────────────────────────         │
│                                                                  │
│                               ✓ Alles aus Premium               │
│                                                                  │
│                               ✨ Unbegrenzte AI-Bilder (4K)     │
│                               ✨ Familien-Profile (bis 5)       │
│                               ✨ Geteilte Wochenpläne           │
│                               ✨ Ernährungs-Insights            │
│                               ✨ Priority Support               │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 8.2 API-Kosten Kalkulation

| Feature | Premium (~10 req/mo) | Pro (~25 req/mo) |
|---------|----------------------|------------------|
| Text AI (Plans, Recipes) | ~$0.05 | ~$0.12 |
| Image AI (10x 2K vs 25x 4K) | ~$1.34 | ~$4.80 |
| **Total API** | **~$1.39** | **~$4.92** |

**Marge bei Premium (CHF 5.90 / ~$6.60):**
- API: -$1.39
- Store Fee (30%): -$1.98
- RevenueCat (~1%): -$0.07
- **Netto: ~$3.16 (48%)**

---

## 9. Implementierungs-Roadmap

### Phase 13: Einkaufslisten-Export
**Status:** Geplant

- [ ] Zutaten aus Wochenplan aggregieren
- [ ] Mengen intelligent addieren
- [ ] Batch-Export zu Bring!

### Phase 14: AI Rezept-Generator
**Status:** Geplant
**Prerequisite:** Premium Onboarding

- [ ] ai_profiles Collection & Repository
- [ ] Premium Onboarding Flow
- [ ] AI FAB Component
- [ ] Recipe Generation Modal
- [ ] PocketBase Hook für Gemini
- [ ] Rezept Review & Save Flow

### Phase 15: AI Wochenplaner
**Status:** Geplant
**Prerequisite:** Phase 14

- [ ] Weekplan AI Modal
- [ ] Context Builder Service
- [ ] Structured Output Parsing
- [ ] Direct-to-Plan Integration
- [ ] "Regenerate Day" Feature

### Phase 16: AI Bildgenerierung
**Status:** Geplant

- [ ] Image Generation Hook
- [ ] Quota Tracking
- [ ] Image Selection UI
- [ ] PocketBase File Storage

### Phase 17: Familien-Features (Pro)
**Status:** Geplant

- [ ] Multi-Profile Support
- [ ] Shared Weekplans
- [ ] Family Groups

### Phase 18: Monetarisierung
**Status:** Geplant

- [ ] RevenueCat Integration
- [ ] Paywall UI
- [ ] Entitlement Guards
- [ ] 7-Day Free Trial

---

## 10. Erfolgsmetriken

### Engagement

| Metrik | Ziel (6 Monate) |
|--------|-----------------|
| WAU (Weekly Active Users) | 5'000 |
| AI Requests / Premium User / Woche | 3 |
| Wochenpläne erstellt / Woche | 1.5 |
| Bring! Exports / Woche | 2 |

### Monetarisierung

| Metrik | Ziel (6 Monate) |
|--------|-----------------|
| Free -> Premium Conversion | 5% |
| Premium -> Pro Upsell | 15% |
| Monthly Churn | < 8% |
| ARPU | CHF 1.20 |

### AI Quality

| Metrik | Ziel |
|--------|------|
| AI Satisfaction (Thumbs up) | >= 80% |
| Recipe Save Rate | >= 60% |
| Plan Acceptance Rate | >= 70% |

---

*Dokument Version 3.0 - Dezember 2025*
*Nächste Review: Nach Phase 14 Implementation*
