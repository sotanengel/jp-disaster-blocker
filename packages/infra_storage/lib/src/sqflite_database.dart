import 'dart:math';

import 'package:core/core.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'database.dart';
import 'migrations/v1_initial.dart';

final class SqfliteDatabase implements AppDatabase {
  SqfliteDatabase({required this.dbPath});

  final String dbPath;
  Database? _db;

  @override
  Future<void> open() async {
    final path = p.join(await getDatabasesPath(), dbPath);
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, _) async {
        for (final stmt in v1Initial.split(';').where((s) => s.trim().isNotEmpty)) {
          await db.execute('$stmt;');
        }
      },
    );
  }

  @override
  Future<void> close() async => _db?.close();

  @override
  Future<void> execute(String sql, [List<Object?> args = const []]) async =>
      _db!.execute(sql, args);

  @override
  Future<List<Map<String, Object?>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
  }) =>
      _db!.query(table,
          where: where,
          whereArgs: whereArgs,
          orderBy: orderBy,
          limit: limit);

  @override
  Future<int> insert(String table, Map<String, Object?> values) =>
      _db!.insert(table, values);

  @override
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  }) =>
      _db!.update(table, values, where: where, whereArgs: whereArgs);

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) =>
      _db!.delete(table, where: where, whereArgs: whereArgs);

  @override
  Future<List<Map<String, Object?>>> rawQuery(
    String sql, [
    List<Object?> args = const [],
  ]) =>
      _db!.rawQuery(sql, args);

  @override
  Future<Result<List<Map<String, Object?>>, AppException>> nearbyQuery({
    required String table,
    required double lat,
    required double lng,
    required double radiusKm,
    int limit = 50,
  }) async {
    try {
      // Approximate degree delta for the bounding box
      const kmPerDegLat = 111.0;
      final latDelta = radiusKm / kmPerDegLat;
      final lngDelta = radiusKm / (kmPerDegLat * cos(lat * pi / 180));

      final rtreeTable = '${table}_rtree';
      final rows = await _db!.rawQuery('''
        SELECT s.*
        FROM $table s
        JOIN $rtreeTable r ON r.id = s.id
        WHERE r.min_lat >= ? AND r.max_lat <= ?
          AND r.min_lng >= ? AND r.max_lng <= ?
        LIMIT ?
      ''', [
        lat - latDelta,
        lat + latDelta,
        lng - lngDelta,
        lng + lngDelta,
        limit,
      ]);
      return Ok(rows);
    } on Exception catch (e) {
      return Err(AppException('nearbyQuery failed', cause: e));
    }
  }
}
