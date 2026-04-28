import 'dart:math';

import 'package:core/core.dart';
import 'package:feature_evacuation/feature_evacuation.dart';

final class FakeShelterRepository implements ShelterRepository {
  FakeShelterRepository({List<Shelter> initial = const []}) {
    _shelters.addAll({for (final s in initial) s.id: s});
  }

  final _shelters = <int, Shelter>{};

  @override
  Future<Result<List<Shelter>, AppException>> findNearby({
    required double lat,
    required double lng,
    double radiusKm = 5,
    int limit = 50,
    List<DisasterType> filterTypes = const [],
  }) async {
    var results = _shelters.values.where((s) {
      final d = _distance(lat, lng, s.latitude, s.longitude);
      return d <= radiusKm;
    }).toList();

    if (filterTypes.isNotEmpty) {
      results = results
          .where((s) => s.disasterTypes.any(filterTypes.contains))
          .toList();
    }
    results.sort((a, b) {
      final da = _distance(lat, lng, a.latitude, a.longitude);
      final db = _distance(lat, lng, b.latitude, b.longitude);
      return da.compareTo(db);
    });
    return Ok(results.take(limit).toList());
  }

  @override
  Future<Result<Shelter, AppException>> findById(int id) async {
    final s = _shelters[id];
    if (s == null) return Err(AppException('Shelter $id not found'));
    return Ok(s);
  }

  @override
  Future<Result<void, AppException>> upsertAll(List<Shelter> shelters) async {
    for (final s in shelters) {
      _shelters[s.id] = s;
    }
    return const Ok(null);
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
