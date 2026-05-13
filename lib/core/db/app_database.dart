import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const _dbName = 'kids_app.db';
  static const _dbVersion = 5;

  static const favoritesTable = 'favorites';
  static const quizScoresTable = 'quiz_scores';
  static const parentsTable = 'parents';
  static const childrenTable = 'children';
  static const learningSessionsTable = 'learning_sessions';
  static const dailyUsageTable = 'daily_usage';
  static const screenTimeLimitsTable = 'screen_time_limits';
  static const rewardsTable = 'rewards';
  static const badgesTable = 'badges';
  static const moduleProgressTable = 'module_progress';
  static const streaksTable = 'streaks';
  static const moduleLocksTable = 'module_locks';

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
        onUpgrade: _onUpgrade,
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
    await _createV1Tables(db);
    await _createV2Tables(db);
    await _createV3Tables(db);
    await _migrateV4(db);
    await _createV5Tables(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createV2Tables(db);
      await db.execute(
        'ALTER TABLE $quizScoresTable ADD COLUMN child_id INTEGER',
      );
    }
    if (oldVersion < 3) {
      await _createV3Tables(db);
    }
    if (oldVersion < 4) {
      await _migrateV4(db);
    }
    if (oldVersion < 5) {
      await _createV5Tables(db);
    }
  }

  Future<void> _createV1Tables(Database db) async {
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
        completed_at INTEGER NOT NULL,
        child_id     INTEGER
      )
    ''');
  }

  Future<void> _createV2Tables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $parentsTable (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        email         TEXT    NOT NULL UNIQUE,
        password_hash TEXT    NOT NULL,
        pin_hash      TEXT,
        created_at    INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $childrenTable (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        parent_id    INTEGER NOT NULL,
        name         TEXT    NOT NULL,
        avatar_index INTEGER NOT NULL DEFAULT 0,
        level        TEXT    NOT NULL DEFAULT 'easy',
        created_at   INTEGER NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $learningSessionsTable (
        id               INTEGER PRIMARY KEY AUTOINCREMENT,
        child_id         INTEGER NOT NULL,
        module           TEXT    NOT NULL,
        started_at       INTEGER NOT NULL,
        ended_at         INTEGER,
        duration_seconds INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $dailyUsageTable (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        child_id     INTEGER NOT NULL,
        date_key     TEXT    NOT NULL,
        used_seconds INTEGER NOT NULL DEFAULT 0,
        UNIQUE(child_id, date_key)
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $screenTimeLimitsTable (
        id                  INTEGER PRIMARY KEY AUTOINCREMENT,
        child_id            INTEGER NOT NULL UNIQUE,
        daily_limit_seconds INTEGER NOT NULL DEFAULT 3600
      )
    ''');
  }

  Future<void> _createV3Tables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $rewardsTable (
        id        INTEGER PRIMARY KEY AUTOINCREMENT,
        child_id  INTEGER NOT NULL UNIQUE,
        stars     INTEGER NOT NULL DEFAULT 0,
        coins     INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $badgesTable (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        child_id   INTEGER NOT NULL,
        badge_key  TEXT    NOT NULL,
        earned_at  INTEGER NOT NULL,
        UNIQUE(child_id, badge_key)
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $moduleProgressTable (
        id               INTEGER PRIMARY KEY AUTOINCREMENT,
        child_id         INTEGER NOT NULL,
        module           TEXT    NOT NULL,
        completed_items  INTEGER NOT NULL DEFAULT 0,
        total_items      INTEGER NOT NULL DEFAULT 0,
        best_score       INTEGER NOT NULL DEFAULT 0,
        updated_at       INTEGER NOT NULL,
        UNIQUE(child_id, module)
      )
    ''');
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $streaksTable (
        id                INTEGER PRIMARY KEY AUTOINCREMENT,
        child_id          INTEGER NOT NULL UNIQUE,
        current_streak    INTEGER NOT NULL DEFAULT 0,
        longest_streak    INTEGER NOT NULL DEFAULT 0,
        last_activity_day TEXT
      )
    ''');
  }

  Future<void> _createV5Tables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $moduleLocksTable (
        child_id   INTEGER NOT NULL,
        module_key TEXT NOT NULL,
        PRIMARY KEY (child_id, module_key)
      )
    ''');
  }

  Future<void> _migrateV4(Database db) async {
    final cols = await db.rawQuery('PRAGMA table_info($parentsTable)');
    final names = cols.map((c) => c['name'] as String).toSet();
    if (!names.contains('firebase_uid')) {
      await db.execute(
        'ALTER TABLE $parentsTable ADD COLUMN firebase_uid TEXT',
      );
      await db.execute(
        'CREATE UNIQUE INDEX IF NOT EXISTS idx_parents_firebase_uid '
        'ON $parentsTable(firebase_uid)',
      );
    }
    if (!names.contains('provider')) {
      await db.execute(
        "ALTER TABLE $parentsTable ADD COLUMN provider TEXT NOT NULL DEFAULT 'password'",
      );
    }
    if (!names.contains('display_name')) {
      await db.execute(
        'ALTER TABLE $parentsTable ADD COLUMN display_name TEXT',
      );
    }
    if (!names.contains('photo_url')) {
      await db.execute(
        'ALTER TABLE $parentsTable ADD COLUMN photo_url TEXT',
      );
    }
  }

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

  void debugOverrideForTest(Database db) {
    _db = db;
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
