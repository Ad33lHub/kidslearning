import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Single SQLite database used by the app for favorites + quiz scores.
///
/// On Android/iOS this uses the default sqflite engine. On Windows/Linux
/// (and inside `flutter test`) it uses the sqflite_common_ffi FFI engine,
/// which is initialized lazily the first time [database] is read.
class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const _dbName = 'kids_app.db';
  static const _dbVersion = 1;

  static const favoritesTable = 'favorites';
  static const quizScoresTable = 'quiz_scores';

  Database? _db;
  bool _ffiInitialized = false;

  Future<Database> get database async {
    return _db ??= await _open();
  }

  Future<Database> _open() async {
    final factory = _selectFactory();
    final dbPath = await factory.getDatabasesPath();
    final path = p.join(dbPath, _dbName);
    return factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: _dbVersion,
        onCreate: _onCreate,
      ),
    );
  }

  DatabaseFactory _selectFactory() {
    if (kIsWeb) return databaseFactory;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      if (!_ffiInitialized) {
        sqfliteFfiInit();
        _ffiInitialized = true;
      }
      return databaseFactoryFfi;
    }
    return databaseFactory;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $favoritesTable (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        category  TEXT    NOT NULL,
        item_key  TEXT    NOT NULL,
        added_at  INTEGER NOT NULL,
        UNIQUE(category, item_key)
      )
    ''');
    await db.execute('''
      CREATE TABLE $quizScoresTable (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        category     TEXT    NOT NULL,
        score        INTEGER NOT NULL,
        total        INTEGER NOT NULL,
        completed_at INTEGER NOT NULL
      )
    ''');
  }

  /// Open an in-memory database for tests. Always uses the FFI factory.
  Future<Database> openInMemory() async {
    if (!_ffiInitialized) {
      sqfliteFfiInit();
      _ffiInitialized = true;
    }
    return databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: _dbVersion,
        onCreate: _onCreate,
      ),
    );
  }

  /// Test-only hook so callers can inject an in-memory database.
  void debugOverrideForTest(Database db) {
    _db = db;
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
