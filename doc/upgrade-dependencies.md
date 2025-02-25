# 依存関係の更新

## 前提

更新対象となっているライブラリの `pubspec.yaml` におけるバージョン指定は絶対に修正しないでください。
また、必要でない限り、ライブラリのバージョンを上げないでください。
加えて、Android の依存関係の解決は行わないでください。

Flutter の依存関係の解決には以下のコマンドを使ってください。

```bash
flutter pub get --no-example
```

iOS の依存関係解決には以下のコマンドを使ってください。

```bash
cd ios && bundle exec fastlane ios install_dependencies
```

## 手順

1. Flutter の依存関係の解決を試みます。
   1-1. 失敗しているライブラリの `pubspec.yaml` におけるバージョン指定を一旦外します。
   1-2. 依存関係の解決を試みます。
   1-3. 解決した場合、`pubspec.lock` に解決されたバージョンを `pubspec.yaml` に逆輸入します。
   1-4. 解決しない場合、1-1 に戻ります。
2. iOS の依存関係の解決を試みます。

どうしても解決できない場合は、中断します。
