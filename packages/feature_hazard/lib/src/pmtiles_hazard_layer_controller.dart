import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_pmtiles/flutter_map_pmtiles.dart';
import 'package:pmtiles/pmtiles.dart';

import 'hazard_layer_controller.dart';
import 'hazard_type.dart';

final class PmTilesHazardLayerController extends ChangeNotifier
    implements HazardLayerController {
  PmTilesHazardLayerController();

  final _active = <HazardType, PmTilesTileProvider>{};

  @override
  Set<HazardType> get activeTypes => _active.keys.toSet();

  @override
  Future<Result<void, AppException>> toggle(HazardType type) async {
    if (_active.containsKey(type)) {
      final removed = _active.remove(type)!;
      await removed.archive.close();
      notifyListeners();
      return const Ok(null);
    }
    try {
      final byteData = await rootBundle.load(type.assetPath);
      final bytes = byteData.buffer.asUint8List();
      if (bytes.isEmpty) {
        return Err(
          AppException(
            '${type.label}: PMTiles が空です。'
            '`packages/feature_hazard/assets/hazard/` に有効な .pmtiles を配置してください。',
          ),
        );
      }
      final archive = await PmTilesArchive.fromBytes(bytes);
      final provider = PmTilesTileProvider.fromArchive(archive);
      _active[type] = provider;
      notifyListeners();
      return const Ok(null);
    } on FlutterError catch (e) {
      return Err(
        AppException(
          '${type.label}: アセットを読み込めませんでした（${type.assetPath}）。',
          cause: e,
        ),
      );
    } on Exception catch (e) {
      return Err(
        AppException(
          '${type.label}: PMTiles の読み込みに失敗しました。ファイル形式を確認してください。',
          cause: e,
        ),
      );
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

  @override
  void dispose() {
    for (final provider in _active.values) {
      unawaited(provider.archive.close());
    }
    _active.clear();
    super.dispose();
  }
}
