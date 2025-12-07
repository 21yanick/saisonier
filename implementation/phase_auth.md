# Phase 7: User Authentication & Cloud Sync

**Status:** Executed (Done)
**Focus:** User Accounts, Favorites Sync, Privacy
**Source:** PRD Phase 2 (User Engagement)

## 1. Goals
- Implement User Login/Signup with Pocketbase (Email/Password).
- Implement **Bidirectional Sync** for Favorites (Local <-> Cloud).
- Maintain "Guest Mode" as default (Privacy by Design).

## 2. Architecture & Logic

### 2.1 Auth State Management
- **Persistence:** Required. The default `PocketBase` client does NOT auto-persist.
- **Solution:** Use `AsyncAuthStore` with `shared_preferences`.
  ```dart
  final prefs = await SharedPreferences.getInstance();
  final store = AsyncAuthStore(
    save: (String data) async => prefs.setString('pb_auth', data),
    initial: prefs.getString('pb_auth'),
  );
  final pb = PocketBase('https://saisonier.pockethost.io', authStore: store);
  ```
- **Provider:** `authProvider` (Riverpod `Notifier<User?>`).
  - Init: Check `pb.authStore.model`.
  - Stream/Listen: `pb.authStore.onChange`.

### 2.2 Data Synchronization Strategy (The "Merge")
Challenge: User uses app as Guest, marks items A and B. Then logs in. Account already has item C as favorite.
**Solution: Union Merge.**
1.  **On Login Success:**
    - Fetch Remote Favorites: `[C]`
    - Fetch Local Favorites: `[A, B]`
    - **Merge:** `[A, B, C]`
    - **Action 1:** Update Remote `users.favorites` with `[A, B, C]`.
    - **Action 2:** Update Local DB (Drift) setting `isFavorite = true` for C.
    - **Result:** Consistent state on both ends.

2.  **On Toggle (While Logged In):**
    - **Optimistic UI:** Immediately update Local DB & State.
    - **Background:** Send API call to update Remote.
    - **Error Handling:** If API fails (Offline), queue isn't strictly necessary for MVP if we rely on "Sync on Start" logic, but ideally we retain a "dirty" flag locally.
    - *Decision for MVP:* Simple "Fire and Forget" when online. Reliability relies on the "Sync on Start" which runs every time the app opens.

3.  **On Logout:**
    - **Action:** Clear Local Favorites?
    - **Decision:** To protect privacy on shared devices, **Clear Local Favorites** (set all `isFavorite = false` provided they are synced) OR ask user.
    - *KISS approach:* Clear local favorites on logout to avoid data leaks. Guest mode starts fresh.

## 3. Implementation Checklist

### 3.1 Backend (Pocketbase)
- [ ] Verify `users` collection schema:
  - `favorites`: Relation -> `recipes` (Wait, PRD v1.0 Line 134 says `recipes`. **Correction:** Should be `vegetables` or handled via a separate collection if we favorite vegetables. The MVP implemented favorites for *Vegetables* (Line 213).
  - *Correction:* Update Schema to allow `favorites` to point to `vegetables` (or just store IDs if Relation is too strict, but Relation is better).
  - *Action:* Ensure `users` collection has `favorites` field pointing to `vegetables`.

### 3.2 Domain Layer
- [x] **Dependencies:** Add `shared_preferences`.
- [x] Create `AuthRepository`.
  - `login(email, password)`
  - `register(email, password)`
  - `logout()`
  - `syncFavorites()`
- [x] **AuthStore:** Update `VegetableRepository` (or core PB provider) to use `AsyncAuthStore`.

### 3.3 Application Layer (Logic)
- [x] **Sync Service:** Create `AuthSyncService` class/provider.
  - Listens to `currentUserProvider`.
  - On login: Fetches remote favorites, merges with local, updates both.
- [x] **Refinements (UX Polish):**
  - **Sync-on-Write:** Toggling favorite updates remote immediately (Fire & Forget).
  - **Sync-on-Start:** App setup listens to `currentUser` restore and triggers merge sync.

### 3.4 Presentation Layer (UI)
- [x] **Providers:** Create `currentUserProvider` and `AuthController`.
- [x] **Settings/Profile Page:**
  - New route: `/profile`.
  - Accessible via a specialized icon in the App Bar or a "Settings" gear in the Grid View.
- [x] **Login Form:**
  - Clean, minimal UI.
  - "Continue as Guest" option (implicit).
- [x] **Login Form:**
  - Clean, minimal UI.
  - "Continue as Guest" option (implicit).
- [ ] **User Feedback:**
  - SnackBar on successful sync.

## 4. Verification Plan
- [x] **Scenario 1: Guest to User**
  - Mark "Wirz" as favorite (Guest).
  - Create Account.
  - Check Pocketbase Admin: "Wirz" is now in user's favorites.
- [x] **Scenario 2: Device Sync**
  - Login on Device A. Favorite "Rüebli".
  - Login on Device B. "Rüebli" should appear as favorite automatically.
- [x] **Scenario 3: Logout**
  - Logout. All hearts disappear (or revert to empty guest state).
- [x] **Compilation:** Fixed `Ref` import error in `auth_controller.dart`.
