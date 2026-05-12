# Rule: Flutter Standards

## Widget Structure Rules

- Every screen is a `ConsumerWidget` (Riverpod) or `BlocBuilder` consumer — never a raw `StatefulWidget` for business state.
- Use `StatefulWidget` only for purely local UI state (animation controllers, focus nodes, scroll controllers).
- Extract any widget that exceeds 50 lines into its own class.
- All reusable widgets live in `lib/core/widgets/` or `lib/features/<feature>/presentation/widgets/`.
- Widget constructors use named parameters with `required` where non-nullable.

```dart
// Good widget structure
class QuestionCard extends StatelessWidget {
  final String imageAsset;
  final String questionText;
  final VoidCallback onTap;

  const QuestionCard({
    super.key,
    required this.imageAsset,
    required this.questionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => ...;
}
```

## Screen Organization

Every screen file follows this structure:

```dart
// 1. Imports
// 2. Screen widget class (thin — delegates to sub-widgets)
// 3. Private body widget (main layout)
// 4. Any screen-specific widgets not worth extracting to a separate file
```

Screen files must not exceed 150 lines. If they do, extract sub-widgets.

## State Management Guidance

- Never call `setState()` for data fetched from a repository.
- Loading, data, and error states must be modeled explicitly — not with `bool isLoading`.
- `initState` must not call async methods directly — use `Future.microtask` or post-frame callback.

```dart
// Bad
@override
void initState() {
  super.initState();
  loadData(); // async call in initState
}

// Good
@override
void initState() {
  super.initState();
  Future.microtask(() => ref.read(contentProvider.notifier).load());
}
```

## Performance Optimization

- Mark every widget `const` where possible — it skips the rebuild entirely.
- Use `ListView.builder` / `GridView.builder` for all lists, never `Column` with `.map()`.
- Avoid rebuilding the entire screen — use `Consumer` / `Selector` to scope rebuilds.
- Use `RepaintBoundary` around complex animated widgets.
- Cache decoded images with `cached_network_image`.
- Never call `MediaQuery.of(context)` deep inside a widget tree — read it at screen level and pass values down.

```dart
// Bad — whole screen rebuilds when MediaQuery changes
Widget build(BuildContext context) {
  return SomeDeepWidget(
    width: MediaQuery.of(context).size.width * 0.5, // deep call
  );
}

// Good — read at top, pass down
@override
Widget build(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  return SomeDeepWidget(width: screenWidth * 0.5);
}
```

## Navigation Rules

- All routes are defined centrally in `lib/core/router/app_router.dart`.
- Use named routes or `go_router` — never inline `MaterialPageRoute` in screen files.
- Pass only primitive types or entity IDs through route arguments — not full objects.
- Back navigation uses `context.pop()` (go_router) or `Navigator.of(context).pop()` — never Android back button assumptions.

```dart
// Bad — inline route in screen
Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen()));

// Good — named route
context.goNamed(AppRoutes.detail, pathParameters: {'id': contentId});
```

## Async Handling Standards

- Always show a loading indicator during async operations.
- Always show an error widget on failure — never silent failures.
- `FutureBuilder` is acceptable for one-off async, but prefer state notifiers for reactive data.
- Use `StreamBuilder` only for real-time streams (Firebase, sensors).

## Theme Management

- All colors defined in `AppColors` (`lib/core/theme/app_colors.dart`).
- All text styles defined in `AppTextStyles` (`lib/core/theme/app_text_styles.dart`).
- Custom font `arlrdbd` used via `fontFamily: AppTextStyles.fontFamily`.
- `ThemeData` constructed in `AppTheme.light()` and applied at `MaterialApp` level only.
- Never override theme inline with hardcoded values — add a named style instead.

```dart
// Bad
Text('Hello', style: TextStyle(fontSize: 24, color: Color(0xFFF19335)))

// Good
Text('Hello', style: AppTextStyles.heading1)
// or
Text('Hello', style: Theme.of(context).textTheme.headlineMedium)
```

## Responsiveness Rules

- Use `LayoutBuilder` or `responsive_framework` breakpoints for layout decisions.
- Avoid fixed pixel widths/heights for layout containers — use `MediaQuery` fractions or `Flexible`/`Expanded`.
- Minimum tap target: 48×48 dp (use `SizedBox` or `Padding` to enforce on small icons).
- Test on: small phone (360dp), standard phone (390dp), tablet (768dp).

```dart
// Good responsive grid
LayoutBuilder(
  builder: (context, constraints) {
    final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
      ),
      ...
    );
  },
)
```

## Build Optimization

- Run `flutter build apk --release --obfuscate --split-debug-info=./debug-info/` for release.
- Enable `--split-per-abi` for Android to reduce APK size.
- Use `flutter pub run flutter_launcher_icons` for icon generation.
- Enable R8/ProGuard shrinking in `android/app/build.gradle`.
- Remove unused assets from `pubspec.yaml` before release builds.
