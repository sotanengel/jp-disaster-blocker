## 概要

<!-- 変更の目的を 1〜2 文で要約 -->

## 変更内容

<!-- 具体的な変更点をリストアップ -->

-
-

## 変更の種類

- [ ] `feat` — 新機能
- [ ] `fix` — バグ修正
- [ ] `refactor` — リファクタリング
- [ ] `test` — テスト追加・修正
- [ ] `chore` — ビルド・CI・設定変更
- [ ] `docs` — ドキュメント

## TDD チェックリスト

- [ ] Red: 失敗するテストを最初のコミットで追加した
- [ ] Green: 最小実装でテストを通した
- [ ] Refactor: テストをグリーンに保ちつつ整理した

## テスト確認

```bash
melos run test
melos run lint
```

- [ ] `melos run test` グリーン
- [ ] `melos run lint` 警告ゼロ
- [ ] CI 全ジョブグリーン（Takumi Guard + flutter-test）

## 疎結合チェック

- [ ] `feature_*` → `feature_*` の直接依存がない
- [ ] `dependency_validator` がゼロエラー

## レビュアーへのメモ

<!-- 特に注意して見てほしい箇所や背景情報 -->
