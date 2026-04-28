import 'package:core/core.dart';

import 'disaster_type.dart';
import 'shelter.dart';

abstract interface class ShelterRepository {
  Future<Result<List<Shelter>, AppException>> findNearby({
    required double lat,
    required double lng,
    double radiusKm = 5,
    int limit = 50,
    List<DisasterType> filterTypes = const [],
  });

  Future<Result<Shelter, AppException>> findById(int id);

  Future<Result<void, AppException>> upsertAll(List<Shelter> shelters);
}
