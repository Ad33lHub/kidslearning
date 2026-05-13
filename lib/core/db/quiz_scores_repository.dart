import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

class QuizScore {
  final int id;
  final int? childId;
  final String category;
  final int score;
  final int total;
  final DateTime completedAt;

  const QuizScore({
    required this.id,
    this.childId,
    required this.category,
    required this.score,
    required this.total,
    required this.completedAt,
  });

  double get percentage => total > 0 ? (score / total) * 100 : 0;

  factory QuizScore.fromRow(Map<String, Object?> row) => QuizScore(
        id: row['id'] as int,
        childId: row['child_id'] as int?,
        category: row['category'] as String,
        score: row['score'] as int,
        total: row['total'] as int,
        completedAt:
            DateTime.fromMillisecondsSinceEpoch(row['completed_at'] as int),
      );
}

class QuizScoresRepository {
  QuizScoresRepository(this._db);
  final Database _db;

  Future<int> record({
    required String category,
    required int score,
    required int total,
    int? childId,
  }) {
    return _db.insert(AppDatabase.quizScoresTable, {
      'category': category,
      'score': score,
      'total': total,
      'completed_at': DateTime.now().millisecondsSinceEpoch,
      if (childId != null) 'child_id': childId,
    });
  }

  /// Latest score for a category, filtered to a specific child.
  Future<QuizScore?> latestFor(String category, {int? childId}) async {
    final rows = await _db.query(
      AppDatabase.quizScoresTable,
      where: childId != null
          ? 'category = ? AND child_id = ?'
          : 'category = ?',
      whereArgs: childId != null ? [category, childId] : [category],
      orderBy: 'completed_at DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return QuizScore.fromRow(rows.first);
  }

  /// Best score for a category for a specific child.
  Future<int?> bestScoreForChild(int childId, String category) async {
    final rows = await _db.rawQuery(
      'SELECT MAX(score) AS best FROM ${AppDatabase.quizScoresTable} '
      'WHERE child_id = ? AND category = ?',
      [childId, category],
    );
    return rows.first['best'] as int?;
  }

  /// History for a specific child (most recent first).
  Future<List<QuizScore>> historyFor(int childId, {int limit = 50}) async {
    final rows = await _db.query(
      AppDatabase.quizScoresTable,
      where: 'child_id = ?',
      whereArgs: [childId],
      orderBy: 'completed_at DESC',
      limit: limit,
    );
    return rows.map(QuizScore.fromRow).toList();
  }

  /// Global history — kept for badge evaluation which needs all-time counts.
  Future<List<QuizScore>> history({int limit = 50}) async {
    final rows = await _db.query(
      AppDatabase.quizScoresTable,
      orderBy: 'completed_at DESC',
      limit: limit,
    );
    return rows.map(QuizScore.fromRow).toList();
  }

  /// Count of completed quizzes for a child (used for badge thresholds).
  Future<int> countForChild(int childId) async {
    final rows = await _db.rawQuery(
      'SELECT COUNT(*) AS c FROM ${AppDatabase.quizScoresTable} '
      'WHERE child_id = ?',
      [childId],
    );
    return (rows.first['c'] as int?) ?? 0;
  }
}
