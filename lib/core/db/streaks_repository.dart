import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app_database.dart';

class StreakSnapshot {
  final int current;
  final int longest;
  final DateTime? lastActivity;

  const StreakSnapshot({
    required this.current,
    required this.longest,
    required this.lastActivity,
  });

  static const empty =
      StreakSnapshot(current: 0, longest: 0, lastActivity: null);
}

class StreaksRepository {
  StreaksRepository(this._db);
  final Database _db;

  static String _dayKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Future<StreakSnapshot> getFor(int childId) async {
    final rows = await _db.query(
      AppDatabase.streaksTable,
      where: 'child_id = ?',
      whereArgs: [childId],
      limit: 1,
    );
    if (rows.isEmpty) return StreakSnapshot.empty;
    final r = rows.first;
    final lastKey = r['last_activity_day'] as String?;
    return StreakSnapshot(
      current: (r['current_streak'] as int?) ?? 0,
      longest: (r['longest_streak'] as int?) ?? 0,
      lastActivity: lastKey == null ? null : DateTime.parse(lastKey),
    );
  }

  Future<StreakSnapshot> recordActivityToday(int childId) async {
    final now = DateTime.now();
    final todayKey = _dayKey(now);
    final yesterdayKey =
        _dayKey(DateTime(now.year, now.month, now.day - 1));

    final current = await getFor(childId);
    if (current.lastActivity != null &&
        _dayKey(current.lastActivity!) == todayKey) {
      return current;
    }

    int next;
    if (current.lastActivity != null &&
        _dayKey(current.lastActivity!) == yesterdayKey) {
      next = current.current + 1;
    } else {
      next = 1;
    }
    final longest = next > current.longest ? next : current.longest;

    await _db.insert(
      AppDatabase.streaksTable,
      {
        'child_id': childId,
        'current_streak': next,
        'longest_streak': longest,
        'last_activity_day': todayKey,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return StreakSnapshot(
      current: next,
      longest: longest,
      lastActivity: DateTime(now.year, now.month, now.day),
    );
  }
}
