# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run the app
flutter run

# Build for Android
flutter build apk

# Build for iOS
flutter build ios

# Get dependencies
flutter pub get

# Run tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Analyze code
flutter analyze
```

## Architecture

This is a Flutter preschool kids learning app targeting Android, iOS, and Windows. The app is locked to portrait orientation and uses `responsive_framework` for multi-screen support.

### Navigation

- `lib/main.dart` — entry point; initializes SQLite, then mounts `BottomNav`
- `lib/bottomnavigation.dart` — 3-tab bottom nav: Settings (index 0), Home (index 1, default), Privacy Policy (index 2)
- `lib/homeScreen.dart` — home grid that launches the four learning modes

### Four Learning Modes

Each mode covers the same 10 categories: Alphabet, Numbers, Colors, Shapes, Animals, Birds, Flowers, Fruits, Months, Vegetables.

| Mode | Entry | Per-category screens |
|------|-------|----------------------|
| Let's Start Learning | `lib/Pages/LetsStartLearning.dart` | `lib/Learning/*.dart` — static image grids |
| Video Learning | `lib/Pages/VideoLearning.dart` | `lib/VideoLearning/*.dart` — YouTube thumbnails launched via `url_launcher` |
| Look And Choose (Quiz) | `lib/Pages/LookAndChooes.dart` | `lib/Quiz/*.dart` — multiple-choice quiz with `PageView`, scored with `motion_toast` |
| Listen And Guess | `lib/Pages/listen_and_guess.dart` | `lib/ListenGuessSongs/*.dart` — TTS pronunciation via `flutter_tts`, image identification |

Individual item detail/pronunciation screens live in `lib/Alphabetssound/`.

### Data Layer

`lib/utils/model.dart` is the single source of truth for all content: it exports image path constants (e.g., `A`, `B`, `Animal0`) and list-builder functions (e.g., `KidsList1()`, `alphabetvideo1()`) that return `List<Numbermodel>` used by every screen. All images are bundled under `assets/images/`.

### Custom Font

The app uses a single custom font `arlrdbd` (file: `assets/fonts/arlrdbd.ttf`) for all UI text. Specify it via `fontFamily: "arlrdbd"` in `TextStyle`.

### Known Naming Inconsistencies

Several files and classes have typos that are load-bearing (changing them requires updating all import sites):
- `Brids` / `Brid` (should be "Birds")
- `Vegitable` (should be "Vegetable")
- `Quize` suffix on some quiz files
- `responcive.dart` (should be "responsive")
