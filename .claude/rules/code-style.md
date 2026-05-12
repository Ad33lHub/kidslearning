# Rule: Code Style

## Clean Code Standards

- Every function does one thing. If you need "and" to describe it, split it.
- Function body limit: 20 lines. Exceeding this is a refactor signal.
- Class limit: 200 lines for domain/data classes; 150 lines for widgets.
- No commented-out code. Delete it — git history exists.
- No `TODO` comments in committed code. File a task instead.
- Magic numbers and strings must be named constants.

## Naming

```dart
// Constants — SCREAMING_SNAKE for true constants
const double kDefaultPadding = 16.0;

// Private fields — leading underscore
final _controller = TextEditingController();

// Booleans — prefix with is/has/can/should
bool isLoading = false;
bool hasError = false;
bool canSubmit = true;

// Async methods — verb that implies waiting
Future<void> fetchQuestions() async { ... }
Future<UserEntity> loadUserProfile() async { ... }
```

## Documentation Rules

- Public API (exported classes and their public methods) → requires a one-line doc comment.
- Internal implementation details → no comment needed; write self-documenting code.
- Complex algorithm or non-obvious invariant → one short inline comment explaining WHY.
- Never write "// do X" — the code already shows what; explain why it's done this way.

```dart
// Good: explains the non-obvious constraint
// TTS pitch above 1.5 for child-friendly high-pitched audio.
await flutterTts.setPitch(2.0);

// Bad: restates the code
// Set pitch to 2.0
await flutterTts.setPitch(2.0);
```

## Formatting

- `dart format` is enforced via post-write hook. Do not manually align code.
- Max line length: 80 characters (Flutter/Dart default).
- Trailing commas on all multi-line parameter lists — enables better formatting.

```dart
// Good — trailing comma forces each param to its own line
Container(
  width: 100,
  height: 100,
  color: Colors.red,  // <-- trailing comma
)

// Bad — no trailing comma collapses formatting
Container(width: 100, height: 100, color: Colors.red)
```

## Import Ordering

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:io';

// 2. Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. Third-party packages
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio/dio.dart';

// 4. Project imports — use package: form, not relative
import 'package:kids/core/theme/app_theme.dart';
import 'package:kids/features/quiz/domain/entities/question_entity.dart';
```

## Error Handling

- Never swallow exceptions with empty `catch {}` blocks.
- Never use generic `catch (e)` without at least logging `e.toString()`.
- Propagate errors as typed `Failure` objects from data layer upward.
- UI must always show a user-friendly error state — never a raw exception message.

```dart
// Bad
try {
  await doSomething();
} catch (e) {} // silent failure

// Good
try {
  await doSomething();
} on ServerException catch (e) {
  return Left(ServerFailure(message: e.message));
} catch (e, stack) {
  log('Unexpected error', error: e, stackTrace: stack);
  return const Left(UnknownFailure());
}
```

## Scalability Standards

- Never put feature-specific logic in `main.dart`.
- Never share mutable state between features directly — use domain use cases.
- Feature folders must be independently compilable (no cross-feature imports at data/domain level).
- Shared utilities go in `lib/core/`, not in any feature folder.
