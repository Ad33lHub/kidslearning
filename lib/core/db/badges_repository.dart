import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app_database.dart';

class BadgeEntity {
  final String key;
  final DateTime earnedAt;
  const BadgeEntity({required this.key, required this.earnedAt});
}

class BadgeCatalog {
  static const firstQuiz = 'first_quiz';
  static const perfectScore = 'perfect_score';
  static const fiveQuizzes = 'five_quizzes';
  static const streak3 = 'streak_3';
  static const streak7 = 'streak_7';
  static const allCategoriesTried = 'all_categories_tried';

  static const meta = <String, Map<String, String>>{
    firstQuiz: {'emoji': '🥇', 'label': 'First Quiz Completed'},
    perfectScore: {'emoji': '🏆', 'label': 'Perfect Score'},
    fiveQuizzes: {'emoji': '⭐', 'label': '5 Quizzes Done'},
    streak3: {'emoji': '🔥', 'label': '3-Day Streak'},
    streak7: {'emoji': '🌟', 'label': '7-Day Streak'},
    allCategoriesTried: {'emoji': '🎨', 'label': 'Explored All Categories'},
  };
}

class BadgesRepository {
  BadgesRepository(this._db);
  final Database _db;

  Future<bool> award({required int childId, required String key}) async {
    try {
      await _db.insert(AppDatabase.badgesTable, {
        'child_id': childId,
        'badge_key': key,
        'earned_at': DateTime.now().millisecondsSinceEpoch,
      });
      return true;
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) return false;
      rethrow;
    }
  }

  Future<List<BadgeEntity>> listFor(int childId) async {
    final rows = await _db.query(
      AppDatabase.badgesTable,
      where: 'child_id = ?',
      whereArgs: [childId],
      orderBy: 'earned_at DESC',
    );
    return rows
        .map((r) => BadgeEntity(
              key: r['badge_key'] as String,
              earnedAt: DateTime.fromMillisecondsSinceEpoch(
                r['earned_at'] as int,
              ),
            ))
        .toList();
  }

  Future<int> countFor(int childId) async {
    final rows = await _db.rawQuery(
      'SELECT COUNT(*) AS c FROM ${AppDatabase.badgesTable} WHERE child_id = ?',
      [childId],
    );
    return (rows.first['c'] as int?) ?? 0;
  }
}
