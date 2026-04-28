import 'dart:math';

import 'package:core/core.dart';

import 'routing_engine.dart';

/// GraphHopper-based routing engine.
/// In production, this communicates with native GraphHopper via Pigeon/FFI.
/// The current implementation uses a stub that generates geometrically valid
/// mock routes until the native bridge is wired (PR-11-native).
final class GraphHopperEngine implements RoutingEngine {
  bool _initialized = false;

  @override
  bool get isInitialized => _initialized;

  @override
  Future<Result<void, AppException>> initialize(String graphPath) async {
    // Native bridge initialization would go here.
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
      return Err(AppException('RoutingEngine not initialized'));
    }
    try {
      final paths = profiles.map((p) => _mockPath(origin, destination, p)).toList();
      return Ok(paths);
    } on Exception catch (e) {
      return Err(AppException('Routing failed', cause: e));
    }
  }

  RoutePath _mockPath(RoutePoint o, RoutePoint d, RouteProfile profile) {
    final dist = _haversine(o.latitude, o.longitude, d.latitude, d.longitude);
    // Add profile-specific overhead
    final overhead = switch (profile) {
      RouteProfile.shortest => 1.0,
      RouteProfile.lessSlope => 1.1,
      RouteProfile.floodAvoid => 1.2,
    };
    return RoutePath(
      points: [o, d],
      distanceKm: dist * overhead,
      durationMinutes: (dist * overhead / 5) * 60, // ~5 km/h walking
      profile: profile,
    );
  }

  double _haversine(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371.0;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLng = (lng2 - lng1) * pi / 180;
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) * sin(dLng / 2) * sin(dLng / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }
}
