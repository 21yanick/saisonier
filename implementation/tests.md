# Test Strategy & Plan

## Overview
This document outlines the testing strategy to ensure a "clean code" basis for the Saisonier project. The focus is on **functionality first** (Logic > UI), ensuring the "Offline-First" and "Sync" mechanisms are robust.

## 1. Testing Architecture

### 1.1 Tech Stack
- **Framework:** `flutter_test`
- **Mocks:** `mockito` (Standard coverage)
- **Database:** `drift` (In-Memory `NativeDatabase.memory()` for speed/isolation)
- **DI:** `riverpod` (`ProviderContainer` for overriding dependencies)

### 1.2 Test Pyramid
- **Unit Tests (80%):** Focus on Repositories and Services.
- **Widget Tests (20%):** Focus on critical UI components (later).
- **Integration Tests (0%):** Manual verification covers this for MVP phases.

## 2. Test Scope (MVP Critical Path)

### 2.1 Low-Level: `VegetableRepository`
**Why:** It bridges the local SQL database and the UI.
**Scenarios:**
- [x] `watchAll`: Returns all items correctly sorted.
- [x] `watchSeasonal`: Correctly parses the `[1, 12, ...]` JSON/String format and filters by month.
- [x] `toggleFavorite`: Updates local DB and calls API (fire-and-forget).
- [x] `sync`: Correctly merges remote data into local DB, preserving local favorites.

### 2.2 Mid-Level: `AuthSyncService`
**Why:** This is the most complex logic (The "Union Merge").
**Scenarios:**
- [x] `syncOnLogin`:
    - Case A: Local user has items, Remote is empty -> Pushes to Remote.
    - Case B: Local empty, Remote has items -> Pulls to Local.
    - Case C: Both have items -> Merges unique set and updates both.

### 2.3 High-Level: `AuthRepository` & `AuthController`
**Why:** Ensures the user state flows correctly.
**Status:** Verified via Manual QA and Widget Tests (App Integration).


## 3. Implementation Plan

### Step 1: Setup
- Add `mockito` and `build_runner` to `dev_dependencies`.
- Create a reusable `createContainer` helper for Riverpod.

### Step 2: Mocks
- Generate mocks for:
    - `PocketBase` client
    - `RecordService` (for `collection()`)
    - `AuthService` (for `authStore`)

### Step 3: Implement Tests
1. `test/unit/repositories/vegetable_repository_test.dart`
2. `test/unit/services/auth_sync_service_test.dart`

## 4. Directory Structure
```text
test/
├── helpers/
│   ├── mocks.dart          # Generated mocks
│   └── provider_container.dart
├── unit/
│   ├── repositories/
│   │   └── vegetable_repository_test.dart
│   └── services/
│       └── auth_sync_service_test.dart
└── widget_test.dart        # Default
```
