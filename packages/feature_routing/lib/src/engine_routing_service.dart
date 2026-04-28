// ignore_for_file: public_member_api_docs
import 'package:core/core.dart';
import 'package:feature_routing/src/routing_service.dart';
import 'package:infra_routing_engine/infra_routing_engine.dart';

final class EngineRoutingService implements RoutingService {
  const EngineRoutingService(this._engine);

  final RoutingEngine _engine;

  @override
  Future<Result<RouteResult, AppException>> findRoutes(
    RouteRequest request,
  ) async {
    if (!_engine.isInitialized) {
      return const Err(AppException('Routing engine not initialized'));
    }
    return _engine.calculate(
      origin: RoutePoint(request.originLat, request.originLng),
      destination: RoutePoint(request.destLat, request.destLng),
      profiles: request.profiles,
    );
  }
}
