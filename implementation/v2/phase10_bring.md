# Phase 10: Bring! Integration

**Status:** Done
**Ziel:** Verbindung mit der beliebten Einkaufslisten-App "Bring!" für nahtloses Einkaufen.

> [!WARNING]
> **Unofficial API:** Bring! bietet keine öffentliche API an. Diese Integration basiert auf Reverse-Engineering und kann jederzeit brechen.

## 1. Implementierte Features

### 1.1 API Client (`BringApiClient`)
- **Auth Endpoint:** `POST https://api.getbring.com/rest/v2/bringauth`
- **Lists Endpoint:** `GET https://api.getbring.com/rest/bringusers/{uuid}/lists`
- **Add Item:** `PUT https://api.getbring.com/rest/v2/bringlists/{listUuid}`

**Erforderliche Headers:**
```dart
static const _defaultHeaders = {
  'X-BRING-API-KEY': 'cof4Nc6D8saplXjE3h3HXqHH8m7VU2i1Gs0g85Sp',
  'X-BRING-CLIENT': 'android',
  'X-BRING-APPLICATION': 'bring',
  'X-BRING-COUNTRY': 'CH',
};
```

### 1.2 User Flow
1. Profil → Bring! Einkaufsliste → Login Dialog
2. Email/Passwort Eingabe (mit Hilfe für Social-Login User)
3. Auto-Auswahl der ersten Liste als Default
4. Credentials verschlüsselt in `flutter_secure_storage`

### 1.3 Rezept-Integration
- Button "Auf Einkaufsliste" auf Rezept-Detail-Seite
- Alle Zutaten werden einzeln an Bring! gesendet
- Format: `{item}` mit Specification `{amount} {unit}`

## 2. Architektur

```
lib/features/shopping_list/
├── data/
│   └── bring_api_client.dart      # API Client mit Headers
├── application/
│   └── listing_service.dart       # Business Logic + Secure Storage
└── presentation/
    ├── state/
    │   └── shopping_list_controller.dart
    └── widgets/ (in profile feature)
        └── bring_auth_dialog.dart  # Login UI mit Social-Login Hilfe
```

## 3. Social Login Workaround

User die sich bei Bring! mit Google/Apple/Facebook angemeldet haben, müssen zuerst ein Passwort setzen:
- **App:** Profil → Weitere Einstellungen → Passwort ändern
- **Web:** web.getbring.com → Einstellungen → Passwort

Der Login-Dialog enthält einen expandierbaren Hilfe-Bereich mit dieser Anleitung.

## 4. Acceptance Criteria

- [x] User kann sich einloggen und Listen laden
- [x] Zutaten können erfolgreich gesendet werden
- [x] Bei API-Fehlern stürzt die App nicht ab
- [x] User wird gewarnt, dass das Feature experimentell ist
- [x] Social-Login User erhalten Hilfe zum Passwort-Setup

## 5. Bekannte Limitierungen

- **Keine Batch-API:** Items werden sequentiell gesendet
- **Keine Listen-Auswahl UI:** Erste Liste wird automatisch verwendet
- **Token-Refresh:** Nicht implementiert (Token läuft nach ~7 Tagen ab)
