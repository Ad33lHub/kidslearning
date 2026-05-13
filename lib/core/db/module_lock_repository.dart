import 'package:sqflite/sqflite.dart';

class ModuleLockRepository {
  final Database db;
  ModuleLockRepository(this.db);

  static const String table = 'module_locks';

  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        child_id INTEGER,
        module_key TEXT,
        PRIMARY KEY (child_id, module_key)
      )
    ''');
  }

  Future<void> lock(int childId, String moduleKey) async {
    await db.insert(
      table,
      {'child_id': childId, 'module_key': moduleKey},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> unlock(int childId, String moduleKey) async {
    await db.delete(
      table,
      where: 'child_id = ? AND module_key = ?',
      whereArgs: [childId, moduleKey],
    );
  }

  Future<Set<String>> getLockedModules(int childId) async {
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      columns: ['module_key'],
      where: 'child_id = ?',
      whereArgs: [childId],
    );
    return maps.map((m) => m['module_key'] as String).toSet();
  }

  Future<bool> isLocked(int childId, String moduleKey) async {
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: 'child_id = ? AND module_key = ?',
      whereArgs: [childId, moduleKey],
    );
    return maps.isNotEmpty;
  }
}
