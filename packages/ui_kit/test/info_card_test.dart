import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('InfoCard', () {
    testWidgets('renders title and body', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoCard(title: 'T', body: 'B'),
          ),
        ),
      );
      expect(find.text('T'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InfoCard(
              title: 'T',
              body: 'B',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(InfoCard));
      expect(tapped, isTrue);
    });
  });
}
