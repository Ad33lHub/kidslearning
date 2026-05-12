import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app_database.dart';

class RewardsSnapshot {
  final int stars;
  final int coins;

  const RewardsSnapshot({required this.stars, required this.coins});

  static const empty = RewardsSnapshot(stars: 0, coins: 0);
}

class RewardsRepository {
  RewardsRepository(this._db);
  final Database _db;

  Future<RewardsSnapshot> getFor(int childId) async {
    final rows = await _db.query(
      AppDatabase.rewardsTable,
      where: 'child_id = ?',
      whereArgs: [childId],
      limit: 1,
    );
    if (rows.isEmpty) return RewardsSnapshot.empty;
    final r = rows.first;
    return RewardsSnapshot(
      stars: (r['stars'] as int?) ?? 0,
      coins: (r['coins'] as int?) ?? 0,
    );
  }

  Future<RewardsSnapshot> award({
    required int childId,
    int stars = 0,
    int coins = 0,
  }) async {
    final current = await getFor(childId);
    final nextStars = current.stars + stars;
    final nextCoins = current.coins + coins;
    await _db.insert(
      AppDatabase.rewardsTable,
      {
        'child_id': childId,
        'stars': nextStars,
        'coins': nextCoins,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return RewardsSnapshot(stars: nextStars, coins: nextCoins);
  }
}
