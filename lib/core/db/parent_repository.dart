import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app_database.dart';

class ParentEntity {
  final int id;
  final String email;
  final bool hasPin;
  final DateTime createdAt;
  final String? firebaseUid;
  final String provider;
  final String? displayName;
  final String? photoUrl;

  const ParentEntity({
    required this.id,
    required this.email,
    required this.hasPin,
    required this.createdAt,
    this.firebaseUid,
    this.provider = 'password',
    this.displayName,
    this.photoUrl,
  });

  factory ParentEntity.fromRow(Map<String, Object?> row) => ParentEntity(
        id: row['id'] as int,
        email: row['email'] as String,
        hasPin: row['pin_hash'] != null,
        createdAt: DateTime.fromMillisecondsSinceEpoch(
          row['created_at'] as int,
        ),
        firebaseUid: row['firebase_uid'] as String?,
        provider: (row['provider'] as String?) ?? 'password',
        displayName: row['display_name'] as String?,
        photoUrl: row['photo_url'] as String?,
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

  Future<ParentEntity> upsertFromFirebase({
    required String firebaseUid,
    required String email,
    required String provider,
    String? displayName,
    String? photoUrl,
  }) async {
    final normalised = email.toLowerCase().trim();

    final byUid = await _db.query(
      AppDatabase.parentsTable,
      where: 'firebase_uid = ?',
      whereArgs: [firebaseUid],
      limit: 1,
    );
    if (byUid.isNotEmpty) {
      await _db.update(
        AppDatabase.parentsTable,
        {
          'email': normalised,
          'provider': provider,
          if (displayName != null) 'display_name': displayName,
          if (photoUrl != null) 'photo_url': photoUrl,
        },
        where: 'id = ?',
        whereArgs: [byUid.first['id']],
      );
      return ParentEntity.fromRow({...byUid.first, 'email': normalised});
    }

    final byEmail = await _findByEmail(normalised);
    if (byEmail != null) {
      await _db.update(
        AppDatabase.parentsTable,
        {
          'firebase_uid': firebaseUid,
          'provider': provider,
          if (displayName != null) 'display_name': displayName,
          if (photoUrl != null) 'photo_url': photoUrl,
        },
        where: 'id = ?',
        whereArgs: [byEmail.id],
      );
      final row = await _db.query(
        AppDatabase.parentsTable,
        where: 'id = ?',
        whereArgs: [byEmail.id],
        limit: 1,
      );
      return ParentEntity.fromRow(row.first);
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final id = await _db.insert(AppDatabase.parentsTable, {
      'email': normalised,
      'password_hash': '',
      'firebase_uid': firebaseUid,
      'provider': provider,
      'display_name': displayName,
      'photo_url': photoUrl,
      'created_at': now,
    });
    return ParentEntity(
      id: id,
      email: normalised,
      hasPin: false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(now),
      firebaseUid: firebaseUid,
      provider: provider,
      displayName: displayName,
      photoUrl: photoUrl,
    );
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
