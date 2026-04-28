import 'package:feature_checklist/feature_checklist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChecklistRepository', () {
    late ChecklistRepository repo;

    setUp(() {
      repo = StaticChecklistRepository();
    });

    test('returns items for every scenario', () {
      for (final scenario in ChecklistScenario.values) {
        final items = repo.itemsFor(scenario);
        expect(items, isNotEmpty, reason: 'Scenario $scenario has no items');
      }
    });

    test('items have non-empty titles', () {
      for (final scenario in ChecklistScenario.values) {
        for (final item in repo.itemsFor(scenario)) {
          expect(item.title, isNotEmpty);
        }
      }
    });

    test('covers all 5 scenarios', () {
      expect(ChecklistScenario.values, hasLength(5));
    });
  });

  group('ChecklistPage', () {
    testWidgets('shows scenario label as title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChecklistPage(scenario: ChecklistScenario.earthquake),
        ),
      );
      expect(
        find.text(ChecklistScenario.earthquake.label),
        findsOneWidget,
      );
    });

    testWidgets('shows checklist items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChecklistPage(scenario: ChecklistScenario.earthquake),
        ),
      );
      final items =
          StaticChecklistRepository().itemsFor(ChecklistScenario.earthquake);
      expect(find.text(items.first.title), findsOneWidget);
    });

    testWidgets('toggling item updates checked state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChecklistPage(scenario: ChecklistScenario.earthquake),
        ),
      );
      final items =
          StaticChecklistRepository().itemsFor(ChecklistScenario.earthquake);
      final firstItemFinder = find.text(items.first.title);
      expect(firstItemFinder, findsOneWidget);

      // Initially unchecked
      final checkboxFinder = find.descendant(
        of: find.ancestor(
          of: firstItemFinder,
          matching: find.byType(CheckboxListTile),
        ),
        matching: find.byType(Checkbox),
      );
      final checkbox = tester.widget<Checkbox>(checkboxFinder);
      expect(checkbox.value, isFalse);

      // Tap to check
      await tester.tap(find.ancestor(
        of: firstItemFinder,
        matching: find.byType(CheckboxListTile),
      ));
      await tester.pump();

      final updatedCheckbox = tester.widget<Checkbox>(
        find.descendant(
          of: find.ancestor(
            of: firstItemFinder,
            matching: find.byType(CheckboxListTile),
          ),
          matching: find.byType(Checkbox),
        ),
      );
      expect(updatedCheckbox.value, isTrue);
    });
  });
}
