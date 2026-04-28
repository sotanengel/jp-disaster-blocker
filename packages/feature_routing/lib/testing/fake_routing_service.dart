import 'package:core/core.dart';
import 'package:feature_routing/feature_routing.dart';
import 'package:infra_routing_engine/infra_routing_engine.dart';

final class FakeRoutingService implements RoutingService {
  FakeRoutingService({this.failWith});

  final AppException? failWith;

  @override
  Future<Result<RouteResult, AppException>> findRoutes(
    RouteRequest request,
  ) async {
    if (failWith != null) return Err(failWith!);
    final paths = request.profiles
        .map((p) => RoutePath(
              points: [
                RoutePoint(request.originLat, request.originLng),
                RoutePoint(request.destLat, request.destLng),
              ],
              distanceKm: 1.0,
              durationMinutes: 15,
              profile: p,
            ))
        .toList();
    return Ok(paths);
  }
}
