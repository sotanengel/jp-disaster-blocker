# TDD 実装プロンプト

このリポジトリでは Red → Green → Refactor サイクルを厳守します。

## 手順

1. **Red フェーズ**
   - まずテストファイルのみを作成・コミット
   - テストは必ず失敗する状態でコミット
   - コミットメッセージ例: `test: add failing test for XxxService`

2. **Green フェーズ**
   - テストを通す最小実装のみ追加
   - 余計な最適化・抽象化をしない
   - コミットメッセージ例: `feat: implement XxxService to pass tests`

3. **Refactor フェーズ**
   - テストをグリーンに保ちながらコードを整理
   - コミットメッセージ例: `refactor: simplify XxxService implementation`

## 実装テンプレート

```dart
// lib/src/xxx_service.dart
abstract interface class XxxService {
  Future<Result<XxxResult, AppException>> doSomething(XxxRequest request);
}

// lib/src/concrete_xxx_service.dart
final class ConcreteXxxService implements XxxService {
  @override
  Future<Result<XxxResult, AppException>> doSomething(XxxRequest request) async {
    // 最小実装
  }
}

// testing/fake_xxx_service.dart
final class FakeXxxService implements XxxService {
  XxxResult? nextResult;
  AppException? nextError;

  @override
  Future<Result<XxxResult, AppException>> doSomething(XxxRequest request) async {
    if (nextError != null) return Err(nextError!);
    return Ok(nextResult!);
  }
}
```
