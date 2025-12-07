# Phase 9: Profile+ (Erweitertes User Profile)

**Status:** Completed
**Ziel:** Personalisierung aller Empfehlungen und AI-Outputs durch ein detailliertes User-Profil.

## 1. Scope & Features

### 1.1 Erweitertes Datenmodell
- Erweiterung der `users` Collection in PocketBase oder einer separaten `profiles` Collection.
- Speicherung von Haushaltsdaten, Ernährungsvorlieben und Kochskills.

### 1.2 Onboarding Flow
- Neuer "Setup Wizard" nach dem Sign-Up (oder beim ersten Start der Phase-Features).
- Abfrage von:
  - Haushalt (Größe, Kinder + Alter)
  - Ernährung (Allergien, Diätform, Dislikes)
  - Kochen (Skill-Level, Max. Zeit)

### 1.3 Settings Screen
- Neuer Bereich in den Einstellungen zum nachträglichen Bearbeiten aller Profil-Daten.

## 2. Technical Details

### 2.1 Domain Model (Draft)

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
    required List<Allergen> allergens, // Enum: gluten, lactose, etc.
    required DietType diet,           // Enum: omnivore, vegan, etc.
    List<String>? dislikes,
    
    // Kochen
    required CookingSkill skill,      // Enum: beginner, intermediate...
    required int maxCookingTimeMin,
    
    // Externe Dienste
    String? bringEmail,
    String? bringListUuid,
  }) = _UserProfile;
}
```

### 2.2 PocketBase Schema
- **Collection:** `user_profiles` (oder Felder direkt in `users` wenn möglich/sinnvoll).
- **Security:** Owner only read/write.

## 3. UI/UX
- **Wizard:** Step-by-Step, visuell ansprechend (Icons für Diät, Slider für Zeit).
- **Settings:** Übersichtliche "Card"-Darstellung der Sektionen.

## 4. Acceptance Criteria
- [x] User kann Profil-Daten eingeben und speichern.
- [x] Daten werden korrekt in PocketBase persistiert.
- [x] User kann Daten jederzeit ändern.
- [x] Daten werden lokal gecacht (Offline availability).

