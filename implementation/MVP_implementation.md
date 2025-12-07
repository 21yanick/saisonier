# Saisonier - MVP Implementation Record

**Status:** Completed
**Date:** 2025-12-07
**Version:** 1.0.0

This document serves as the historical record of the MVP implementation (Phases 1-6).

## Phase 1: Foundation & Data Layer
**Status:** Done
**Focus:** Project Skeleton, Backend Sync, Drift (SQLite) Database

### Achievements
- **Project Setup:** Initialized Flutter project with Riverpod, GoRouter, Drift, and Freezed.
- **Backend:** Set up Pocketbase via Docker.
- **Data Layer:**
  - Implemented `Vegetable` and `Recipe` entities.
  - Built "Offline-First" Repository using `Drift` for local caching and `Pocketbase` for remote syncing.
  - Implemented `sync()` strategy: Fetch from PB -> Upsert to Drift.
- **Seeding:** Imported ~75 Swiss vegetables (`vegetables_switzerland.json`).

## Phase 2: Core UX & Navigation
**Status:** Done
**Focus:** Router, Theme, Adaptive Shell

### Achievements
- **Routing:** Implemented `StatefulShellRoute` with GoRouter to preserve scroll state between Feed and Grid tabs.
- **Theming:** Defined `AppTheme` using 'Outfit' font and custom seasonal colors.
- **Shell:** Created `MainScreen` with a custom floating toggle switch ("Pill") for navigation.

## Phase 3: Catalog Grid (Utility)
**Status:** Done
**Focus:** Slivers, Isar/Drift Queries, Performance

### Achievements
- **Grid UI:** High-performance `SliverGrid` displaying all items.
- **Filtering:** Real-time filtered queries via Drift/Isar logic.
- **Visuals:** Added `Hero` animations for seamless transitions to details.
- **Logic:** Implemented "Out of Season" visual dimming.

## Phase 4: Seasonal Feed (Inspiration)
**Status:** Done
**Focus:** Animations, Parallax, Haptics

### Achievements
- **Feed UI:** Vertical `PageView` ("TikTok style") for immersion.
- **Parallax:** Implemented custom `ParallaxImage` widget that moves images slower than scroll speed.
- **Logic:** Filters efficiently to show only current month's heroes (Tier 1 & 2).
- **Feel:** Added haptic feedback on page snaps.

## Phase 5: Detail View & Recipes
**Status:** Done
**Focus:** Detail Screens, Gyroscope, Wakelock

### Achievements
- **Detail Screen:** Rich view with season bar chart and recipe carousel.
- **Interactivity:**
  - **Gyroscope Cards:** Recipe cards tilt with device movement (3D effect).
  - **Wakelock:** Screen stays on when in "Cooking Mode".
- **Navigation:** Deep linking support (`/details/:id`).

## Phase 6: Polish & Verification
**Status:** Done
**Focus:** Favorites, Robustness, Linting

### Achievements
- **Favorites:** Implemented local persistence for favorites (Guest Mode).
- **Quality:** Codebase is free of lint errors (`flutter analyze` passing).
- **UX:** polished season bars and transitions.
- **Reliability:** Validated offline behavior and empty states.
