# Phase 9: Profile+ (Erweitertes User Profile)

**Status:** Completed
**Ziel:** Personalisierung aller Empfehlungen und AI-Outputs durch ein detailliertes User-Profil.

## 1. Scope & Features

### 1.1 Erweitertes Datenmodell
- Separate `user_profiles` Collection in PocketBase
- Speicherung von Haushaltsdaten, Ernährungsvorlieben und Kochskills
- **Dislikes** für personalisierte Feed-Filterung

### 1.2 Onboarding Flow
- "Setup Wizard" nach dem Sign-Up (3 Steps)
- Abfrage von:
  - Haushalt (Grösse, Kinder + Alter)
  - Ernährung (Allergien, Diätform)
  - Kochen (Skill-Level, Max. Zeit)
- Lädt bestehende Profildaten beim erneuten Öffnen

### 1.3 Settings Screen (BottomSheets)
- **Separate BottomSheets** für jeden Bereich (statt kompletter Wizard)
- Schnelle Bearbeitung einzelner Einstellungen
- Drei BottomSheets:
  - `HouseholdEditSheet` - Haushaltsgrösse, Kinder, Alter
  - `NutritionEditSheet` - Diet, Allergene, **Dislikes**
  - `CookingEditSheet` - Skill-Level, Max-Kochzeit

### 1.4 Feed-Integration
- **Dislikes werden im Saison-Feed ausgeblendet**
- `VegetableRepository.watchSeasonalFiltered()` berücksichtigt User-Dislikes
- Matching über Vegetable-Namen (case-insensitive)

## 2. Technical Details

### 2.1 Domain Model

```dart
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String userId,

    // Haushalt
    @Default(1) int householdSize,
    @Default(0) int childrenCount,
    List<int>? childrenAges,

    // Ernährung
    @Default([]) List<Allergen> allergens,
    @Default(DietType.omnivore) DietType diet,
    @Default([]) List<String> dislikes,  // NEU: Feed-Filterung

    // Kochen
    @Default(CookingSkill.beginner) CookingSkill skill,
    @Default(30) int maxCookingTimeMin,

    // Externe Dienste (Phase 10)
    String? bringEmail,
    String? bringListUuid,
  }) = _UserProfile;
}
```

### 2.2 PocketBase Schema
- **Collection:** `user_profiles`
- **Security:** Owner only read/write (`@request.auth.id = user_id.id`)

### 2.3 Enums

```dart
enum Allergen { gluten, lactose, nuts, eggs, soy, shellfish, fish }
enum DietType { omnivore, vegetarian, vegan, pescatarian, flexitarian }
enum CookingSkill { beginner, intermediate, advanced }
```

## 3. UI/UX

### 3.1 Onboarding Wizard
- 3 Steps mit Progress-Indicator
- Step 1: Haushalt (Sliders)
- Step 2: Ernährung (Chips)
- Step 3: Kochen (SegmentedButton + Slider)

### 3.2 Settings BottomSheets
- Öffnen per Tap auf ListTile
- Schliessen mit "Speichern" oder Swipe-Down
- Laden aktuelle Werte beim Öffnen
- Speichern nur geänderte Bereiche

### 3.3 Dislikes UI (NutritionEditSheet)
- TextField für neue Einträge
- Chips mit X zum Entfernen
- Rote Farbe für Dislikes-Chips
- Hinweistext zur Feed-Filterung

## 4. Dateien

```
lib/features/profile/
├── domain/
│   ├── models/user_profile.dart
│   └── enums/profile_enums.dart
├── data/
│   ├── dtos/user_profile_dto.dart
│   └── repositories/user_profile_repository.dart
└── presentation/
    ├── state/user_profile_controller.dart
    ├── screens/
    │   ├── profile_settings_screen.dart
    │   └── onboarding_wizard_screen.dart
    └── widgets/
        ├── household_edit_sheet.dart
        ├── nutrition_edit_sheet.dart
        ├── cooking_edit_sheet.dart
        └── bring_auth_dialog.dart
```

## 5. Acceptance Criteria

- [x] User kann Profil-Daten eingeben und speichern
- [x] Daten werden korrekt in PocketBase persistiert
- [x] User kann einzelne Bereiche separat bearbeiten (BottomSheets)
- [x] Bestehende Daten werden beim Bearbeiten geladen
- [x] **Dislikes können hinzugefügt und entfernt werden**
- [x] **Dislikes werden im Saison-Feed ausgeblendet**
- [x] Bring-Verbindung bleibt beim Profil-Update erhalten

