import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

class QuizScore {
  final int id;
  final String category;
  final int score;
  final int total;
  final DateTime completedAt;

  const QuizScore({
    required this.id,
    required this.category,
    required this.score,
    required this.total,
    required this.completedAt,
  });

  factory QuizScore.fromRow(Map<String, Object?> row) => QuizScore(
        id: row['id'] as int,
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
  }) {
    return _db.insert(AppDatabase.quizScoresTable, {
      'category': category,
      'score': score,
      'total': total,
      'completed_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<QuizScore?> latestFor(String category) async {
    final rows = await _db.query(
      AppDatabase.quizScoresTable,
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'completed_at DESC',
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return QuizScore.fromRow(rows.first);
  }

  Future<int?> bestScoreFor(String category) async {
    final rows = await _db.rawQuery(
      'SELECT MAX(score) AS best FROM ${AppDatabase.quizScoresTable} '
      'WHERE category = ?',
      [category],
    );
    return rows.first['best'] as int?;
  }

  Future<List<QuizScore>> history({int limit = 50}) async {
    final rows = await _db.query(
      AppDatabase.quizScoresTable,
      orderBy: 'completed_at DESC',
      limit: limit,
    );
    return rows.map(QuizScore.fromRow).toList();
  }
}
