import 'package:core/core.dart';
import 'package:geolocator/geolocator.dart';

import 'location_service.dart';

final class GeolocatorLocationService implements LocationService {
  @override
  Future<Result<LocationData, AppException>> getCurrentLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      return Ok(LocationData(
        latitude: pos.latitude,
        longitude: pos.longitude,
        accuracy: pos.accuracy,
        altitude: pos.altitude,
      ));
    } on Exception catch (e) {
      return Err(AppException('Failed to get location', cause: e));
    }
  }

  @override
  Stream<Result<LocationData, AppException>> get locationStream =>
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).map(
        (pos) => Ok(LocationData(
          latitude: pos.latitude,
          longitude: pos.longitude,
          accuracy: pos.accuracy,
          altitude: pos.altitude,
        )),
      );

  @override
  Future<bool> get isPermissionGranted async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  @override
  Future<Result<void, AppException>> requestPermission() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return const Ok(null);
    }
    return Err(AppException('Location permission denied: $permission'));
  }
}
