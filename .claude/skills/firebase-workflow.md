# Skill: firebase-workflow

## Purpose

Step-by-step workflow for adding a Firebase-backed feature.
Invoke with: `/firebase-workflow <feature-name>`

## Step 1 — Firestore Data Source

```dart
// lib/features/<feature>/data/datasources/firebase_content_datasource.dart
abstract class FirebaseContentDataSource {
  Future<List<ContentModel>> getContentByCategory(String categoryId);
  Stream<List<ContentModel>> watchContentByCategory(String categoryId);
}

class FirebaseContentDataSourceImpl implements FirebaseContentDataSource {
  final FirebaseFirestore firestore;
  FirebaseContentDataSourceImpl({required this.firestore});

  @override
  Future<List<ContentModel>> getContentByCategory(String categoryId) async {
    final snapshot = await firestore
        .collection('content')
        .where('categoryId', isEqualTo: categoryId)
        .where('isActive', isEqualTo: true)
        .orderBy('sortOrder')
        .get();

    return snapshot.docs
        .map((doc) => ContentModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Stream<List<ContentModel>> watchContentByCategory(String categoryId) {
    return firestore
        .collection('content')
        .where('categoryId', isEqualTo: categoryId)
        .snapshots()
        .map((s) => s.docs
            .map((d) => ContentModel.fromJson({...d.data(), 'id': d.id}))
            .toList());
  }
}
```

## Step 2 — Auth Data Source

```dart
class FirebaseAuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;

  @override
  Stream<UserModel?> get authStateChanges =>
      auth.authStateChanges().map((user) =>
          user == null ? null : UserModel.fromFirebaseUser(user));

  @override
  Future<UserModel> signInWithGoogle() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) throw const AuthCancelledException();

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await auth.signInWithCredential(credential);
    return UserModel.fromFirebaseUser(userCredential.user!);
  }

  @override
  Future<void> signOut() async {
    await Future.wait([auth.signOut(), googleSignIn.signOut()]);
  }
}
```

## Step 3 — Save User Progress

```dart
Future<void> saveProgress(String uid, String categoryId, int score) async {
  await firestore
      .collection('progress')
      .doc(uid)
      .collection('categories')
      .doc(categoryId)
      .set({
    'score': score,
    'updatedAt': FieldValue.serverTimestamp(),
    'attempts': FieldValue.increment(1),
  }, SetOptions(merge: true));
}
```

## Step 4 — FCM Integration

```dart
// lib/core/services/notification_service.dart
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore;

  Future<void> initialize(String uid) async {
    final settings = await _messaging.requestPermission(
      alert: true, badge: true, sound: true,
    );
    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;

    final token = await _messaging.getToken();
    if (token != null) await _saveToken(uid, token);

    _messaging.onTokenRefresh.listen((t) => _saveToken(uid, t));
    FirebaseMessaging.onMessage.listen(_handleForeground);
  }

  Future<void> _saveToken(String uid, String token) =>
      _firestore.doc('users/$uid').set({'fcmToken': token}, SetOptions(merge: true));

  void _handleForeground(RemoteMessage message) {
    // Show in-app banner — delegate to UI layer via stream
  }
}
```

## Step 5 — Firebase Emulator (Testing)

```dart
// test/helpers/firebase_test_helper.dart
Future<void> setupFirebaseEmulators() async {
  await Firebase.initializeApp(options: const FirebaseOptions(
    apiKey: 'test', appId: 'test', messagingSenderId: 'test', projectId: 'test',
  ));
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
}
```

Start emulators: `firebase emulators:start --only firestore,auth`

## Step 6 — Register in DI

```dart
sl.registerLazySingleton(() => FirebaseFirestore.instance);
sl.registerLazySingleton(() => FirebaseAuth.instance);
sl.registerLazySingleton(() => GoogleSignIn());

sl.registerLazySingleton<FirebaseContentDataSource>(
  () => FirebaseContentDataSourceImpl(firestore: sl()),
);
sl.registerLazySingleton<AuthDataSource>(
  () => FirebaseAuthDataSourceImpl(auth: sl(), googleSignIn: sl()),
);
```

## Firestore Batch & Transaction Rules

- Use `WriteBatch` for ≥2 related document writes — ensures atomicity.
- Use `runTransaction` when a write depends on a current read value.
- Never run more than 500 operations in a single batch.
- Always handle `FirebaseException` and map to domain `Failure`.
