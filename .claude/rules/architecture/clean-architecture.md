# Rule: Clean Architecture

## Layer Boundaries — Non-Negotiable

```
┌──────────────────────────────────────────┐
│           PRESENTATION LAYER              │
│  Screens · Widgets · Providers · BLoCs   │
│  Knows: domain entities & use cases      │
│  Does NOT know: data sources, models     │
├──────────────────────────────────────────┤
│              DOMAIN LAYER                 │
│  Entities · Use Cases · Repo Interfaces  │
│  Pure Dart — zero Flutter/Firebase deps  │
│  Direction of dependency: ← inward only  │
├──────────────────────────────────────────┤
│               DATA LAYER                  │
│  Models · DataSources · Repo Impls       │
│  Implements domain repo interfaces       │
│  Knows: HTTP clients, Firestore, Hive    │
└──────────────────────────────────────────┘
              ↓ depends on ↓
┌──────────────────────────────────────────┐
│               CORE / SHARED              │
│  DI · Router · Theme · Utils · Failures  │
└──────────────────────────────────────────┘
```

## Dependency Rule

> Source code dependencies must point inward. Outer layers depend on inner layers. Inner layers never import outer layers.

- `domain` imports: only `dart:core`, `dartz`, `equatable`
- `data` imports: `domain` + third-party SDKs (Dio, Firebase)
- `presentation` imports: `domain` use cases + state packages
- `core` imports: nothing from features

## Enforced Separations

### Presentation must NOT:
```dart
// VIOLATION — presentation calling data source directly
class QuizScreen extends StatelessWidget {
  final Dio dio = Dio(); // NO
  final firestore = FirebaseFirestore.instance; // NO
}
```

### Domain must NOT:
```dart
// VIOLATION — domain importing Flutter
import 'package:flutter/material.dart'; // NO in domain layer

// VIOLATION — domain importing data layer
import 'package:kids/features/quiz/data/models/question_model.dart'; // NO
```

### Data must NOT:
```dart
// VIOLATION — data importing presentation
import 'package:kids/features/quiz/presentation/screens/quiz_screen.dart'; // NO
```

## Repository Pattern

Every data access is behind an abstract interface defined in the domain layer:

```dart
// domain/repositories/content_repository.dart — interface
abstract class ContentRepository {
  Future<Either<Failure, List<ContentEntity>>> getContentList(ContentType type);
}

// data/repositories/content_repository_impl.dart — implementation
class ContentRepositoryImpl implements ContentRepository {
  @override
  Future<Either<Failure, List<ContentEntity>>> getContentList(ContentType type) async {
    // ...
  }
}
```

The presentation layer never knows which implementation is in use.

## Use Case Layer

Every business action is a dedicated use case class:

```dart
// One use case = one class = one method
class GetContentList implements UseCase<List<ContentEntity>, ContentTypeParams> {
  final ContentRepository repository;
  GetContentList(this.repository);

  @override
  Future<Either<Failure, List<ContentEntity>>> call(ContentTypeParams params) =>
      repository.getContentList(params.type);
}
```

Rules for use cases:
- One public method: `call()`, implementing `UseCase<ReturnType, Params>`.
- No UI logic, no direct SDK calls.
- Orchestrate multiple repository calls when needed.
- Return `Either<Failure, T>` — never throw.

## Failure Hierarchy

```dart
// lib/core/error/failures.dart
abstract class Failure extends Equatable {
  final String message;
  const Failure({this.message = 'An unexpected error occurred'});
  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error'});
}
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache read error'});
}
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}
```

## Service Layer

Business services that span multiple features live in `lib/core/services/`:

```
lib/core/services/
├── notification_service.dart    # FCM integration
├── analytics_service.dart       # Event tracking
├── audio_service.dart           # TTS + sound effects
└── storage_service.dart         # Local file I/O
```

Services are registered in DI as lazy singletons and injected into use cases or notifiers.

## SOLID Enforcement

| Principle | How Enforced |
|-----------|-------------|
| **S** ingle Responsibility | One use case per class; one responsibility per widget |
| **O** pen/Closed | Extend via new use cases, not modifying existing ones |
| **L** iskov Substitution | Repository impls must be drop-in substitutes for interfaces |
| **I** nterface Segregation | Split broad interfaces (e.g., separate read/write repos) |
| **D** ependency Inversion | All dependencies injected via constructor; no `GetIt.I.get()` in widgets |
