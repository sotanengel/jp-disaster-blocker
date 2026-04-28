import 'package:feature_location/feature_location.dart';
import 'package:latlong2/latlong.dart';

abstract interface class AppMapController {
  LatLng get center;
  double get zoom;
  Future<void> moveTo(LocationData location);
  Future<void> animateTo(LatLng target, {double? zoom});
}
