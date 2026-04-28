// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:infra_routing_engine/infra_routing_engine.dart';

class RouteInfoCard extends StatelessWidget {
  const RouteInfoCard({required this.path, super.key});

  final RoutePath path;

  @override
  Widget build(BuildContext context) {
    final distanceText = '${path.distanceKm.toStringAsFixed(1)} km';
    final durationText = '${path.durationMinutes.toInt()} 分';

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _ProfileBadge(profile: path.profile),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    path.profile.label,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$distanceText · $durationText',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileBadge extends StatelessWidget {
  const _ProfileBadge({required this.profile});

  final RouteProfile profile;

  static Color _color(RouteProfile p) => switch (p) {
        RouteProfile.shortest => const Color(0xFF1565C0),
        RouteProfile.lessSlope => const Color(0xFF2E7D32),
        RouteProfile.floodAvoid => const Color(0xFFE65100),
      };

  static IconData _icon(RouteProfile p) => switch (p) {
        RouteProfile.shortest => Icons.bolt,
        RouteProfile.lessSlope => Icons.terrain,
        RouteProfile.floodAvoid => Icons.water_drop,
      };

  @override
  Widget build(BuildContext context) {
    final color = _color(profile);
    return CircleAvatar(
      backgroundColor: color.withAlpha(30),
      radius: 20,
      child: Icon(_icon(profile), color: color, size: 20),
    );
  }
}
