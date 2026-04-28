import 'package:core/core.dart';
import 'package:infra_storage/infra_storage.dart';

final class FakeDatabase implements AppDatabase {
  final _tables = <String, List<Map<String, Object?>>>{};
  var _nextId = 1;

  @override
  Future<void> open() async {}

  @override
  Future<void> close() async {}

  @override
  Future<void> execute(String sql, [List<Object?> args = const []]) async {}

  @override
  Future<List<Map<String, Object?>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
  }) async =>
      List.of(_tables[table] ?? []);

  @override
  Future<int> insert(String table, Map<String, Object?> values) async {
    final row = Map<String, Object?>.from(values)..['id'] ??= _nextId++;
    (_tables[table] ??= []).add(row);
    return row['id']! as int;
  }

  @override
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final rows = _tables[table] ?? [];
    for (var i = 0; i < rows.length; i++) {
      rows[i] = {...rows[i], ...values};
    }
    return rows.length;
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final before = (_tables[table] ?? []).length;
    _tables[table] = [];
    return before;
  }

  @override
  Future<List<Map<String, Object?>>> rawQuery(
    String sql, [
    List<Object?> args = const [],
  ]) async =>
      [];

  @override
  Future<Result<List<Map<String, Object?>>, AppException>> nearbyQuery({
    required String table,
    required double lat,
    required double lng,
    required double radiusKm,
    int limit = 50,
  }) async =>
      Ok(List.of(_tables[table] ?? []));
}
