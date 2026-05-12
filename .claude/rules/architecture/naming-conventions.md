# Rule: Naming Conventions

## Files

| Type | Pattern | Example |
|------|---------|---------|
| Screen | `<name>_screen.dart` | `quiz_screen.dart` |
| Widget (reusable) | `<name>_widget.dart` | `score_badge_widget.dart` |
| Card/Tile | `<name>_card.dart` | `content_card.dart` |
| Entity | `<name>_entity.dart` | `content_entity.dart` |
| Model | `<name>_model.dart` | `content_model.dart` |
| Use case | `<verb>_<noun>.dart` | `get_content_list.dart` |
| Repo interface | `<name>_repository.dart` | `content_repository.dart` |
| Repo impl | `<name>_repository_impl.dart` | `content_repository_impl.dart` |
| Remote DS | `<name>_remote_datasource.dart` | `content_remote_datasource.dart` |
| Local DS | `<name>_local_datasource.dart` | `content_local_datasource.dart` |
| State class | `<name>_state.dart` | `quiz_state.dart` |
| Provider/Notifier | `<name>_provider.dart` | `quiz_provider.dart` |
| BLoC | `<name>_bloc.dart` | `auth_bloc.dart` |
| Event | `<name>_event.dart` | `auth_event.dart` |
| Extension | `<type>_extensions.dart` | `string_extensions.dart` |
| Service | `<name>_service.dart` | `audio_service.dart` |
| Test | `<source_file>_test.dart` | `quiz_screen_test.dart` |

## Classes

```dart
// Screens — suffix Screen
class QuizScreen extends ConsumerWidget { }

// Widgets — suffix Widget, Card, Tile, Button, etc.
class ContentCard extends StatelessWidget { }
class ScoreBadgeWidget extends StatelessWidget { }

// Entities — suffix Entity
class ContentEntity extends Equatable { }

// Models — suffix Model
class ContentModel extends ContentEntity { }

// Use Cases — verb phrase, no suffix
class GetContentList { }
class SaveQuizResult { }
class DeleteUserProgress { }

// Repositories — suffix Repository
abstract class ContentRepository { }
class ContentRepositoryImpl implements ContentRepository { }

// Data Sources — suffix DataSource
abstract class ContentRemoteDataSource { }
class ContentRemoteDataSourceImpl implements ContentRemoteDataSource { }

// Notifiers — suffix Notifier
class QuizNotifier extends _$QuizNotifier { }

// BLoC — suffix Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> { }

// Events — suffix Event, verb past tense
class SignInRequested extends AuthEvent { }
class SignOutRequested extends AuthEvent { }

// States — suffix State + variant names as adjectives
abstract class AuthState { }
class AuthInitial extends AuthState { }
class AuthLoading extends AuthState { }
class AuthAuthenticated extends AuthState { }
class AuthError extends AuthState { }

// Services — suffix Service
class AudioService { }
class NotificationService { }

// Failures — suffix Failure
class ServerFailure extends Failure { }
class NetworkFailure extends Failure { }

// Exceptions — suffix Exception
class ServerException implements Exception { }
class CacheException implements Exception { }
```

## Variables and Parameters

```dart
// Lists — plural noun
final List<ContentEntity> contents = [];
final List<String> categoryIds = [];

// Maps — describe key→value relationship
final Map<String, ContentEntity> contentById = {};

// Streams — prefix with stream or suffix with Stream
final Stream<UserEntity?> authStateStream;
final streamController = StreamController<QuizEvent>();

// Booleans — prefix with is/has/can/should/was
bool isLoading = false;
bool hasError = false;
bool canProceed = true;
bool shouldRefresh = false;

// Callbacks — prefix with on
final VoidCallback onTap;
final ValueChanged<String> onAnswerSelected;

// Async futures — verb phrase
final Future<void> fetchOperation;

// Controllers — suffix Controller
final TextEditingController nameController;
final PageController pageController;
final AnimationController animationController;

// Keys — suffix Key
final GlobalKey<FormState> formKey;
final Key contentCardKey;
```

## Constants

```dart
// lib/core/utils/constants.dart
class AppConstants {
  static const int quizQuestionsPerPage = 1;
  static const int maxRetryAttempts = 3;
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const double defaultBorderRadius = 10.0;
}

class AppColors {
  static const Color primary = Color(0xFFF19335);
  static const Color background = Color(0xFFFEF7F0);
  static const Color correct = Color(0xFF6DB072);
  static const Color incorrect = Color(0xFFFF0000);
}
```

## Route Names

```dart
// lib/core/router/app_routes.dart
class AppRoutes {
  static const String home          = '/';
  static const String learning      = '/learning';
  static const String learningDetail = '/learning/:categoryId';
  static const String quiz          = '/quiz/:categoryId';
  static const String video         = '/video/:categoryId';
  static const String listenGuess   = '/listen-guess/:categoryId';
  static const String settings      = '/settings';
  static const String privacyPolicy = '/privacy-policy';
}
```

## Enums

```dart
// UpperCamelCase type, lowerCamelCase values
enum ContentType {
  alphabet,
  numbers,
  colors,
  shapes,
  animals,
  birds,
  flowers,
  fruits,
  months,
  vegetables,
}

enum QuizDifficulty { easy, medium, hard }

enum LoadingStatus { initial, loading, success, failure }
```
