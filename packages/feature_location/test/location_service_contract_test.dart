import 'package:core/core.dart';
import 'package:feature_location/feature_location.dart';
import 'package:feature_location/testing/fake_location_service.dart';
import 'package:flutter_test/flutter_test.dart';

void _contractTests(LocationService Function() factory) {
  late LocationService service;

  setUp(() => service = factory());

  test('getCurrentLocation returns Ok with latitude/longitude', () async {
    final result = await service.getCurrentLocation();
    expect(result.isOk, isTrue);
    final data = (result as Ok<LocationData, AppException>).value;
    expect(data.latitude, isNotNaN);
    expect(data.longitude, isNotNaN);
  });

  test('isPermissionGranted returns bool', () async {
    final granted = await service.isPermissionGranted;
    expect(granted, isA<bool>());
  });

  test('requestPermission returns Ok', () async {
    final result = await service.requestPermission();
    expect(result.isOk, isTrue);
  });
}

void main() {
  group('FakeLocationService contract', () {
    _contractTests(FakeLocationService.new);
  });

  group('FakeLocationService streams location updates', () {
    test('updateLocation emits to locationStream', () async {
      final fake = FakeLocationService();
      final future = fake.locationStream.first;
      fake.updateLocation(const LocationData(latitude: 34.0, longitude: 135.0));
      final result = await future;
      expect(result.isOk, isTrue);
      final data = (result as Ok<LocationData, AppException>).value;
      expect(data.latitude, 34.0);
      fake.dispose();
    });
  });
}
