import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app_database.dart';

class ChildEntity {
  final int id;
  final int parentId;
  final String name;
  final int? age;
  final int avatarIndex;
  final String level;
  final DateTime createdAt;

  const ChildEntity({
    required this.id,
    required this.parentId,
    required this.name,
    this.age,
    required this.avatarIndex,
    required this.level,
    required this.createdAt,
  });

  factory ChildEntity.fromRow(Map<String, Object?> row) => ChildEntity(
        id: row['id'] as int,
        parentId: row['parent_id'] as int,
        name: row['name'] as String,
        age: row['age'] as int?,
        avatarIndex: row['avatar_index'] as int,
        level: row['level'] as String,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          row['created_at'] as int,
        ),
      );

  ChildEntity copyWith({String? name, int? age, int? avatarIndex, String? level}) =>
      ChildEntity(
        id: id,
        parentId: parentId,
        name: name ?? this.name,
        age: age ?? this.age,
        avatarIndex: avatarIndex ?? this.avatarIndex,
        level: level ?? this.level,
        createdAt: createdAt,
      );
}

class ChildrenRepository {
  ChildrenRepository(this._db);
  final Database _db;

  static const avatarEmojis = [
    '🦁', '🐼', '🐯', '🦊', '🐻', '🐸', '🦄', '🐱',
  ];

  Future<ChildEntity> create({
    required int parentId,
    required String name,
    int? age,
    required int avatarIndex,
    required String level,
  }) async {
    final now = DateTime.now();
    final id = await _db.insert(AppDatabase.childrenTable, {
      'parent_id': parentId,
      'name': name.trim(),
      'age': age,
      'avatar_index': avatarIndex,
      'level': level,
      'created_at': now.millisecondsSinceEpoch,
    });
    return ChildEntity(
      id: id,
      parentId: parentId,
      name: name.trim(),
      age: age,
      avatarIndex: avatarIndex,
      level: level,
      createdAt: now,
    );
  }

  Future<List<ChildEntity>> listByParent(int parentId) async {
    final rows = await _db.query(
      AppDatabase.childrenTable,
      where: 'parent_id = ?',
      whereArgs: [parentId],
      orderBy: 'created_at ASC',
    );
    return rows.map(ChildEntity.fromRow).toList();
  }

  Future<ChildEntity?> findById(int id) async {
    final rows = await _db.query(
      AppDatabase.childrenTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;
    return ChildEntity.fromRow(rows.first);
  }

  Future<bool> update({
    required int id,
    required String name,
    int? age,
    required int avatarIndex,
    required String level,
  }) async {
    final count = await _db.update(
      AppDatabase.childrenTable,
      {
        'name': name.trim(),
        'age': age,
        'avatar_index': avatarIndex,
        'level': level
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  Future<bool> delete(int id) async {
    final count = await _db.delete(
      AppDatabase.childrenTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    return count > 0;
  }

  /// Erases all learning data for a child without removing the profile.
  Future<void> clearData(int childId) async {
    const tablesWithChildId = [
      AppDatabase.quizScoresTable,
      AppDatabase.moduleProgressTable,
      AppDatabase.learningSessionsTable,
      AppDatabase.rewardsTable,
      AppDatabase.badgesTable,
      AppDatabase.streaksTable,
      AppDatabase.dailyUsageTable,
      AppDatabase.screenTimeLimitsTable,
    ];
    for (final table in tablesWithChildId) {
      await _db.delete(table, where: 'child_id = ?', whereArgs: [childId]);
    }
  }

  /// Deletes the child profile AND all associated learning data.
  Future<void> deleteWithData(int childId) async {
    await clearData(childId);
    await delete(childId);
  }
}
