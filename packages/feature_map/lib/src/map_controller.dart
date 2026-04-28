import 'package:latlong2/latlong.dart';

abstract interface class AppMapController {
  LatLng get center;
  double get zoom;

  /// Moves the map center to [target]. Uses [LatLng] only so [feature_map]
  /// stays independent of [feature_location] (monorepo dependency rules).
  Future<void> moveTo(LatLng target);
  Future<void> animateTo(LatLng target, {double? zoom});
}
