import 'package:feature_routing/feature_routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infra_routing_engine/infra_routing_engine.dart';

void main() {
  group('RouteOverlayLayer', () {
    final paths = [
      RoutePath(
        points: [
          const RoutePoint(35.68, 139.70),
          const RoutePoint(35.69, 139.71),
        ],
        distanceKm: 1.5,
        durationMinutes: 18,
        profile: RouteProfile.shortest,
      ),
      RoutePath(
        points: [
          const RoutePoint(35.68, 139.70),
          const RoutePoint(35.685, 139.705),
          const RoutePoint(35.69, 139.71),
        ],
        distanceKm: 2.0,
        durationMinutes: 22,
        profile: RouteProfile.lessSlope,
      ),
    ];

    testWidgets('renders without throwing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                RouteOverlayLayer(
                  paths: paths,
                  selectedProfile: RouteProfile.shortest,
                ),
              ],
            ),
          ),
        ),
      );
      expect(find.byType(RouteOverlayLayer), findsOneWidget);
    });

    testWidgets('shows nothing when paths is empty', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                RouteOverlayLayer(
                  paths: const [],
                  selectedProfile: RouteProfile.shortest,
                ),
              ],
            ),
          ),
        ),
      );
      expect(find.byType(RouteOverlayLayer), findsOneWidget);
    });
  });

  group('RouteInfoCard', () {
    final path = RoutePath(
      points: [
        const RoutePoint(35.68, 139.70),
        const RoutePoint(35.69, 139.71),
      ],
      distanceKm: 1.5,
      durationMinutes: 18,
      profile: RouteProfile.shortest,
    );

    testWidgets('shows distance and duration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: RouteInfoCard(path: path))),
      );
      expect(find.textContaining('1.5'), findsWidgets);
      expect(find.textContaining('18'), findsWidgets);
    });

    testWidgets('shows profile label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: RouteInfoCard(path: path))),
      );
      expect(find.text(RouteProfile.shortest.label), findsOneWidget);
    });
  });

  group('RouteSelectorSheet', () {
    final paths = RouteProfile.values
        .map(
          (p) => RoutePath(
            points: [
              const RoutePoint(35.68, 139.70),
              const RoutePoint(35.69, 139.71),
            ],
            distanceKm: 1.0 + RouteProfile.values.indexOf(p),
            durationMinutes: 15 + RouteProfile.values.indexOf(p) * 3,
            profile: p,
          ),
        )
        .toList();

    testWidgets('shows all profiles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RouteSelectorSheet(
              paths: paths,
              selectedProfile: RouteProfile.shortest,
              onProfileSelected: (_) {},
            ),
          ),
        ),
      );
      for (final p in RouteProfile.values) {
        expect(find.text(p.label), findsOneWidget);
      }
    });

    testWidgets('calls onProfileSelected when tapped', (tester) async {
      RouteProfile? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RouteSelectorSheet(
              paths: paths,
              selectedProfile: RouteProfile.shortest,
              onProfileSelected: (p) => selected = p,
            ),
          ),
        ),
      );
      await tester.tap(find.text(RouteProfile.lessSlope.label));
      await tester.pump();
      expect(selected, RouteProfile.lessSlope);
    });
  });
}
