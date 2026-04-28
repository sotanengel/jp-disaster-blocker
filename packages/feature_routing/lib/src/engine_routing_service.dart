import 'package:core/core.dart';
import 'package:infra_routing_engine/infra_routing_engine.dart';

import 'routing_service.dart';

final class EngineRoutingService implements RoutingService {
  const EngineRoutingService(this._engine);

  final RoutingEngine _engine;

  @override
  Future<Result<RouteResult, AppException>> findRoutes(
    RouteRequest request,
  ) async {
    if (!_engine.isInitialized) {
      return Err(AppException('Routing engine not initialized'));
    }
    return _engine.calculate(
      origin: RoutePoint(request.originLat, request.originLng),
      destination: RoutePoint(request.destLat, request.destLng),
      profiles: request.profiles,
    );
  }
}
