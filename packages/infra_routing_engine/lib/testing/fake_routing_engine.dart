import 'package:core/core.dart';
import 'package:infra_routing_engine/infra_routing_engine.dart';

final class FakeRoutingEngine implements RoutingEngine {
  FakeRoutingEngine({bool startInitialized = true})
      : _initialized = startInitialized;

  bool _initialized;

  @override
  bool get isInitialized => _initialized;

  @override
  Future<Result<void, AppException>> initialize(String graphPath) async {
    _initialized = true;
    return const Ok(null);
  }

  @override
  Future<Result<List<RoutePath>, AppException>> calculate({
    required RoutePoint origin,
    required RoutePoint destination,
    List<RouteProfile> profiles = RouteProfile.values,
  }) async {
    if (!_initialized) {
      return Err(AppException('FakeRoutingEngine not initialized'));
    }
    final paths = profiles
        .map((p) => RoutePath(
              points: [origin, destination],
              distanceKm: 1.0,
              durationMinutes: 15,
              profile: p,
            ))
        .toList();
    return Ok(paths);
  }
}
