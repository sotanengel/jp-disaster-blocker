import 'package:core/core.dart';
import 'package:infra_routing_engine/infra_routing_engine.dart';
import 'package:infra_routing_engine/testing/fake_routing_engine.dart';
import 'package:test/test.dart';

const _origin = RoutePoint(35.6762, 139.6503);
const _dest = RoutePoint(35.6900, 139.7010);

void _contractTests(RoutingEngine Function() factory) {
  late RoutingEngine engine;

  setUp(() async {
    engine = factory();
    await engine.initialize('test_graph');
  });

  test('isInitialized is true after initialize()', () {
    expect(engine.isInitialized, isTrue);
  });

  test('calculate returns Ok with 3 route profiles', () async {
    final result = await engine.calculate(
      origin: _origin,
      destination: _dest,
    );
    expect(result.isOk, isTrue);
    final paths = (result as Ok<List<RoutePath>, AppException>).value;
    expect(paths, hasLength(RouteProfile.values.length));
  });

  test('returned profiles are distinct', () async {
    final result = await engine.calculate(
      origin: _origin,
      destination: _dest,
    );
    final paths = (result as Ok<List<RoutePath>, AppException>).value;
    final profiles = paths.map((p) => p.profile).toSet();
    expect(profiles.length, equals(RouteProfile.values.length));
  });

  test('calculate returns Err when not initialized', () async {
    final uninit = FakeRoutingEngine(startInitialized: false);
    final result = await uninit.calculate(
      origin: _origin,
      destination: _dest,
    );
    expect(result.isErr, isTrue);
  });
}

void main() {
  group('FakeRoutingEngine contract', () {
    _contractTests(FakeRoutingEngine.new);
  });

  group('GraphHopperEngine contract', () {
    _contractTests(GraphHopperEngine.new);
  });
}
