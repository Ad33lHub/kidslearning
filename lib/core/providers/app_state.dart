import 'package:flutter/foundation.dart';

import '../db/app_database.dart';
import '../db/children_repository.dart';
import '../db/module_lock_repository.dart';
import '../db/rewards_repository.dart';
import '../services/auth_service.dart';
import '../services/session_service.dart';
import '../widgets/app_mode_selection_screen.dart';

class AppState extends ChangeNotifier {
  final _session = SessionService();
  final _auth = AuthService();

  int? _parentId;
  String? _parentEmail;
  ChildEntity? _currentChild;
  bool _parentUnlocked = false;
  Set<String> _lockedModules = {};
  AppMode? _mode;
  int _stars = 0;
  int _coins = 0;

  int? get parentId => _parentId;
  String? get parentEmail => _parentEmail;
  ChildEntity? get currentChild => _currentChild;
  bool get isParentUnlocked => _parentUnlocked;
  bool get isLoggedIn => _parentId != null;
  bool get hasChild => _currentChild != null;
  Set<String> get lockedModules => _lockedModules;
  AppMode? get mode => _mode;
  int get stars => _stars;
  int get coins => _coins;

  Future<void> loadSession() async {
    // Firebase persists the signed-in user locally, so subsequent launches
    // can hydrate offline. We mirror that into our local parent row.
    final result = await _auth.hydrateFromCachedUser();
    if (result != null) {
      _parentId = result.parent.id;
      _parentEmail = result.parent.email;
      await _session.saveParent(
          id: result.parent.id, email: result.parent.email);
    } else {
      _parentId = await _session.parentId;
      _parentEmail = await _session.parentEmail;
      // Stale local session without a Firebase user → force re-auth.
      if (_parentId != null && _auth.currentUser == null) {
        await _session.logout();
        _parentId = null;
        _parentEmail = null;
        _currentChild = null;
        notifyListeners();
        return;
      }
    }

    final childData = await _session.childData;
    if (childData != null) {
      final db = await AppDatabase.instance.database;
      final repo = ChildrenRepository(db);
      _currentChild = await repo.findById(childData['id'] as int);
      if (_currentChild != null) {
        await refreshLocks();
        await refreshRewards();
      }
    }
    notifyListeners();
  }

  Future<void> refreshRewards() async {
    if (_currentChild == null) return;
    final db = await AppDatabase.instance.database;
    final repo = RewardsRepository(db);
    final snapshot = await repo.getFor(_currentChild!.id);
    _stars = snapshot.stars;
    _coins = snapshot.coins;
    notifyListeners();
  }

  Future<void> refreshLocks() async {
    if (_currentChild == null) return;
    final db = await AppDatabase.instance.database;
    _lockedModules =
        await ModuleLockRepository(db).getLockedModules(_currentChild!.id);
    notifyListeners();
  }

  Future<void> setParent({required int id, required String email}) async {
    await _session.saveParent(id: id, email: email);
    _parentId = id;
    _parentEmail = email;
    _parentUnlocked = false;
    notifyListeners();
  }

  Future<void> setChild(ChildEntity child) async {
    await _session.saveChild(
      id: child.id,
      name: child.name,
      avatarIndex: child.avatarIndex,
      level: child.level,
    );
    _currentChild = child;
    await refreshLocks();
    await refreshRewards();
    notifyListeners();
  }

  void unlockParent() {
    _parentUnlocked = true;
    notifyListeners();
  }

  void lockParent() {
    _parentUnlocked = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _session.logout();
    _parentId = null;
    _parentEmail = null;
    _currentChild = null;
    _parentUnlocked = false;
    notifyListeners();
  }

  Future<void> clearChild() async {
    await _session.clearChild();
    _currentChild = null;
    notifyListeners();
  }

  void refreshChild(ChildEntity updated) {
    _currentChild = updated;
    notifyListeners();
  }

  void setMode(AppMode? mode) {
    _mode = mode;
    if (mode == null) {
      _parentUnlocked = false;
    }
    notifyListeners();
  }
}
