import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app_database.dart';

class ParentEntity {
  final int id;
  final String email;
  final bool hasPin;
  final DateTime createdAt;

  const ParentEntity({
    required this.id,
    required this.email,
    required this.hasPin,
    required this.createdAt,
  });

  factory ParentEntity.fromRow(Map<String, Object?> row) => ParentEntity(
        id: row['id'] as int,
        email: row['email'] as String,
        hasPin: row['pin_hash'] != null,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          row['created_at'] as int,
        ),
      );
}

class ParentRepository {
  ParentRepository(this._db);
  final Database _db;

  static String _hash(String input) =>
      sha256.convert(utf8.encode(input)).toString();

  Future<ParentEntity?> register({
    required String email,
    required String password,
  }) async {
    final normalised = email.toLowerCase().trim();
    final existing = await _findByEmail(normalised);
    if (existing != null) return null;

    final id = await _db.insert(AppDatabase.parentsTable, {
      'email': normalised,
      'password_hash': _hash('$normalised:$password'),
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
    return ParentEntity(
      id: id,
      email: normalised,
      hasPin: false,
      createdAt: DateTime.now(),
    );
  }

  Future<ParentEntity?> login({
    required String email,
    required String password,
  }) async {
    final normalised = email.toLowerCase().trim();
    final rows = await _db.query(
      AppDatabase.parentsTable,
      where: 'email = ? AND password_hash = ?',
      whereArgs: [normalised, _hash('$normalised:$password')],
    );
    if (rows.isEmpty) return null;
    return ParentEntity.fromRow(rows.first);
  }

  Future<ParentEntity?> findById(int id) async {
    final rows = await _db.query(
      AppDatabase.parentsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (rows.isEmpty) return null;
    return ParentEntity.fromRow(rows.first);
  }

  Future<ParentEntity?> _findByEmail(String normalisedEmail) async {
    final rows = await _db.query(
      AppDatabase.parentsTable,
      where: 'email = ?',
      whereArgs: [normalisedEmail],
    );
    if (rows.isEmpty) return null;
    return ParentEntity.fromRow(rows.first);
  }

  Future<bool> setPin({required int parentId, required String pin}) async {
    final count = await _db.update(
      AppDatabase.parentsTable,
      {'pin_hash': _hash(pin)},
      where: 'id = ?',
      whereArgs: [parentId],
    );
    return count > 0;
  }

  Future<bool> verifyPin({required int parentId, required String pin}) async {
    final rows = await _db.query(
      AppDatabase.parentsTable,
      where: 'id = ? AND pin_hash = ?',
      whereArgs: [parentId, _hash(pin)],
    );
    return rows.isNotEmpty;
  }

  Future<bool> changePassword({
    required int parentId,
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    final normalised = email.toLowerCase().trim();
    final rows = await _db.query(
      AppDatabase.parentsTable,
      where: 'id = ? AND password_hash = ?',
      whereArgs: [parentId, _hash('$normalised:$oldPassword')],
    );
    if (rows.isEmpty) return false;
    await _db.update(
      AppDatabase.parentsTable,
      {'password_hash': _hash('$normalised:$newPassword')},
      where: 'id = ?',
      whereArgs: [parentId],
    );
    return true;
  }
}
