import 'package:core/core.dart';
import 'package:feature_routing/feature_routing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infra_routing_engine/infra_routing_engine.dart';
import 'package:infra_routing_engine/testing/fake_routing_engine.dart';

void main() {
  group('EngineRoutingService', () {
    late RoutingService service;

    setUp(() async {
      final engine = FakeRoutingEngine();
      await engine.initialize('');
      service = EngineRoutingService(engine);
    });

    test('returns 3 routes for default profiles', () async {
      final result = await service.findRoutes(const RouteRequest(
        originLat: 35.68,
        originLng: 139.70,
        destLat: 35.69,
        destLng: 139.71,
      ));
      expect(result.isOk, isTrue);
      expect((result as Ok<RouteResult, AppException>).value,
          hasLength(RouteProfile.values.length));
    });

    test('returns Err when engine not initialized', () async {
      final uninit = FakeRoutingEngine(startInitialized: false);
      final uninitService = EngineRoutingService(uninit);
      final result = await uninitService.findRoutes(const RouteRequest(
        originLat: 35.68,
        originLng: 139.70,
        destLat: 35.69,
        destLng: 139.71,
      ));
      expect(result.isErr, isTrue);
    });

    test('all 3 profile types are present in results', () async {
      final result = await service.findRoutes(const RouteRequest(
        originLat: 35.68,
        originLng: 139.70,
        destLat: 35.69,
        destLng: 139.71,
      ));
      final paths = (result as Ok<RouteResult, AppException>).value;
      final profiles = paths.map((p) => p.profile).toSet();
      expect(profiles, containsAll(RouteProfile.values));
    });
  });
}
