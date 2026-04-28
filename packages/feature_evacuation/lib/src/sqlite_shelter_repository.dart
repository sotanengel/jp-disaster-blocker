import 'dart:math';

import 'package:core/core.dart';
import 'package:infra_storage/infra_storage.dart';

import 'disaster_type.dart';
import 'shelter.dart';
import 'shelter_repository.dart';

final class SqliteShelterRepository implements ShelterRepository {
  const SqliteShelterRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Result<List<Shelter>, AppException>> findNearby({
    required double lat,
    required double lng,
    double radiusKm = 5,
    int limit = 50,
    List<DisasterType> filterTypes = const [],
  }) async {
    try {
      final result = await _db.nearbyQuery(
        table: 'shelters',
        lat: lat,
        lng: lng,
        radiusKm: radiusKm,
        limit: limit,
      );
      return result.map((rows) {
        var shelters = rows.map(Shelter.fromMap).toList();
        if (filterTypes.isNotEmpty) {
          shelters = shelters
              .where((s) => s.disasterTypes.any(filterTypes.contains))
              .toList();
        }
        shelters.sort((a, b) {
          final da = _distance(lat, lng, a.latitude, a.longitude);
          final db = _distance(lat, lng, b.latitude, b.longitude);
          return da.compareTo(db);
        });
        return shelters;
      });
    } on Exception catch (e) {
      return Err(AppException('findNearby failed', cause: e));
    }
  }

  @override
  Future<Result<Shelter, AppException>> findById(int id) async {
    try {
      final rows = await _db.query(
        'shelters',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (rows.isEmpty) {
        return Err(AppException('Shelter $id not found'));
      }
      return Ok(Shelter.fromMap(rows.first));
    } on Exception catch (e) {
      return Err(AppException('findById failed', cause: e));
    }
  }

  @override
  Future<Result<void, AppException>> upsertAll(List<Shelter> shelters) async {
    try {
      for (final s in shelters) {
        await _db.execute(
          '''
          INSERT OR REPLACE INTO shelters (id, name, lat, lng, address, disaster_types, capacity)
          VALUES (?, ?, ?, ?, ?, ?, ?)
          ''',
          [
            s.id,
            s.name,
            s.latitude,
            s.longitude,
            s.address,
            s.disasterTypes.map((t) => t.name).join(','),
            s.capacity,
          ],
        );
        await _db.execute(
          '''
          INSERT OR REPLACE INTO shelters_rtree (id, min_lat, max_lat, min_lng, max_lng)
          VALUES (?, ?, ?, ?, ?)
          ''',
          [s.id, s.latitude, s.latitude, s.longitude, s.longitude],
        );
      }
      return const Ok(null);
    } on Exception catch (e) {
      return Err(AppException('upsertAll failed', cause: e));
    }
  }

  double _distance(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371.0;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLng = (lng2 - lng1) * pi / 180;
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLng / 2) *
            sin(dLng / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }
}
