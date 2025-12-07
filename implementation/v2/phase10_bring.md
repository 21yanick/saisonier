# Phase 10: Bring! Integration

**Status:** Geplant
**Ziel:** Verbindung mit der beliebten Einkaufslisten-App "Bring!" für nahtloses Einkaufen.

> [!WARNING]
> **Unofficial API:** Bring! bietet keine öffentliche API an. Diese Integration basiert auf Reverse-Engineering und kann jederzeit brechen. Robuste Fehlerbehandlung und Fallbacks sind essentiell.

## 1. Scope & Features

### 1.1 API Client Implementation (Hybrid Strategy)
- **Primary:** Unofficial REST API for full sync (Read & Write).
  - Auth: `https://api.getbring.com/rest/v2/bringauth`
  - Lists: `https://api.getbring.com/rest/bringusers/{uuid}/lists`
- **Fallback / Safe Mode:** Official "Web-to-App" Integration (Deep Linking).
  - URL Scheme: `bring:import?url={url}&source=web` (oder ähnlich, gemäss Guide).
  - Wenn API bricht, nutzt die App einfache Deep Links um Zutaten zu übergeben.

### 1.2 User Integration
- Eingabe der Bring! Credentials (Email/Passwort) in den Settings.
- Speicherung in `flutter_secure_storage`.
- Auswahl der Ziel-Liste (Default List).

### 1.3 Add-to-List Logic
- Button "Zutaten auf Einkaufsliste" auf der Rezept-Seite.
- Übertrag der Zutaten auf die gewählte Bring! Liste.

## 2. Technical Details

### 2.1 Dependencies
- `http`: Für API Calls.
- `flutter_secure_storage`: Für sichere Speicherung der Zugangsdaten.

### 2.2 Error Handling Strategy
- `BringApiException`: Eigene Exception-Klasse für API-Fehler (401 Unauthorized, 5xx Server Error).
- **Graceful Degradation:** Wenn Bring! nicht erreichbar ist, darf die App nicht crashen.

## 3. UI/UX
- **Login Screen:** Hinweis, dass dies eine experimentelle Funktion ist.
- **Feedback:** Success/Error Snackbars ("Gesendet", "Fehler bei Verbindung").

## 4. Acceptance Criteria
- [ ] User kann sich einloggen und Listen laden.
- [ ] Zutaten können erfolgreich gesendet werden.
- [ ] Bei API-Änderungen/Fehlern stürzt die App nicht ab.
- [ ] User wird gewarnt, dass das Feature experimentell ist.
