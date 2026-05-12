# Rule: Dart Language Standards

## Null Safety

- Null safety is mandatory. SDK constraint: `sdk: ">=3.0.0 <4.0.0"` for new projects.
- Never use `!` (bang operator) unless null is provably impossible at that point.
- Prefer `?.` and `??` over null checks with `if`.
- Use `late` only for fields initialized before first use and guaranteed non-null — document why.

```dart
// Bad — bang operator hides potential NPE
final name = user!.name;

// Good — safe navigation
final name = user?.name ?? 'Guest';

// Acceptable late — DI-injected, always set in setUp
late final UserRepository _repo;
```

## Class Organization

Order members consistently within every class:

```dart
class ExampleClass {
  // 1. Static constants and factories
  static const String tag = 'ExampleClass';

  // 2. Final instance fields
  final String id;
  final ContentType type;

  // 3. Late / mutable fields (minimize)
  late final SomeService _service;

  // 4. Constructor(s)
  const ExampleClass({required this.id, required this.type});

  // 5. Named constructors / factory constructors
  factory ExampleClass.fromJson(Map<String, dynamic> json) => ...;

  // 6. Overridden methods (toString, == , hashCode, copyWith)
  @override
  String toString() => 'ExampleClass(id: $id)';

  // 7. Public methods
  bool isValid() => id.isNotEmpty;

  // 8. Private methods
  void _initialize() { ... }
}
```

## Immutability

- Prefer `final` over `var` for all fields and local variables that are not reassigned.
- Use `const` constructors wherever possible.
- Use `@immutable` annotation on value objects and entities.
- Use `freezed` for sealed/union types and complex value objects.

```dart
@immutable
class Params extends Equatable {
  final String categoryId;
  const Params({required this.categoryId});
  @override
  List<Object> get props => [categoryId];
}
```

## Extension Methods

- Place extensions in `lib/core/extensions/` — one file per extended type.
- Name extension files `<type>_extensions.dart` (e.g., `string_extensions.dart`).
- Extensions must be pure (no side effects, no state mutation).

```dart
// lib/core/extensions/string_extensions.dart
extension StringX on String {
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  bool get isValidEmail =>
      RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
}
```

## Async/Await Standards

- Always `await` async calls — never fire-and-forget unless intentional and documented.
- Never use `.then()` chaining when `async/await` is available.
- Always handle errors on `async` methods — use try/catch or `Either`.
- Cancel `StreamSubscription` objects in `dispose()`.

```dart
// Bad
void loadData() {
  repository.getData().then((data) => setState(() => _data = data));
}

// Good
Future<void> loadData() async {
  try {
    final data = await repository.getData();
    setState(() => _data = data);
  } on Exception catch (e) {
    _handleError(e);
  }
}
```

## Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Classes | UpperCamelCase | `ContentRepository` |
| Files | snake_case | `content_repository.dart` |
| Variables/params | lowerCamelCase | `contentList` |
| Private fields | `_lowerCamelCase` | `_isLoading` |
| Constants | `lowerCamelCase` or `kName` | `kDefaultPadding` |
| Enums | UpperCamelCase | `ContentType.alphabet` |
| Type params | Single caps | `T`, `E`, `K`, `V` |

## Linting

`analysis_options.yaml` must include:
```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - always_declare_return_types
    - avoid_dynamic_calls
    - avoid_print             # use dart:developer log() instead
    - avoid_redundant_argument_values
    - cancel_subscriptions
    - close_sinks
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_fields
    - prefer_final_locals
    - require_trailing_commas
    - unnecessary_lambdas
    - use_super_parameters
```
