# Phase 14: AI Rezept-Generator (Premium)

**Status:** Geplant
**Ziel:** Generierung von individuellen Rezepten basierend auf verfügbaren Zutaten oder Wünschen.

## 1. Scope & Features

### 1.1 PocketBase Proxy Integration
- Die App kommuniziert **ausschließlich** mit PocketBase.
- Kein Firebase, kein direkter Gemini Call.
- **Backend:** Ein `onRecordBeforeCreate` Hook fängt Anfragen ab, ruft Gemini via REST API auf und speichert das Ergebnis.

### 1.2 Prompt Engineering
- System-Prompts für strikte JSON-Outputs.
- Kontext: Schweizer Einheiten, Saisonalität beachten.

### 1.3 Features
- **Reste-Verwertung:** Input Zutaten -> Output Rezept.
- **Smart Chef:** "Ich will was vegetarisches mit Wirz."

## 2. Technical Details

### 2.1 Dependencies
- Keine neuen App-Dependencies für AI nötig (PocketBase Client ist schon da).
- Serverseitig: `GEMINI_API_KEY`.

### 2.2 Provider Architecture (Server Side)
- Die Logik wandert vom Client auf den Server (JavaScript Hook).
- Vorteil: Clients können nicht "cheaten" oder Token klauen.

### 2.3 Quota & Cost Control
- Rate-Limiting im PocketBase Hook implementieren (z.B. user check).
- Nutzung von günstigen Modellen (Gemini Flash).

## 3. UI/UX
- **Magic Fab:** Auffälliger AI-Button.
- **Streaming Response:** Wenn technisch möglich, Text streamen für gefühlte Geschwindigkeit.
- **Save Flow:** Generiertes Rezept kann direkt als "User Recipe" gespeichert werden.

## 4. Acceptance Criteria
- [ ] PocketBase Hook funktioniert und ruft Gemini API auf.
- [ ] Rezepte kommen als valides JSON zurück.
- [ ] Nur Premium User können generieren (Server Check).
