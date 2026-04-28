// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:feature_routing/src/route_info_card.dart';
import 'package:infra_routing_engine/infra_routing_engine.dart';

class RouteSelectorSheet extends StatelessWidget {
  const RouteSelectorSheet({
    required this.paths,
    required this.selectedProfile,
    required this.onProfileSelected,
    super.key,
  });

  final List<RoutePath> paths;
  final RouteProfile selectedProfile;
  final ValueChanged<RouteProfile> onProfileSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'ルートを選択',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ...paths.map((path) {
          final isSelected = path.profile == selectedProfile;
          return InkWell(
            onTap: () => onProfileSelected(path.profile),
            child: Container(
              decoration: isSelected
                  ? BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withAlpha(80),
                      border: Border(
                        left: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 3,
                        ),
                      ),
                    )
                  : null,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: RouteInfoCard(path: path),
            ),
          );
        }),
        const SizedBox(height: 16),
      ],
    );
  }

  static Future<RouteProfile?> show(
    BuildContext context, {
    required List<RoutePath> paths,
    required RouteProfile selectedProfile,
  }) {
    return showModalBottomSheet<RouteProfile>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        RouteProfile current = selectedProfile;
        return StatefulBuilder(
          builder: (ctx, setState) => RouteSelectorSheet(
            paths: paths,
            selectedProfile: current,
            onProfileSelected: (p) {
              setState(() => current = p);
              Navigator.of(ctx).pop(p);
            },
          ),
        );
      },
    );
  }
}
