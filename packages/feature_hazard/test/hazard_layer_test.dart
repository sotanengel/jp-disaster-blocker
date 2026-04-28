import 'package:feature_hazard/feature_hazard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PmTilesHazardLayerController', () {
    test('initially no active types', () {
      final controller = PmTilesHazardLayerController();
      expect(controller.activeTypes, isEmpty);
    });

    test('HazardType.values has 4 types', () {
      expect(HazardType.values, hasLength(4));
    });

    test('each HazardType has a label and assetPath', () {
      for (final type in HazardType.values) {
        expect(type.label, isNotEmpty);
        expect(type.assetPath, contains('.pmtiles'));
      }
    });
  });
}
