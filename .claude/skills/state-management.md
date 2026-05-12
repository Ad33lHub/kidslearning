# Skill: state-management

## Purpose

Reference and scaffolding guide for state management patterns in this Flutter app.
Invoke with: `/state-management <pattern> <feature-name>`

## Approved Patterns

| Pattern | Use Case |
|---------|----------|
| `riverpod` | New features — preferred for this project |
| `bloc` | Complex event-driven flows (quiz engine, auth) |
| `provider` | Simple inherited state (theme, locale) |

Do not mix patterns within a single feature.

## Riverpod Pattern (Preferred)

### State Definition
```dart
// lib/features/quiz/presentation/state/quiz_state.dart
@freezed
class QuizState with _$QuizState {
  const factory QuizState.initial() = _Initial;
  const factory QuizState.loading() = _Loading;
  const factory QuizState.loaded(List<QuestionEntity> questions, int currentIndex, int score) = _Loaded;
  const factory QuizState.error(String message) = _Error;
}
```

### Notifier
```dart
// lib/features/quiz/presentation/providers/quiz_notifier.dart
@riverpod
class QuizNotifier extends _$QuizNotifier {
  @override
  QuizState build() => const QuizState.initial();

  Future<void> loadQuestions(ContentType type) async {
    state = const QuizState.loading();
    final result = await sl<GetQuestionList>()(QuestionParams(type: type));
    state = result.fold(
      (failure) => QuizState.error(failure.message),
      (questions) => QuizState.loaded(questions, 0, 0),
    );
  }

  void submitAnswer(String answerId) {
    state.whenOrNull(
      loaded: (questions, index, score) {
        final isCorrect = questions[index].correctAnswerId == answerId;
        state = QuizState.loaded(
          questions,
          index + 1,
          isCorrect ? score + 1 : score,
        );
      },
    );
  }
}
```

### Screen Consumption
```dart
class QuizScreen extends ConsumerWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quizNotifierProvider);

    return state.when(
      initial: () => const SizedBox.shrink(),
      loading: () => const LoadingWidget(),
      loaded: (questions, index, score) => QuizContentWidget(
        question: questions[index],
        score: score,
        onAnswer: (id) => ref.read(quizNotifierProvider.notifier).submitAnswer(id),
      ),
      error: (msg) => ErrorWidget(message: msg),
    );
  }
}
```

## BLoC Pattern (Complex Flows)

```dart
// Events
abstract class AuthEvent {}
class SignInRequested extends AuthEvent {
  final String email, password;
  SignInRequested(this.email, this.password);
}
class SignOutRequested extends AuthEvent {}

// States
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState { final UserEntity user; AuthAuthenticated(this.user); }
class AuthUnauthenticated extends AuthState {}
class AuthError extends AuthState { final String message; AuthError(this.message); }

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn signIn;
  final SignOut signOut;

  AuthBloc({required this.signIn, required this.signOut}) : super(AuthInitial()) {
    on<SignInRequested>(_onSignIn);
    on<SignOutRequested>(_onSignOut);
  }

  Future<void> _onSignIn(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signIn(SignInParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
}
```

## Rules

1. State classes are immutable — use `freezed` or `const` constructors.
2. Never store `BuildContext` in a notifier, bloc, or provider.
3. Async operations must emit/transition to a loading state before the await.
4. Error states must carry a human-readable message string.
5. Providers/blocs are registered in DI (`injection_container.dart`), not constructed inline.
6. Never call `setState()` when a state management solution is in use for that widget.
