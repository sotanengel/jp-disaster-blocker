import 'package:flutter_test/flutter_test.dart';
import 'package:infra_storage/infra_storage.dart';
import 'package:infra_storage/testing/fake_database.dart';

void _contractTests(AppDatabase Function() factory) {
  late AppDatabase db;

  setUp(() async {
    db = factory();
    await db.open();
  });

  tearDown(() async => db.close());

  test('insert and query', () async {
    await db.insert('items', {'name': 'test', 'value': 42});
    final rows = await db.query('items');
    expect(rows, hasLength(1));
    expect(rows.first['name'], 'test');
  });

  test('nearbyQuery returns Ok', () async {
    await db.insert('shelters', {'lat': 35.0, 'lng': 139.0, 'name': 'A'});
    final result = await db.nearbyQuery(
      table: 'shelters',
      lat: 35.0,
      lng: 139.0,
      radiusKm: 5,
    );
    expect(result.isOk, isTrue);
  });
}

void main() {
  group('FakeDatabase contract', () {
    _contractTests(FakeDatabase.new);
  });
}
