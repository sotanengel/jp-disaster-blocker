import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_pmtiles/flutter_map_pmtiles.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    super.key,
    this.initialCenter = const LatLng(35.6762, 139.6503),
    this.initialZoom = 13,
    this.layers = const [],
    this.tileProvider,
  });

  final LatLng initialCenter;
  final double initialZoom;
  final List<Widget> layers;

  /// Pre-initialized PMTiles tile provider. Use [PmTilesTileProvider.fromSource]
  /// to construct from an asset path or URL.
  final PmTilesTileProvider? tileProvider;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: widget.initialCenter,
        initialZoom: widget.initialZoom,
      ),
      children: [
        if (widget.tileProvider != null)
          TileLayer(tileProvider: widget.tileProvider)
        else
          // PMTiles 未指定時は視認性確保のため OSM を表示（本番は [tileProvider] に県タイルを渡す）
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'jp_disaster_blocker',
          ),
        ...widget.layers,
      ],
    );
  }
}
