import 'package:core/core.dart';

class RoutePoint {
  const RoutePoint(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}

class RoutePath {
  const RoutePath({
    required this.points,
    required this.distanceKm,
    required this.durationMinutes,
    required this.profile,
  });

  final List<RoutePoint> points;
  final double distanceKm;
  final double durationMinutes;
  final RouteProfile profile;
}

enum RouteProfile {
  shortest('最短'),
  lessSlope('坂少'),
  floodAvoid('浸水回避');

  const RouteProfile(this.label);

  final String label;
}

abstract interface class RoutingEngine {
  Future<Result<List<RoutePath>, AppException>> calculate({
    required RoutePoint origin,
    required RoutePoint destination,
    List<RouteProfile> profiles = RouteProfile.values,
  });

  Future<Result<void, AppException>> initialize(String graphPath);
  bool get isInitialized;
}
