import 'package:flutter_test/flutter_test.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/quiz_scores_repository.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  late Database db;
  late QuizScoresRepository repo;

  setUp(() async {
    db = await AppDatabase.instance.openInMemory();
    repo = QuizScoresRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('record and read latest', () async {
    await repo.record(category: 'alphabet', score: 8, total: 10);
    final latest = await repo.latestFor('alphabet');
    expect(latest, isNotNull);
    expect(latest!.score, 8);
    expect(latest.total, 10);
  });

  test('bestScoreFor returns max', () async {
    await repo.record(category: 'numbers', score: 5, total: 10);
    await repo.record(category: 'numbers', score: 9, total: 10);
    await repo.record(category: 'numbers', score: 7, total: 10);
    expect(await repo.bestScoreFor('numbers'), 9);
  });

  test('bestScoreFor returns null for unknown category', () async {
    expect(await repo.bestScoreFor('shapes'), isNull);
  });

  test('history is bounded and ordered newest first', () async {
    for (var i = 0; i < 5; i++) {
      await repo.record(category: 'colors', score: i, total: 10);
      await Future<void>.delayed(const Duration(milliseconds: 2));
    }
    final h = await repo.history(limit: 3);
    expect(h, hasLength(3));
    expect(h.first.score, 4);
  });
}
