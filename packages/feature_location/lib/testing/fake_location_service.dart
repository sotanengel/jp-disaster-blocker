import 'dart:async';

import 'package:core/core.dart';
import 'package:feature_location/feature_location.dart';

final class FakeLocationService implements LocationService {
  FakeLocationService({
    LocationData? initialLocation,
    bool permissionGranted = true,
  })  : _location = initialLocation ??
            const LocationData(latitude: 35.6762, longitude: 139.6503),
        _permissionGranted = permissionGranted;

  LocationData _location;
  bool _permissionGranted;
  final _controller = StreamController<Result<LocationData, AppException>>.broadcast();

  void updateLocation(LocationData data) {
    _location = data;
    _controller.add(Ok(data));
  }

  void emitError(AppException error) => _controller.add(Err(error));

  @override
  Future<Result<LocationData, AppException>> getCurrentLocation() async =>
      Ok(_location);

  @override
  Stream<Result<LocationData, AppException>> get locationStream =>
      _controller.stream;

  @override
  Future<bool> get isPermissionGranted async => _permissionGranted;

  @override
  Future<Result<void, AppException>> requestPermission() async {
    _permissionGranted = true;
    return const Ok(null);
  }

  void dispose() => _controller.close();
}
