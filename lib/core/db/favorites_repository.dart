import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

class FavoriteEntry {
  final int id;
  final String category;
  final String itemKey;
  final DateTime addedAt;

  const FavoriteEntry({
    required this.id,
    required this.category,
    required this.itemKey,
    required this.addedAt,
  });

  factory FavoriteEntry.fromRow(Map<String, Object?> row) => FavoriteEntry(
        id: row['id'] as int,
        category: row['category'] as String,
        itemKey: row['item_key'] as String,
        addedAt:
            DateTime.fromMillisecondsSinceEpoch(row['added_at'] as int),
      );
}

class FavoritesRepository {
  FavoritesRepository(this._db);
  final Database _db;

  Future<int> add(String category, String itemKey) {
    return _db.insert(
      AppDatabase.favoritesTable,
      {
        'category': category,
        'item_key': itemKey,
        'added_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> remove(String category, String itemKey) {
    return _db.delete(
      AppDatabase.favoritesTable,
      where: 'category = ? AND item_key = ?',
      whereArgs: [category, itemKey],
    );
  }

  Future<bool> isFavorite(String category, String itemKey) async {
    final rows = await _db.query(
      AppDatabase.favoritesTable,
      where: 'category = ? AND item_key = ?',
      whereArgs: [category, itemKey],
      limit: 1,
    );
    return rows.isNotEmpty;
  }

  Future<List<FavoriteEntry>> listByCategory(String category) async {
    final rows = await _db.query(
      AppDatabase.favoritesTable,
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'added_at DESC',
    );
    return rows.map(FavoriteEntry.fromRow).toList();
  }
}
