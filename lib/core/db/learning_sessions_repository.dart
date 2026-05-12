import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app_database.dart';

class LearningSession {
  final int id;
  final int childId;
  final String module;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int durationSeconds;

  const LearningSession({
    required this.id,
    required this.childId,
    required this.module,
    required this.startedAt,
    this.endedAt,
    required this.durationSeconds,
  });

  factory LearningSession.fromRow(Map<String, Object?> row) => LearningSession(
        id: row['id'] as int,
        childId: row['child_id'] as int,
        module: row['module'] as String,
        startedAt: DateTime.fromMillisecondsSinceEpoch(
          row['started_at'] as int,
        ),
        endedAt: row['ended_at'] != null
            ? DateTime.fromMillisecondsSinceEpoch(row['ended_at'] as int)
            : null,
        durationSeconds: row['duration_seconds'] as int,
      );
}

class LearningSessionsRepository {
  LearningSessionsRepository(this._db);
  final Database _db;

  Future<int> startSession({
    required int childId,
    required String module,
  }) =>
      _db.insert(AppDatabase.learningSessionsTable, {
        'child_id': childId,
        'module': module,
        'started_at': DateTime.now().millisecondsSinceEpoch,
        'duration_seconds': 0,
      });

  Future<void> endSession({
    required int sessionId,
    required int durationSeconds,
  }) async {
    await _db.update(
      AppDatabase.learningSessionsTable,
      {
        'ended_at': DateTime.now().millisecondsSinceEpoch,
        'duration_seconds': durationSeconds,
      },
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  Future<int> totalSecondsForChild(int childId) async {
    final rows = await _db.rawQuery(
      'SELECT SUM(duration_seconds) AS total '
      'FROM ${AppDatabase.learningSessionsTable} WHERE child_id = ?',
      [childId],
    );
    return (rows.first['total'] as int?) ?? 0;
  }

  Future<Map<String, int>> secondsPerModule(int childId) async {
    final rows = await _db.rawQuery(
      'SELECT module, SUM(duration_seconds) AS total '
      'FROM ${AppDatabase.learningSessionsTable} '
      'WHERE child_id = ? GROUP BY module',
      [childId],
    );
    return {
      for (final r in rows) r['module'] as String: (r['total'] as int?) ?? 0,
    };
  }

  Future<List<LearningSession>> recentSessions({
    required int childId,
    int limit = 20,
  }) async {
    final rows = await _db.query(
      AppDatabase.learningSessionsTable,
      where: 'child_id = ?',
      whereArgs: [childId],
      orderBy: 'started_at DESC',
      limit: limit,
    );
    return rows.map(LearningSession.fromRow).toList();
  }
}
