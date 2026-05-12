# Skill: api-integration

## Purpose

Step-by-step workflow for integrating a new REST API endpoint into the project.
Invoke with: `/api-integration <endpoint-description>`

## Step 1 — Define the Domain Contract

Add the method to the feature's repository interface:
```dart
// lib/features/<feature>/domain/repositories/<feature>_repository.dart
abstract class ContentRepository {
  Future<Either<Failure, List<ContentEntity>>> getContentByCategory(String categoryId);
}
```

## Step 2 — Define the Data Model

```dart
// lib/features/<feature>/data/models/content_model.dart
import 'package:json_annotation/json_annotation.dart';
part 'content_model.g.dart';

@JsonSerializable()
class ContentModel extends ContentEntity {
  const ContentModel({
    required super.id,
    required super.name,
    required super.imageUrl,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) =>
      _$ContentModelFromJson(json);
  Map<String, dynamic> toJson() => _$ContentModelToJson(this);
}
```

Run: `flutter pub run build_runner build --delete-conflicting-outputs`

## Step 3 — Implement the Remote Data Source

```dart
// lib/features/<feature>/data/datasources/content_remote_datasource.dart
abstract class ContentRemoteDataSource {
  Future<List<ContentModel>> fetchContentByCategory(String categoryId);
}

class ContentRemoteDataSourceImpl implements ContentRemoteDataSource {
  final Dio client;
  ContentRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ContentModel>> fetchContentByCategory(String categoryId) async {
    final response = await client.get(
      ApiEndpoints.contentByCategory,
      queryParameters: {'categoryId': categoryId},
    );
    if (response.statusCode == 200) {
      return (response.data['data'] as List)
          .map((e) => ContentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw ServerException(message: response.statusMessage ?? 'Server error');
  }
}
```

## Step 4 — Implement the Repository

```dart
// lib/features/<feature>/data/repositories/content_repository_impl.dart
@override
Future<Either<Failure, List<ContentEntity>>> getContentByCategory(
    String categoryId) async {
  try {
    final models = await remoteDataSource.fetchContentByCategory(categoryId);
    return Right(models);
  } on ServerException catch (e) {
    return Left(ServerFailure(message: e.message));
  } on DioException catch (e) {
    return Left(_mapDioError(e));
  }
}

Failure _mapDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
      return const NetworkFailure(message: 'Connection timed out');
    case DioExceptionType.badResponse:
      return ServerFailure(message: 'HTTP ${e.response?.statusCode}');
    default:
      return const NetworkFailure(message: 'No internet connection');
  }
}
```

## Step 5 — Create the Use Case

```dart
class GetContentByCategory implements UseCase<List<ContentEntity>, CategoryParams> {
  final ContentRepository repository;
  GetContentByCategory(this.repository);

  @override
  Future<Either<Failure, List<ContentEntity>>> call(CategoryParams params) =>
      repository.getContentByCategory(params.categoryId);
}
```

## Step 6 — Register in DI

```dart
// lib/core/di/injection_container.dart
sl.registerFactory(() => GetContentByCategory(sl()));
```

## Step 7 — Wire to State Notifier

```dart
Future<void> loadContent(String categoryId) async {
  state = const ContentState.loading();
  final result = await sl<GetContentByCategory>()(
    CategoryParams(categoryId: categoryId),
  );
  state = result.fold(
    (f) => ContentState.error(f.message),
    (list) => ContentState.loaded(list),
  );
}
```

## API Client Configuration

```dart
// lib/core/network/api_client.dart
Dio createDioClient(AppConfig config) {
  final dio = Dio(BaseOptions(
    baseUrl: config.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
  ));

  if (config.isDebug) dio.interceptors.add(LogInterceptor(responseBody: true));
  dio.interceptors.add(AuthInterceptor());
  dio.interceptors.add(RetryInterceptor(dio: dio, retries: 3));

  return dio;
}
```

## Endpoints Registry

```dart
// lib/core/network/api_endpoints.dart
class ApiEndpoints {
  static const String contentByCategory = '/api/v1/content';
  static const String userProgress     = '/api/v1/progress';
  static const String quizResults      = '/api/v1/quiz/results';
}
```
