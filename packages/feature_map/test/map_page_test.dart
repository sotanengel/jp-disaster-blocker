import 'package:feature_map/feature_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('MapPage', () {
    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MapPage(
              initialCenter: LatLng(35.6762, 139.6503),
              initialZoom: 10,
            ),
          ),
        ),
      );
      expect(find.byType(MapPage), findsOneWidget);
    });

    testWidgets('accepts additional layers', (tester) async {
      const marker = SizedBox.square(dimension: 10);
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MapPage(
              layers: [marker],
            ),
          ),
        ),
      );
      expect(find.byType(MapPage), findsOneWidget);
    });
  });
}
