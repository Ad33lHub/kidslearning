# Skill: flutter-clean-architecture

## Purpose

Slash command skill for scaffolding a complete clean architecture feature module.
Invoke with: `/flutter-clean-architecture <feature-name>`

## What This Skill Does

Generates the full directory tree and boilerplate files for a new feature following
clean architecture: domain → data → presentation, wired with dependency injection.

## Feature-First Architecture

Every feature is self-contained under `lib/features/<feature_name>/`:

```
lib/features/<feature>/
├── domain/
│   ├── entities/
│   │   └── <feature>_entity.dart         # Pure Dart, no Flutter imports
│   ├── repositories/
│   │   └── <feature>_repository.dart     # Abstract interface only
│   └── usecases/
│       ├── get_<feature>_list.dart
│       └── get_<feature>_detail.dart
├── data/
│   ├── models/
│   │   └── <feature>_model.dart          # Extends entity, has fromJson/toJson
│   ├── datasources/
│   │   ├── <feature>_remote_datasource.dart
│   │   └── <feature>_local_datasource.dart
│   └── repositories/
│       └── <feature>_repository_impl.dart
└── presentation/
    ├── screens/
    │   └── <feature>_screen.dart
    ├── widgets/
    │   └── <feature>_card.dart
    ├── providers/                          # or bloc/ or cubit/
    │   └── <feature>_provider.dart
    └── state/
        └── <feature>_state.dart
```

## Layer Contracts

### Domain Entity (pure Dart)
```dart
class ContentEntity extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final ContentType type;

  const ContentEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.type,
  });

  @override
  List<Object> get props => [id, name, imageUrl, type];
}
```

### Repository Interface (domain layer)
```dart
abstract class ContentRepository {
  Future<Either<Failure, List<ContentEntity>>> getContentList(ContentType type);
  Future<Either<Failure, ContentEntity>> getContentById(String id);
}
```

### Use Case
```dart
class GetContentList implements UseCase<List<ContentEntity>, ContentTypeParams> {
  final ContentRepository repository;
  GetContentList(this.repository);

  @override
  Future<Either<Failure, List<ContentEntity>>> call(ContentTypeParams params) {
    return repository.getContentList(params.type);
  }
}
```

### Data Model (data layer)
```dart
class ContentModel extends ContentEntity {
  const ContentModel({...}) : super(...);

  factory ContentModel.fromJson(Map<String, dynamic> json) => ContentModel(
    id: json['id'] as String,
    name: json['name'] as String,
    imageUrl: json['imageUrl'] as String,
    type: ContentType.values.byName(json['type'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'type': type.name,
  };
}
```

### Repository Implementation (data layer)
```dart
class ContentRepositoryImpl implements ContentRepository {
  final ContentRemoteDataSource remoteDataSource;
  final ContentLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ContentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ContentEntity>>> getContentList(ContentType type) async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.fetchContentList(type);
        await localDataSource.cacheContentList(type, models);
        return Right(models);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final cached = await localDataSource.getCachedContentList(type);
        return Right(cached);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
```

## Dependency Injection Workflow

Use `get_it` with a `injection_container.dart` at `lib/core/di/injection_container.dart`:

```dart
final sl = GetIt.instance;

Future<void> init() async {
  // Features
  _initContentFeature();

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => Dio()..interceptors.add(sl<AuthInterceptor>()));
}

void _initContentFeature() {
  // Use cases
  sl.registerFactory(() => GetContentList(sl()));

  // Repository
  sl.registerLazySingleton<ContentRepository>(
    () => ContentRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<ContentRemoteDataSource>(
    () => ContentRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<ContentLocalDataSource>(
    () => ContentLocalDataSourceImpl(sharedPreferences: sl()),
  );
}
```

## Scaffold Steps When Invoked

1. Create domain entity
2. Create repository interface
3. Create use cases
4. Create data model
5. Create remote + local data sources (stubs)
6. Create repository implementation
7. Register in `injection_container.dart`
8. Create presentation screen + state
9. Create unit test stubs for use case and repository
