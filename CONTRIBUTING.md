# Contributing to jp-disaster-blocker

## 開発環境セットアップ

### 必須ツール

```bash
# Flutter SDK (3.x stable)
brew install --cask flutter

# melos（モノリポ管理）
dart pub global activate melos

# GitHub CLI
brew install gh
```

### リポジトリセットアップ

```bash
git clone git@github.com:sotanengel/jp-disaster-blocker.git
cd jp-disaster-blocker
melos bootstrap
```

---

## Takumi Guard（必須: サプライチェーン攻撃対策）

Takumi Guard は Flatt Security 社が提供するサプライチェーン攻撃対策プロキシです。
開発端末でも有効化することで、悪意のある npm/PyPI パッケージのインストールを防ぎます。

### npm 設定

プロジェクトルートの `.npmrc`（またはグローバル `~/.npmrc`）に以下を追記してください:

```ini
registry=https://npm.takumi-guard.com/<your-token>/
```

> `<your-token>` は Flatt Security から発行されたトークンに置き換えてください。
> トークンは `.npmrc` に直書きせず、環境変数 `NPM_TOKEN` で渡すことを推奨します。

### PyPI 設定

`~/.config/pip/pip.conf`（macOS では `~/Library/Application Support/pip/pip.conf`）に以下を追記:

```ini
[global]
index-url = https://pypi.takumi-guard.com/<your-token>/simple/
```

> または環境変数: `PIP_INDEX_URL=https://pypi.takumi-guard.com/<your-token>/simple/`

### 動作確認

```bash
# npm: 悪性パッケージが拒否されることを確認
npm install @panda-guard/test-malicious
# → インストールが失敗すれば Takumi Guard が有効

# PyPI: 同様
pip install panda-guard-test-malicious
# → エラーになれば OK
```

---

## 開発フロー

### ブランチ命名規則

```
feat/<nn>-<topic>     例: feat/07-feature-map
fix/<nn>-<topic>      例: fix/08-shelter-search-crash
chore/<nn>-<topic>    例: chore/02-lint-rules
test/<nn>-<topic>     例: test/19-offline-e2e
```

### TDD（厳守）

すべての PR は Red → Green → Refactor サイクルで実装します。

```bash
# 1. テストを書く（失敗する状態でコミット）
git commit -m "test: add failing test for XxxService"

# 2. 最小実装でテストを通す
git commit -m "feat: implement XxxService"

# 3. リファクタリング
git commit -m "refactor: simplify XxxService"
```

### テスト実行

```bash
melos run test    # 全パッケージのテスト
melos run lint    # 全パッケージの静的解析
```

### PR 作成

```bash
gh pr create --draft
```

CI（Takumi Guard + flutter-test）がグリーンになってからレビュー依頼してください。

---

## 疎結合ルール

`feature_*` パッケージ同士の直接 import は **禁止** です。
CI の `dependency_validator` ジョブが自動検出します。

```
apps  ──▶ feature_*  ──▶ infra_* / data_sync
                ╲          │
                 ╲─▶ ui_kit│
                            ▼
                          core
```

---

## コミット規約

[Conventional Commits](https://www.conventionalcommits.org/) を使用します。

| プレフィックス | 用途 |
|---|---|
| `feat:` | 新機能 |
| `fix:` | バグ修正 |
| `refactor:` | リファクタリング |
| `test:` | テスト追加・修正 |
| `chore:` | ビルド・CI・設定 |
| `docs:` | ドキュメント |
