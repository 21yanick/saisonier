# Phase 18: Monetarisierung (RevenueCat)

**Status:** Geplant
**Ziel:** Nachhaltige Finanzierung durch Subscriptions.

## 1. Scope & Features

### 1.1 RevenueCat Integration
- Zentrales Hub für In-App Käufe (iOS & Android).
- Mapping der Offerings (Free, Premium, Pro).

### 1.2 Subscription Lifecycle
- Kauf, Renewal, Cancellation, Expiration.
- **Restore Purchases:** Zwingend erforderlich für App Store Guidelines.

### 1.3 Entitlement Management
- **Client:** `SubscriptionService` prüft Status für UI-Updates.
- **Server (PocketBase):** Hooks prüfen `user.isPremium` (via Sync oder Webhook) bevor AI-Requests ausgeführt werden.
- **Double-Check:** Sicherheit auf Client UND Server.

## 2. Technical Details

### 2.1 Dependencies
- `purchases_flutter`
- `purchase_ui_flutter` (Optional für Paywalls).

### 2.2 Best Practices
- **Early Init:** `Purchases.configure` beim App Start.
- **Identify:** User ID (PocketBase ID) setzen für Cross-Platform Sync.
- **Error Handling:** `PurchasePendingError` beachten (Ask to Buy).

## 3. UI/UX
- **Paywall:** Klarer Nutzen-Vergleich. Trial-Angebot prominent.
- **Settings:** "Abo verwalten" Link (Führt zum Store).

## 4. Verification & Testing
- **Sandbox User:** Testen in iOS TestFlight / Google Play Internal Track.
- **Szenarien:**
  - Kauf erfolgreich -> Features da?
  - Abo läuft ab -> Features weg?
  - Restore auf neuem Device -> Features da?

## 5. Acceptance Criteria
- [ ] Sandbox Käufe funktionieren auf beiden Plattformen.
- [ ] Restore Button funktioniert.
- [ ] Features sind korrekt geschützt (Gatekeeper).
