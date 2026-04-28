import 'package:core/core.dart';
import 'package:feature_routing/feature_routing.dart';
import 'package:feature_routing/testing/fake_routing_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infra_routing_engine/infra_routing_engine.dart';
import 'package:infra_routing_engine/testing/fake_routing_engine.dart';

void main() {
  group('Offline routing integration', () {
    late RoutingService service;

    setUp(() async {
      final engine = FakeRoutingEngine();
      await engine.initialize('');
      service = EngineRoutingService(engine);
    });

    test('full offline roundtrip: request → 3 routes → select', () async {
      const request = RouteRequest(
        originLat: 35.6762,
        originLng: 139.6503,
        destLat: 35.6892,
        destLng: 139.6917,
      );

      final result = await service.findRoutes(request);
      expect(result.isOk, isTrue);

      final paths = (result as Ok<RouteResult, AppException>).value;
      expect(paths, hasLength(RouteProfile.values.length));

      final profiles = paths.map((p) => p.profile).toSet();
      expect(profiles, containsAll(RouteProfile.values));

      for (final path in paths) {
        expect(path.distanceKm, greaterThan(0));
        expect(path.durationMinutes, greaterThan(0));
        expect(path.points, isNotEmpty);
      }
    });

    test('FakeRoutingService returns configured profiles', () async {
      const request = RouteRequest(
        originLat: 35.68,
        originLng: 139.70,
        destLat: 35.69,
        destLng: 139.71,
        profiles: [RouteProfile.floodAvoid],
      );
      final fakeService = FakeRoutingService();
      final result = await fakeService.findRoutes(request);
      expect(result.isOk, isTrue);
      final paths = (result as Ok<RouteResult, AppException>).value;
      expect(paths, hasLength(1));
      expect(paths.first.profile, RouteProfile.floodAvoid);
    });

    test('FakeRoutingService returns Err when configured', () async {
      const request = RouteRequest(
        originLat: 35.68,
        originLng: 139.70,
        destLat: 35.69,
        destLng: 139.71,
      );
      final fakeService =
          FakeRoutingService(failWith: const AppException('offline'));
      final result = await fakeService.findRoutes(request);
      expect(result.isErr, isTrue);
    });
  });
}
