import 'dart:io';

import 'package:yaml/yaml.dart';

void main() {
  final packagesDir = Directory('packages');
  if (!packagesDir.existsSync()) {
    print('No packages/ directory found. Run from workspace root.');
    exit(1);
  }

  final violations = <String>[];

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
        violations.add('  $name → $dep (feature→feature direct dep forbidden)');
      }
    }
  }

  if (violations.isEmpty) {
    print('dependency_validator: OK — no feature→feature violations found.');
    exit(0);
  } else {
    print('dependency_validator: VIOLATIONS FOUND:');
    for (final v in violations) {
      print(v);
    }
    exit(1);
  }
}

List<String> _keys(dynamic yaml) {
  if (yaml is YamlMap) return yaml.keys.cast<String>().toList();
  return [];
}
