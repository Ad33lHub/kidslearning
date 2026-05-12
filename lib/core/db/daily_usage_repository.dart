import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app_database.dart';

class DailyUsageRepository {
  DailyUsageRepository(this._db);
  final Database _db;

  static String _todayKey() {
    final now = DateTime.now();
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '${now.year}-$m-$d';
  }

  Future<int> getUsedSeconds(int childId) async {
    final rows = await _db.query(
      AppDatabase.dailyUsageTable,
      where: 'child_id = ? AND date_key = ?',
      whereArgs: [childId, _todayKey()],
    );
    if (rows.isEmpty) return 0;
    return rows.first['used_seconds'] as int;
  }

  Future<void> addSeconds(int childId, int seconds) async {
    final key = _todayKey();
    await _db.rawInsert(
      'INSERT INTO ${AppDatabase.dailyUsageTable} '
      '(child_id, date_key, used_seconds) VALUES (?, ?, ?) '
      'ON CONFLICT(child_id, date_key) '
      'DO UPDATE SET used_seconds = used_seconds + ?',
      [childId, key, seconds, seconds],
    );
  }

  Future<int> getLimitSeconds(int childId) async {
    final rows = await _db.query(
      AppDatabase.screenTimeLimitsTable,
      where: 'child_id = ?',
      whereArgs: [childId],
    );
    if (rows.isEmpty) return 3600;
    return rows.first['daily_limit_seconds'] as int;
  }

  Future<void> setLimitSeconds(int childId, int seconds) async {
    await _db.rawInsert(
      'INSERT INTO ${AppDatabase.screenTimeLimitsTable} '
      '(child_id, daily_limit_seconds) VALUES (?, ?) '
      'ON CONFLICT(child_id) DO UPDATE SET daily_limit_seconds = ?',
      [childId, seconds, seconds],
    );
  }

  Future<bool> isLimitReached(int childId) async {
    final used = await getUsedSeconds(childId);
    final limit = await getLimitSeconds(childId);
    return used >= limit;
  }
}
