import 'package:flutter/foundation.dart';

import '../db/app_database.dart';
import '../db/children_repository.dart';
import '../services/session_service.dart';

class AppState extends ChangeNotifier {
  final _session = SessionService();

  int? _parentId;
  String? _parentEmail;
  ChildEntity? _currentChild;
  bool _parentUnlocked = false;

  int? get parentId => _parentId;
  String? get parentEmail => _parentEmail;
  ChildEntity? get currentChild => _currentChild;
  bool get isParentUnlocked => _parentUnlocked;
  bool get isLoggedIn => _parentId != null;
  bool get hasChild => _currentChild != null;

  Future<void> loadSession() async {
    _parentId = await _session.parentId;
    _parentEmail = await _session.parentEmail;
    final childData = await _session.childData;
    if (childData != null) {
      final db = await AppDatabase.instance.database;
      final repo = ChildrenRepository(db);
      _currentChild = await repo.findById(childData['id'] as int);
    }
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
}
