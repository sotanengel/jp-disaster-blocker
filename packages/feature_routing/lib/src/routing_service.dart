import 'package:core/core.dart';
import 'package:infra_routing_engine/infra_routing_engine.dart';

class RouteRequest {
  const RouteRequest({
    required this.originLat,
    required this.originLng,
    required this.destLat,
    required this.destLng,
    this.profiles = RouteProfile.values,
  });

  final double originLat;
  final double originLng;
  final double destLat;
  final double destLng;
  final List<RouteProfile> profiles;
}

typedef RouteResult = List<RoutePath>;

abstract interface class RoutingService {
  Future<Result<RouteResult, AppException>> findRoutes(RouteRequest request);
}
