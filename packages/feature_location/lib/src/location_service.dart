import 'package:core/core.dart';

class LocationData {
  const LocationData({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.altitude,
  });

  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? altitude;
}

abstract interface class LocationService {
  Future<Result<LocationData, AppException>> getCurrentLocation();
  Stream<Result<LocationData, AppException>> get locationStream;
  Future<bool> get isPermissionGranted;
  Future<Result<void, AppException>> requestPermission();
}
