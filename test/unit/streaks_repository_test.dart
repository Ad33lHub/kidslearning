import 'package:flutter_test/flutter_test.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/streaks_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Database db;
  late StreaksRepository repo;

  setUp(() async {
    db = await AppDatabase.instance.openInMemory();
    repo = StreaksRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('first activity yields streak of 1', () async {
    final snap = await repo.recordActivityToday(1);
    expect(snap.current, 1);
    expect(snap.longest, 1);
  });

  test('recording twice on same day does not change streak', () async {
    await repo.recordActivityToday(1);
    final snap = await repo.recordActivityToday(1);
    expect(snap.current, 1);
  });

  test('empty snapshot for unknown child', () async {
    final snap = await repo.getFor(99);
    expect(snap.current, 0);
    expect(snap.longest, 0);
  });
}
