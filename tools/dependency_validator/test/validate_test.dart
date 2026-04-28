import 'dart:io';

import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

List<String> _keys(dynamic yaml) {
  if (yaml is YamlMap) return yaml.keys.cast<String>().toList();
  return [];
}

List<String> findFeatureViolations(Directory packagesDir) {
  final violations = <String>[];
  if (!packagesDir.existsSync()) return violations;

  for (final entry in packagesDir.listSync().whereType<Directory>()) {
    final name = entry.path.split(Platform.pathSeparator).last;
    if (!name.startsWith('feature_')) continue;

    final pubspecFile = File('${entry.path}/pubspec.yaml');
    if (!pubspecFile.existsSync()) continue;

    final yaml = loadYaml(pubspecFile.readAsStringSync()) as YamlMap;
    final deps = <String>[
      ..._keys(yaml['dependencies']),
      ..._keys(yaml['dev_dependencies']),
    ];

    for (final dep in deps) {
      if (dep.startsWith('feature_') && dep != name) {
        violations.add('$name → $dep');
      }
    }
  }
  return violations;
}

void main() {
  test('no feature→feature violations in packages/', () {
    final packagesDir = Directory('packages');
    final violations = findFeatureViolations(packagesDir);
    expect(violations, isEmpty,
        reason: 'feature→feature direct deps found: $violations');
  });
}
