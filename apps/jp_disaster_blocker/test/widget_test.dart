import 'package:feature_evacuation/testing/fake_shelter_repository.dart';
import 'package:feature_routing/feature_routing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infra_routing_engine/infra_routing_engine.dart';
import 'package:infra_storage/testing/fake_database.dart';
import 'package:jp_disaster_blocker/main.dart';
import 'package:jp_disaster_blocker/src/providers.dart';
import 'package:jp_disaster_blocker/src/route_page.dart';

void main() {
  testWidgets('DisasterBlockerApp shows bottom navigation', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWith((ref) async {
            final db = FakeDatabase();
            await db.open();
            return db;
          }),
          shelterRepositoryProvider.overrideWith((ref) async {
            return FakeShelterRepository();
          }),
          effectiveLocationProvider.overrideWith(
            (ref) async => (lat: 35.0, lng: 139.0),
          ),
          routingServiceProvider.overrideWith((ref) async {
            final engine = GraphHopperEngine();
            await engine.initialize('test');
            return EngineRoutingService(engine);
          }),
        ],
        child: const DisasterBlockerApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('地図'), findsWidgets);
    expect(find.text('避難所'), findsWidgets);
    expect(find.text('チェック'), findsWidgets);
    expect(find.text('ルート'), findsWidgets);
  });

  testWidgets('RoutePage computes stub routes', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          effectiveLocationProvider.overrideWith(
            (ref) async => (lat: 35.0, lng: 139.0),
          ),
          routingServiceProvider.overrideWith((ref) async {
            final engine = GraphHopperEngine();
            await engine.initialize('test');
            return EngineRoutingService(engine);
          }),
        ],
        child: const MaterialApp(home: RoutePage()),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.text('候補を計算'));
    await tester.pumpAndSettle();

    expect(find.textContaining('最短'), findsOneWidget);
  });
}
