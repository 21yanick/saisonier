# Phase 17: Family Features (Pro)

**Status:** Geplant
**Ziel:** Kollaborative Features für Haushalte.

## 1. Scope & Features

### 1.1 Household Management
- User kann einen "Haushalt" erstellen.
- Invite-Flow (Link oder Email).

### 1.2 Data Sharing
- Gemeinsamer Zugriff auf:
  - `week_plans`
  - `shopping_lists` (wenn intern implementiert)
  - `recipes` (Family Cookbook)

## 2. Technical Details

### 2.1 PocketBase Data Model
- Collection `households`: `id`, `name`, `owner_id`.
- Collection `household_members`: `household_id`, `user_id`, `role`.

### 2.2 Security Rules (API Rules)
- **Critical:** Row-Level Security muss in PocketBase konfiguriert werden.
- Rule Example (Pseudocode): `@request.auth.id != "" && @collection.household_members.user_id ?= @request.auth.id`
- Sicherstellen, dass User nur Daten ihres eigenen Haushalts sehen können.

## 3. UI/UX
- **Family Dashboard:** "Du, Anna und Tom".
- **Avatar Indicators:** Wer hat den Eintrag erstellt?

## 4. Acceptance Criteria
- [ ] PocketBase API Rules verhindern unberechtigten Zugriff.
- [ ] Änderungen werden near-realtime synchronisiert (PocketBase Realtime).
- [ ] Invite System funktioniert reibungslos.
