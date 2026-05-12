import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app_database.dart';

class ModuleProgress {
  final String module;
  final int completedItems;
  final int totalItems;
  final int bestScore;
  final DateTime updatedAt;

  const ModuleProgress({
    required this.module,
    required this.completedItems,
    required this.totalItems,
    required this.bestScore,
    required this.updatedAt,
  });

  double get percentage {
    if (totalItems <= 0) return 0;
    final pct = (completedItems / totalItems) * 100;
    return pct.clamp(0, 100).toDouble();
  }

  bool get isComplete => totalItems > 0 && completedItems >= totalItems;

  factory ModuleProgress.fromRow(Map<String, Object?> row) => ModuleProgress(
        module: row['module'] as String,
        completedItems: (row['completed_items'] as int?) ?? 0,
        totalItems: (row['total_items'] as int?) ?? 0,
        bestScore: (row['best_score'] as int?) ?? 0,
        updatedAt: DateTime.fromMillisecondsSinceEpoch(
          row['updated_at'] as int,
        ),
      );
}

class ModuleProgressRepository {
  ModuleProgressRepository(this._db);
  final Database _db;

  static const allModules = <String>[
    'alphabet',
    'numbers',
    'colors',
    'shapes',
    'animals',
    'birds',
    'flowers',
    'fruits',
    'months',
    'vegetables',
  ];

  Future<ModuleProgress?> get({
    required int childId,
    required String module,
  }) async {
    final rows = await _db.query(
      AppDatabase.moduleProgressTable,
      where: 'child_id = ? AND module = ?',
      whereArgs: [childId, module],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return ModuleProgress.fromRow(rows.first);
  }

  Future<void> recordQuizResult({
    required int childId,
    required String module,
    required int score,
    required int total,
  }) async {
    final existing = await get(childId: childId, module: module);
    final newCompleted = (existing?.completedItems ?? 0) + score;
    final newTotal = (existing?.totalItems ?? 0) + total;
    final newBest = score > (existing?.bestScore ?? 0)
        ? score
        : (existing?.bestScore ?? 0);
    await _db.insert(
      AppDatabase.moduleProgressTable,
      {
        'child_id': childId,
        'module': module,
        'completed_items': newCompleted,
        'total_items': newTotal,
        'best_score': newBest,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ModuleProgress>> listFor(int childId) async {
    final rows = await _db.query(
      AppDatabase.moduleProgressTable,
      where: 'child_id = ?',
      whereArgs: [childId],
      orderBy: 'module ASC',
    );
    return rows.map(ModuleProgress.fromRow).toList();
  }

  Future<double> overallPercentage(int childId) async {
    final rows = await _db.rawQuery(
      'SELECT SUM(completed_items) AS done, SUM(total_items) AS total '
      'FROM ${AppDatabase.moduleProgressTable} WHERE child_id = ?',
      [childId],
    );
    final done = (rows.first['done'] as int?) ?? 0;
    final total = (rows.first['total'] as int?) ?? 0;
    if (total <= 0) return 0;
    return ((done / total) * 100).clamp(0, 100).toDouble();
  }

  Future<int> completedModulesCount(int childId) async {
    final rows = await _db.rawQuery(
      'SELECT COUNT(*) AS c FROM ${AppDatabase.moduleProgressTable} '
      'WHERE child_id = ? AND total_items > 0 '
      'AND completed_items >= total_items',
      [childId],
    );
    return (rows.first['c'] as int?) ?? 0;
  }

  Future<int> attemptedCategoriesCount(int childId) async {
    final rows = await _db.rawQuery(
      'SELECT COUNT(DISTINCT module) AS c FROM ${AppDatabase.moduleProgressTable} '
      'WHERE child_id = ?',
      [childId],
    );
    return (rows.first['c'] as int?) ?? 0;
  }
}
