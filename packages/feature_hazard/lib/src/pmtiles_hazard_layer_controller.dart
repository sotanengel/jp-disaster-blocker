import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_pmtiles/flutter_map_pmtiles.dart';

import 'hazard_layer_controller.dart';
import 'hazard_type.dart';

final class PmTilesHazardLayerController
    with ChangeNotifier
    implements HazardLayerController {
  PmTilesHazardLayerController();

  final _active = <HazardType, PmTilesTileProvider>{};

  @override
  Set<HazardType> get activeTypes => _active.keys.toSet();

  @override
  Future<Result<void, AppException>> toggle(HazardType type) async {
    if (_active.containsKey(type)) {
      _active.remove(type);
      notifyListeners();
      return const Ok(null);
    }
    try {
      final provider =
          await PmTilesTileProvider.fromSource(type.assetPath);
      _active[type] = provider;
      notifyListeners();
      return const Ok(null);
    } on Exception catch (e) {
      return Err(AppException('Failed to load hazard layer: ${type.name}', cause: e));
    }
  }

  @override
  Widget buildLayers() {
    return Stack(
      children: _active.entries
          .map(
            (entry) => Opacity(
              opacity: 0.6,
              child: TileLayer(tileProvider: entry.value),
            ),
          )
          .toList(),
    );
  }
}
