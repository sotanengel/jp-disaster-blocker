# GitHub Copilot Instructions — jp-disaster-blocker

## 言語・形式

- コード: Dart / Flutter 3.x（Dart 3）
- コメント・コミットメッセージ・PR 本文: 日本語 OK
- コミット規約: Conventional Commits (`feat:`, `fix:`, `chore:`, `test:`, `refactor:`, `docs:`)
- ブランチ命名: `feat/<nn>-<topic>`, `fix/<nn>-<topic>`, `chore/<nn>-<topic>`, `test/<nn>-<topic>`

## TDD（厳守）

すべての PR は Red → Green → Refactor サイクルで実装すること。

1. **Red**: 最初のコミットは必ず失敗するテストのみ
2. **Green**: 最小実装でテストを通す（余計なコードを書かない）
3. **Refactor**: テストをグリーンに保ちつつ整理

## 疎結合ルール

- `feature_*` パッケージ同士が直接 import することを禁止
- 横断的通知は `core/event_bus.dart` のみ経由
- infra → feature への逆流禁止
- 各 feature は `lib/<feature>.dart` の barrel のみを公開インターフェースとする

## アーキテクチャ

```
apps  ──▶ feature_*  ──▶ infra_* / data_sync
                ╲          │
                 ╲─▶ ui_kit│
                            ▼
                          core
```

## 実装パターン

各 feature は三層構成を守ること。

```dart
// 1. abstract interface
abstract interface class XxxService { ... }

// 2. 実装クラス (lib/src/ に配置)
final class ConcreteXxxService implements XxxService { ... }

// 3. テスト用 Fake (testing/ entry point から公開)
final class FakeXxxService implements XxxService { ... }
```

## DI

Riverpod の `Provider` で interface を公開。実装の選択は `apps/` の composition root のみで行う。

## セキュリティ

- GitHub Actions は全 step を SHA 固定
- サプライチェーン保護: npm/PyPI は Takumi Guard 必須
- 外部送信コードを一切書かない（NFR-09）

## テストカバレッジ目標

- ライン 80% / ブランチ 70%（各 feature パッケージ単位で達成）

## 禁止事項

- `feature_*` → `feature_*` の直接 import
- `print()` の使用（`Logger` interface を使う）
- ハードコードされたパス・URL
- 外部ネットワーク送信コード
