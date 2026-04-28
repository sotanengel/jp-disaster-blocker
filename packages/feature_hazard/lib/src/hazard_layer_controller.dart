import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

import 'hazard_type.dart';

abstract interface class HazardLayerController {
  Set<HazardType> get activeTypes;
  Future<Result<void, AppException>> toggle(HazardType type);
  Widget buildLayers();
}
