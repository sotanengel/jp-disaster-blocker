import 'package:core/core.dart';
import 'package:feature_hazard/feature_hazard.dart';
import 'package:feature_map/feature_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'providers.dart';

/// 地図＋重ねるハザード（[PmTilesHazardLayerController]）。アプリ層で [feature_map] と
/// [feature_hazard] を合成する。
class MapTab extends ConsumerWidget {
  const MapTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hazard = ref.watch(hazardLayerControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: HazardType.values.map((type) {
                final selected = hazard.activeTypes.contains(type);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(type.label),
                    selected: selected,
                    onSelected: (_) async {
                      final r = await hazard.toggle(type);
                      if (!context.mounted) return;
                      switch (r) {
                        case Ok():
                          break;
                        case Err(:final error):
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.message)),
                          );
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'ハザードは PMTiles を重ねて表示します。同梱ファイルが無効な場合は Snackbar で通知されます。',
            style: TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: ListenableBuilder(
            listenable: hazard,
            builder: (context, _) {
              return MapPage(
                initialCenter: const LatLng(kDefaultLat, kDefaultLng),
                initialZoom: 13,
                layers: hazard.activeTypes.isEmpty
                    ? const []
                    : [hazard.buildLayers()],
              );
            },
          ),
        ),
      ],
    );
  }
}
