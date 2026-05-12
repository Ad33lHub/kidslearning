# Agent: testing-agent

## Role

Owns the test suite. Writes, maintains, and audits unit, widget, and integration tests.
Enforces minimum coverage targets and CI-readiness.

## Responsibilities

- Write unit tests for all use cases, repositories, and data sources
- Write widget tests for all screens and reusable widgets
- Write integration tests for critical user flows
- Set up and maintain mock/fake infrastructure (`mockito`, `mocktail`, `fake_cloud_firestore`)
- Ensure all tests are runnable in CI without physical devices
- Audit existing tests for correctness, not just coverage

## Test Structure

```
test/
├── unit/
│   ├── features/
│   │   └── <feature>/
│   │       ├── domain/
│   │       │   └── usecases/
│   │       └── data/
│   │           ├── datasources/
│   │           └── repositories/
│   └── core/
│       └── utils/
├── widget/
│   └── features/
│       └── <feature>/
│           ├── screens/
│           └── widgets/
integration_test/
└── flows/
    ├── onboarding_flow_test.dart
    ├── quiz_flow_test.dart
    └── learning_flow_test.dart
```

## Unit Test Standards

```dart
// Use group + test, not just test at top level
group('GetContentListUseCase', () {
  late MockContentRepository mockRepo;
  late GetContentListUseCase useCase;

  setUp(() {
    mockRepo = MockContentRepository();
    useCase = GetContentListUseCase(mockRepo);
  });

  test('returns content list on success', () async {
    when(() => mockRepo.getContentList())
        .thenAnswer((_) async => Right(tContentList));
    final result = await useCase(NoParams());
    expect(result, Right(tContentList));
    verify(() => mockRepo.getContentList()).called(1);
  });

  test('returns failure on repository error', () async {
    when(() => mockRepo.getContentList())
        .thenAnswer((_) async => Left(ServerFailure()));
    final result = await useCase(NoParams());
    expect(result, Left(ServerFailure()));
  });
});
```

## Widget Test Standards

```dart
testWidgets('QuizScreen shows question image', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [quizProvider.overrideWith((_) => FakeQuizNotifier())],
      child: const MaterialApp(home: QuizScreen()),
    ),
  );
  await tester.pump();
  expect(find.byType(Image), findsOneWidget);
  expect(find.text('Choose the correct answer'), findsOneWidget);
});
```

- Always wrap with `MaterialApp` and `ProviderScope`/`BlocProvider`.
- Use `tester.pump()` for synchronous state, `tester.pumpAndSettle()` for animations.
- Test loading state, error state, and data state separately.
- Use `Key` values on critical widgets to make finders reliable.

## Integration Test Standards

```dart
// integration_test/flows/quiz_flow_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('User completes alphabet quiz', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Look And Choose'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alphabet'));
    await tester.pumpAndSettle();
    expect(find.byType(QuizScreen), findsOneWidget);
  });
}
```

- Integration tests must use the Firebase Emulator Suite — never production Firebase.
- Run with: `flutter test integration_test/ --device-id <emulator-id>`

## Coverage Targets

| Layer | Minimum |
|-------|---------|
| Domain (use cases, entities) | 90% |
| Data (repositories, datasources) | 80% |
| Presentation (screens, widgets) | 60% |
| Core utilities | 85% |

Generate coverage report: `flutter test --coverage && genhtml coverage/lcov.info -o coverage/html`

## Mocking Rules

- Use `mocktail` for mocking (no code generation required).
- Use `fake_cloud_firestore` for Firestore, `firebase_auth_mocks` for Auth.
- Never mock `BuildContext` — use real widget test environment.
- Never call real HTTP endpoints in unit or widget tests — mock `Dio`/`http.Client`.
