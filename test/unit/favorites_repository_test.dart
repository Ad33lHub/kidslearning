import 'package:flutter_test/flutter_test.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/favorites_repository.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  late Database db;
  late FavoritesRepository repo;

  setUp(() async {
    db = await AppDatabase.instance.openInMemory();
    repo = FavoritesRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('add then isFavorite returns true', () async {
    await repo.add('animals', 'lion');
    expect(await repo.isFavorite('animals', 'lion'), isTrue);
  });

  test('add is idempotent on (category, item_key)', () async {
    await repo.add('animals', 'lion');
    await repo.add('animals', 'lion');
    final all = await repo.listByCategory('animals');
    expect(all, hasLength(1));
  });

  test('remove deletes the row', () async {
    await repo.add('animals', 'lion');
    await repo.remove('animals', 'lion');
    expect(await repo.isFavorite('animals', 'lion'), isFalse);
  });

  test('listByCategory returns newest first', () async {
    await repo.add('animals', 'cat');
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await repo.add('animals', 'dog');
    final rows = await repo.listByCategory('animals');
    expect(rows.map((r) => r.itemKey).toList(), ['dog', 'cat']);
  });
}
