import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/ui_kit.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: PrimaryButton(label: 'Go', onPressed: () {}),
          ),
        ),
      );
      expect(find.text('Go'), findsOneWidget);
    });

    testWidgets('shows CircularProgressIndicator when loading', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryButton(label: 'Go', onPressed: null, isLoading: true),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Go'), findsNothing);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(label: 'Go', onPressed: () => tapped = true),
          ),
        ),
      );
      await tester.tap(find.byType(PrimaryButton));
      expect(tapped, isTrue);
    });
  });
}
