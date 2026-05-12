import 'package:flutter_test/flutter_test.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/module_progress_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;
  late ModuleProgressRepository repo;

  setUp(() async {
    db = await AppDatabase.instance.openInMemory();
    repo = ModuleProgressRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('recordQuizResult aggregates completed and total', () async {
    await repo.recordQuizResult(
      childId: 1,
      module: 'alphabet',
      score: 4,
      total: 5,
    );
    await repo.recordQuizResult(
      childId: 1,
      module: 'alphabet',
      score: 5,
      total: 5,
    );
    final p = await repo.get(childId: 1, module: 'alphabet');
    expect(p, isNotNull);
    expect(p!.completedItems, 9);
    expect(p.totalItems, 10);
    expect(p.bestScore, 5);
  });

  test('overallPercentage is 0 when no records', () async {
    expect(await repo.overallPercentage(1), 0);
  });

  test('overallPercentage sums across modules', () async {
    await repo.recordQuizResult(
      childId: 1,
      module: 'alphabet',
      score: 5,
      total: 10,
    );
    await repo.recordQuizResult(
      childId: 1,
      module: 'numbers',
      score: 5,
      total: 10,
    );
    expect(await repo.overallPercentage(1), closeTo(50, 0.001));
  });
}
