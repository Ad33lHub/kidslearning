import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _kParentId = 'parent_id';
  static const _kParentEmail = 'parent_email';
  static const _kChildId = 'child_id';
  static const _kChildName = 'child_name';
  static const _kChildAvatar = 'child_avatar_index';
  static const _kChildLevel = 'child_level';

  Future<void> saveParent({required int id, required String email}) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kParentId, id);
    await p.setString(_kParentEmail, email);
  }

  Future<void> saveChild({
    required int id,
    required String name,
    required int avatarIndex,
    required String level,
  }) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kChildId, id);
    await p.setString(_kChildName, name);
    await p.setInt(_kChildAvatar, avatarIndex);
    await p.setString(_kChildLevel, level);
  }

  Future<int?> get parentId async =>
      (await SharedPreferences.getInstance()).getInt(_kParentId);

  Future<String?> get parentEmail async =>
      (await SharedPreferences.getInstance()).getString(_kParentEmail);

  Future<int?> get childId async =>
      (await SharedPreferences.getInstance()).getInt(_kChildId);

  Future<Map<String, dynamic>?> get childData async {
    final p = await SharedPreferences.getInstance();
    final id = p.getInt(_kChildId);
    if (id == null) return null;
    return {
      'id': id,
      'name': p.getString(_kChildName) ?? '',
      'avatar_index': p.getInt(_kChildAvatar) ?? 0,
      'level': p.getString(_kChildLevel) ?? 'easy',
    };
  }

  Future<bool> get isLoggedIn async => (await parentId) != null;

  Future<void> clearChild() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kChildId);
    await p.remove(_kChildName);
    await p.remove(_kChildAvatar);
    await p.remove(_kChildLevel);
  }

  Future<void> logout() async =>
      (await SharedPreferences.getInstance()).clear();
}
