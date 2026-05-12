import 'package:flutter_test/flutter_test.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/rewards_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;
  late RewardsRepository repo;

  setUp(() async {
    db = await AppDatabase.instance.openInMemory();
    repo = RewardsRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('empty snapshot when child has no rewards', () async {
    final snap = await repo.getFor(1);
    expect(snap.stars, 0);
    expect(snap.coins, 0);
  });

  test('award accumulates stars and coins', () async {
    await repo.award(childId: 1, stars: 2, coins: 10);
    final next = await repo.award(childId: 1, stars: 3, coins: 5);
    expect(next.stars, 5);
    expect(next.coins, 15);
  });

  test('awards are scoped per child', () async {
    await repo.award(childId: 1, stars: 4);
    await repo.award(childId: 2, stars: 7);
    expect((await repo.getFor(1)).stars, 4);
    expect((await repo.getFor(2)).stars, 7);
  });
}
