# Claude Project Instructions — Flutter Kids Learning App

## Project Overview

Preschool kids learning Flutter app (Android + iOS + Windows).
Four learning modes: Let's Start Learning, Video Learning, Look & Choose (Quiz), Listen & Guess.
Ten content categories: Alphabet, Numbers, Colors, Shapes, Animals, Birds, Flowers, Fruits, Months, Vegetables.

## Architecture

> **Reality check (2026-05):** The codebase currently uses a flat layout (`lib/Learning/`, `lib/Quiz/`, `lib/Pages/`, `lib/utils/`, etc.), not the clean-architecture / `lib/features/` layout described below. The clean-architecture rules in `.claude/rules/architecture/*` are **aspirational** — they apply to **new code**, not the existing screens. Don't rename or relocate the existing files in bulk; do new features under `lib/core/` (shared) and `lib/features/<feature>/` (feature modules).

Target architecture for new code, four layers:
- **presentation** — screens, widgets, state management (BLoC/Provider/Riverpod)
- **domain** — entities, use cases, repository interfaces
- **data** — repository implementations, data sources, models
- **core** — constants, theme, routing, utilities, shared widgets, **local DB (`lib/core/db/`)**

Feature-first folder organization under `lib/features/`. Each feature owns all four layers.

## Local Persistence (SQLite)

The app uses **sqflite** for local persistence. Single database initialized in `main()`:

| File | Purpose |
|------|---------|
| `lib/core/db/app_database.dart` | Opens `kids_app.db`. Auto-selects sqflite (mobile) vs `sqflite_common_ffi` (Windows/Linux/macOS/tests). Exposes `AppDatabase.instance.database` and `openInMemory()` for tests. |
| `lib/core/db/favorites_repository.dart` | CRUD over `favorites(category, item_key, added_at)` — unique on `(category, item_key)`. |
| `lib/core/db/quiz_scores_repository.dart` | Append-only `quiz_scores(category, score, total, completed_at)`; reads latest / best / history. |

### Conventions

- Schema changes go through `AppDatabase._onCreate` + a bumped `_dbVersion` + an `onUpgrade` migration. Never mutate columns in place once shipped.
- Repositories take a `Database` via constructor — they don't reach for the singleton. This keeps them trivially unit-testable against `AppDatabase.instance.openInMemory()` (see `test/unit/`).
- Heavy reads/writes should go through repositories, not raw SQL in widgets.
- No ORM. Stay on `sqflite`'s `query`/`insert`/`rawQuery` — adding a code-gen layer for ten rows of data is not worth it.

## Active Rules

@.claude/rules/dart.md
@.claude/rules/flutter.md
@.claude/rules/code-style.md
@.claude/rules/architecture/clean-architecture.md
@.claude/rules/architecture/folder-structure.md
@.claude/rules/architecture/naming-conventions.md

## Key Commands

```bash
flutter pub get                        # Install dependencies
flutter run                            # Run on connected device
flutter build apk --release            # Android release build
flutter build ios --release            # iOS release build
flutter test                           # All tests
flutter test test/unit/                # Unit tests only
flutter test test/widget/              # Widget tests only
flutter analyze                        # Static analysis
dart format lib/ test/                 # Format all Dart files
flutter pub run build_runner build     # Generate code (freezed, json_serializable)
flutter pub run build_runner watch     # Watch mode for codegen
```

## Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | Entry point, SQLite + AdMob init, orientation lock |
| `lib/bottomnavigation.dart` | Root scaffold with 3-tab bottom nav (Setting / Home / Privacy) |
| `lib/homeScreen.dart` | Home grid; launches the four learning modes |
| `lib/core/db/app_database.dart` | SQLite singleton — mobile (sqflite) + desktop/test (ffi) |
| `lib/core/db/favorites_repository.dart` | Favorites read/write |
| `lib/core/db/quiz_scores_repository.dart` | Persisted quiz score history |
| `lib/utils/model.dart` | Content image path constants + list builders |
| `lib/utils/app_constrant.dart` | AdMob IDs — currently Google **test** IDs |
| `lib/utils/ad_helper.dart` | Platform-aware ad-unit ID getter; returns `null` on unsupported platforms (Windows/test) so the UI doesn't crash |
| `lib/utils/admob.dart` | Banner + interstitial ad lifecycle manager |

## Critical Constraints

- App is locked to portrait orientation — never change `SystemChrome.setPreferredOrientations`.
- Custom font `arlrdbd` is required on all user-visible `Text` widgets.
- All content images live in `assets/images/` — add new assets to `pubspec.yaml`.
- AdMob IDs in `app_constrant.dart` are **Google test IDs** — swap before Play Store submission.
- `flutter_tts` pitch is set to `10.0` — intentionally high for child-friendly audio.
- Several filenames have intentional typos (`Brids`, `Vegitable`, `Quize`) — preserve these to avoid broken imports.
- `AdHelper.*AdUnitId` getters return `String?`. When `null` (desktop, tests) ad loading must be a no-op — never throw. Don't reintroduce the old `UnsupportedError`-on-Windows behavior; it crashed widget tests that mount `HomeScreen`.
- `flutter test` runs on Windows host via `sqflite_common_ffi` — `AppDatabase` already handles this. Don't add platform guards in tests.

## State Management

Use `provider` or `riverpod` for new features. Do not add business logic inside `StatefulWidget.build()`.

## Testing Requirements

- Unit tests → `test/unit/` (currently: `favorites_repository_test.dart`, `quiz_scores_repository_test.dart`)
- Widget tests → `test/widget/` (top-level smoke test lives at `test/widget_test.dart`)
- Integration tests → `integration_test/`
- DB tests use `AppDatabase.instance.openInMemory()` — no real file is created. Each test should `await db.close()` in `tearDown`.
- Minimum coverage target: 70% on domain + data layers.

## AI Agent Collaboration

Specialized agents are defined in `.claude/agents/`. Invoke the appropriate agent for scoped tasks:
- UI changes → `flutter-ui-agent`
- API work → `backend-api-agent`
- Firebase → `firebase-agent`
- Tests → `testing-agent`
