import 'package:feature_evacuation/feature_evacuation.dart';
import 'package:feature_evacuation/testing/fake_shelter_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShelterListPage', () {
    testWidgets('shows shelter list on load', (tester) async {
      final repo = FakeShelterRepository(
        initial: [
          const Shelter(
            id: 1,
            name: '第一避難所',
            latitude: 35.68,
            longitude: 139.70,
            disasterTypes: [DisasterType.earthquake],
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ShelterListPage(
            repository: repo,
            currentLat: 35.68,
            currentLng: 139.70,
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('第一避難所'), findsOneWidget);
    });

    testWidgets('shows empty message when no shelters', (tester) async {
      final repo = FakeShelterRepository();

      await tester.pumpWidget(
        MaterialApp(
          home: ShelterListPage(
            repository: repo,
            currentLat: 35.68,
            currentLng: 139.70,
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('この範囲に避難所が見つかりません'), findsOneWidget);
    });
  });
}
