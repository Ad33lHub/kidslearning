import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:google_sign_in/google_sign_in.dart';

import '../db/app_database.dart';
import '../db/parent_repository.dart';

class AuthResult {
  final ParentEntity parent;
  final User firebaseUser;
  const AuthResult({required this.parent, required this.firebaseUser});
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}

class AuthService {
  AuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    Connectivity? connectivity,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _google = googleSignIn ?? GoogleSignIn(),
        _connectivity = connectivity ?? Connectivity();

  final FirebaseAuth _auth;
  final GoogleSignIn _google;
  final Connectivity _connectivity;

  User? get currentUser => _auth.currentUser;
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<bool> isOnline() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  Future<void> _requireOnline() async {
    if (!await isOnline()) {
      throw const AuthException(
        'You need an internet connection to sign in for the first time.',
      );
    }
  }

  Future<AuthResult> registerWithEmail({
    required String email,
    required String password,
  }) async {
    await _requireOnline();
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _persist(cred.user!, provider: 'password');
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    } on FirebaseException catch (e) {
      throw AuthException(e.message ?? 'Firebase error (${e.code}).');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _requireOnline();
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _persist(cred.user!, provider: 'password');
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    } on FirebaseException catch (e) {
      throw AuthException(e.message ?? 'Firebase error (${e.code}).');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<AuthResult> signInWithGoogle() async {
    await _requireOnline();
    try {
      final account = await _google.signIn();
      if (account == null) {
        throw const AuthException('Google sign-in was cancelled.');
      }
      final auth = await account.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      final cred = await _auth.signInWithCredential(credential);
      return _persist(cred.user!, provider: 'google');
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    } on FirebaseException catch (e) {
      throw AuthException(e.message ?? 'Firebase error (${e.code}).');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<void> sendPasswordReset(String email) async {
    await _requireOnline();
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageFor(e));
    } on FirebaseException catch (e) {
      throw AuthException(e.message ?? 'Firebase error (${e.code}).');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  Future<void> signOut() async {
    await _google.signOut();
    await _auth.signOut();
  }

  Future<AuthResult> _persist(User user, {required String provider}) async {
    final email = user.email;
    if (email == null || email.isEmpty) {
      throw const AuthException('This account has no email address.');
    }
    final db = await AppDatabase.instance.database;
    final repo = ParentRepository(db);
    final parent = await repo.upsertFromFirebase(
      firebaseUid: user.uid,
      email: email,
      provider: provider,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
    return AuthResult(parent: parent, firebaseUser: user);
  }

  Future<AuthResult?> hydrateFromCachedUser() async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) return null;
    final provider = user.providerData.isNotEmpty
        ? _mapProviderId(user.providerData.first.providerId)
        : 'password';
    final db = await AppDatabase.instance.database;
    final repo = ParentRepository(db);
    final parent = await repo.upsertFromFirebase(
      firebaseUid: user.uid,
      email: user.email!,
      provider: provider,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
    return AuthResult(parent: parent, firebaseUser: user);
  }

  String _mapProviderId(String id) {
    if (id.contains('google')) return 'google';
    if (id.contains('apple')) return 'apple';
    return 'password';
  }

  String _messageFor(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'That email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'That email is already registered.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled. Please enable it in the Firebase Console.';
      case 'account-exists-with-different-credential':
        return 'An account already exists for this email with a different sign-in method.';
      default:
        return e.message ?? 'Authentication failed (${e.code}).';
    }
  }
}
