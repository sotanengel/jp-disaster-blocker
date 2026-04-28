import 'package:core/core.dart';

abstract interface class AppDatabase {
  Future<void> open();
  Future<void> close();
  Future<void> execute(String sql, [List<Object?> args = const []]);
  Future<List<Map<String, Object?>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
  });
  Future<int> insert(String table, Map<String, Object?> values);
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  });
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  });
  Future<List<Map<String, Object?>>> rawQuery(
    String sql, [
    List<Object?> args = const [],
  ]);
  Future<Result<List<Map<String, Object?>>, AppException>> nearbyQuery({
    required String table,
    required double lat,
    required double lng,
    required double radiusKm,
    int limit = 50,
  });
}
