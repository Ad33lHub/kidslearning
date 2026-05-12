import '../db/app_database.dart';
import '../db/module_progress_repository.dart';

class UnlockService {
  UnlockService._();
  static final UnlockService instance = UnlockService._();

  // First 4 modules are always unlocked; later ones unlock after the previous
  // one has at least one quiz attempt.
  static const _alwaysUnlocked = 4;
  static const _order = ModuleProgressRepository.allModules;

  Future<Set<String>> unlockedFor(int? childId) async {
    if (childId == null) {
      return {..._order.take(_alwaysUnlocked)};
    }
    final db = await AppDatabase.instance.database;
    final list = await ModuleProgressRepository(db).listFor(childId);
    final attempted = {for (final p in list) p.module};

    final unlocked = <String>{..._order.take(_alwaysUnlocked)};
    for (var i = _alwaysUnlocked; i < _order.length; i++) {
      final prev = _order[i - 1];
      if (attempted.contains(prev)) {
        unlocked.add(_order[i]);
      } else {
        break;
      }
    }
    return unlocked;
  }

  String prerequisiteFor(String module) {
    final idx = _order.indexOf(module);
    if (idx <= 0) return _order.first;
    return _order[idx - 1];
  }
}
