import 'package:core/core.dart';
import 'package:feature_routing/feature_routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infra_routing_engine/infra_routing_engine.dart';

import 'providers.dart';

/// 徒歩ルート候補（スタブ GraphHopper）の表示。UI はアプリ層にのみ置く。
class RoutePage extends ConsumerStatefulWidget {
  const RoutePage({super.key});

  @override
  ConsumerState<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends ConsumerState<RoutePage> {
  bool _loading = false;
  String? _error;
  List<RoutePath>? _paths;

  Future<void> _compute() async {
    setState(() {
      _loading = true;
      _error = null;
      _paths = null;
    });

    final pos = await ref.read(effectiveLocationProvider.future);
    final routing = await ref.read(routingServiceProvider.future);

    // デモ用: 北東へ約 1.1 km の仮想目的地
    const destOffsetLat = 0.01;
    const destOffsetLng = 0.01;

    final result = await routing.findRoutes(
      RouteRequest(
        originLat: pos.lat,
        originLng: pos.lng,
        destLat: pos.lat + destOffsetLat,
        destLng: pos.lng + destOffsetLng,
      ),
    );

    if (!mounted) return;

    switch (result) {
      case Ok(:final value):
        setState(() {
          _paths = value;
          _loading = false;
        });
      case Err(:final error):
        setState(() {
          _error = error.message;
          _loading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('徒歩ルート（オフライン）')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: _loading ? null : _compute,
              icon: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.directions_walk),
              label: Text(_loading ? '計算中…' : '候補を計算'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (_paths != null) ...[
              const SizedBox(height: 16),
              Text(
                '候補（スタブエンジン）',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: _paths!.length,
                  itemBuilder: (context, i) {
                    final p = _paths![i];
                    return Card(
                      child: ListTile(
                        title: Text(p.profile.label),
                        subtitle: Text(
                          '${p.distanceKm.toStringAsFixed(2)} km · '
                          '${p.durationMinutes.round()} 分（目安）',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
