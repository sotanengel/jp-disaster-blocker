# Feature 実装プロンプト

新しい feature パッケージを実装する際のガイドラインです。

## パッケージ構成

```
packages/feature_<name>/
├── pubspec.yaml
├── lib/
│   ├── feature_<name>.dart       # barrel（公開 API のみ export）
│   └── src/
│       ├── <name>_service.dart   # abstract interface
│       └── impl_<name>_service.dart  # 実装
├── testing/
│   └── fake_<name>_service.dart  # テスト用 Fake（別 entry point）
└── test/
    └── <name>_service_test.dart
```

## pubspec.yaml テンプレート

```yaml
name: feature_<name>
description: jp-disaster-blocker feature package for <name>
version: 0.1.0
publish_to: none

environment:
  sdk: ^3.0.0
  flutter: ^3.0.0

dependencies:
  flutter:
    sdk: flutter
  core:
    path: ../../core
  riverpod: ^2.0.0
  flutter_riverpod: ^2.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  very_good_analysis: ^7.0.0
```

## 依存ルール

- `feature_*` → `feature_*` は **絶対に禁止**
- `feature_*` → `infra_*` / `core` / `ui_kit` / `data_sync` は OK
- 横断通知は `core/event_bus.dart` 経由のみ
