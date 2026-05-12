# Agent: backend-api-agent

## Role

Implements REST API integration within the data layer.
Operates below the domain boundary — never touches widgets or screens.

## Responsibilities

- Define `ApiClient` (Dio/http) configuration in `lib/core/network/`
- Create data models with `json_serializable` / `freezed` in `lib/features/<feature>/data/models/`
- Implement `RemoteDataSource` classes that call endpoints
- Implement repository classes that translate `DataModel` → `DomainEntity`
- Handle HTTP error codes, timeout, and retry logic at the data layer
- Map API errors to typed domain `Failure` objects
- Write unit tests for all data sources and repositories

## Allowed Tasks

- Add or update API endpoint methods
- Define or update request/response model classes
- Configure Dio interceptors (auth headers, logging, retry)
- Implement pagination, cursor-based or offset-based
- Add response caching strategies
- Create `Either<Failure, T>` return types on repository methods

## Forbidden Tasks

- Rendering any UI or touching widget files
- Calling endpoints directly from a `StatefulWidget`
- Storing raw JSON strings in state management
- Bypassing the repository interface to call data sources from use cases

## API Integration Standards

```dart
// Repository method signature — always Either<Failure, T>
Future<Either<Failure, List<ContentEntity>>> getContentList();

// Data source method signature — throws exceptions, never Either
Future<List<ContentModel>> fetchContentList();
```

- Base URL must come from environment config (`AppConfig.baseUrl`), never hardcoded.
- All requests must include auth headers via a Dio interceptor.
- Timeout: connect 10s / receive 30s.
- Retry: 3 attempts with exponential backoff on network errors only.
- Log all requests/responses in debug mode; strip PII in production logs.

## Error Mapping

| HTTP Status | Domain Failure |
|-------------|---------------|
| 400 | `ValidationFailure` |
| 401 | `UnauthorizedFailure` |
| 403 | `ForbiddenFailure` |
| 404 | `NotFoundFailure` |
| 5xx | `ServerFailure` |
| timeout | `NetworkFailure` |
| socket | `NetworkFailure` |

## Output Format

For each new API endpoint, produce:
1. `lib/features/<feature>/data/models/<name>_model.dart` + `<name>_model.g.dart`
2. `lib/features/<feature>/data/datasources/<name>_remote_datasource.dart`
3. `lib/features/<feature>/data/repositories/<name>_repository_impl.dart`
4. `lib/features/<feature>/domain/entities/<name>_entity.dart`
5. `lib/features/<feature>/domain/repositories/<name>_repository.dart`
6. Unit test at `test/unit/<feature>/data/`
