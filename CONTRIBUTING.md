# Contributing

本ドキュメントは、開発に必要な手順を記載したものです。

## 開発する

### はじめに

開発には Mac が必要です。本リポジトリの各種ドキュメントは、Mac 前提の手順となっています。

利用している SDK や IDE のバージョンは以下を参考にしてください。

- Flutter: `.tool-versions` > `flutter`

### 環境構築

#### 1. Flutter SDK のインストール

[asdf](https://asdf-vm.com/guide/getting-started.html#_1-install-dependencies)をインストールします。

asdf の Flutter プラグインを以下コマンドによりインストールします。

```
asdf plugin add flutter
```

リポジトリのルートフォルダーに移動し、以下のコマンドにより、プロジェクトで利用するバージョンの Flutter SDK をインストールし、パスを整理します。

```shell
asdf install
asdf reshim
```

#### 2. iOS/Android ビルドの環境構築

[Install > Platform setup](https://flutter.dev/docs/get-started/install/macos#platform-setup) における、"iOS Setup"と"Android Setup"までを完了させます。

#### 3. エディターの環境構築

リポジトリのルートフォルダーを VSCode で開き、「このワークスペースには拡張機能の推奨事項があります」と表示された場合は「すべてインストール」を選択し、拡張機能をインストールします。

次に、[Set up an editor > Android Studio and IntelliJ](https://flutter.dev/docs/get-started/editor?tab=androidstudio) に従って、Android Studio の環境構築を完了させます。

#### 4. 開発マシンごとの個別情報の記載

`dart-defines_example.json` を必要な環境のものだけ以下ファイル名でコピーし、中身を適切に書き換えます。

- Emulator: `dart-defines_emulator.json`

### 普段の開発

`@freezed` アノテーションが付与されたクラスを修正した場合はコード生成が必要です。
VSCode の [Build Runner 拡張機能](https://marketplace.visualstudio.com/items?itemName=GaetSchwartz.build-runner)を利用してビルドするか、以下コマンドにより監視モードを発動させておいてください。

```shell
dart run build_runner watch
```

上記コマンドでエラーが発生した場合は、以下コマンドを実行してみてください。

```shell
dart run build_runner build --delete-conflicting-outputs
```

### Firebase サーバーをローカルで立てて開発

[「Firebase CLI をインストールする」](https://firebase.google.com/docs/cli#install_the_firebase_cli)を参考に、Firebase CLI をインストールします。

以下コマンドを実行します。

```shell
firebase emulators:start --import=emulator-data --export-on-exit=emulator-data
```

上記により、`emulator-data` フォルダーに Firebase Emulator のデータが保持されます。
リセットしたい場合は、フォルダーごと削除してください。

次に、`.env.example` を `.env` としてコピーし、ローカル PC の IP アドレスを `FIREBASE_EMULATOR_HOST` に記載します。

VSCode の「Emulator-Debug」などの構成でデバッグ実行します。

## デプロイ

### Firestore のルールをデプロイ

[「Firebase CLI をインストールする」](https://firebase.google.com/docs/cli#install_the_firebase_cli)を参考に、Firebase CLI をインストールします。

以下コマンドを実行します。

```shell
firebase deploy --only firestore:rules
```

## メンテナンス

### Flutter のバージョン更新

プロジェクトで利用している Flutter のバージョンを更新する場合、以下を実施します。

まず、asdf で利用可能な Flutter のバージョン一覧を確認します。

```shell
asdf list all flutter
```

次に、対象バージョンの Flutter を PC にインストールします。
このとき、`<version>`には一つ前のコマンドで表示されたバージョン名を指定します。

```shell
asdf install flutter <version>
```

次に、プロジェクトの Flutter バージョン指定を更新します。

```shell
asdf local flutter <version>
```

この際、VSCode のデバッグで利用される Flutter バージョンが切り替わらないことがあるため、以下コマンドを実行してから VSCode を再起動してください。

```shell
rm pubspec.lock
flutter pub get
```

### コミットされている Firebase のプロジェクト情報を更新

以下コマンドを実行します。

```shell
flutterfire config \
  --project=shicolabs-dev \
  --out=lib/firebase_options_emulator.dart \
  --ios-bundle-id=com.rainbeek.isekai.emulator \
  --android-app-id=com.rainbeek.isekai.emulator
flutterfire config \
  --project=shicolabs-dev \
  --out=lib/firebase_options_dev.dart \
  --ios-bundle-id=com.rainbeek.isekai.dev \
  --android-app-id=com.rainbeek.isekai.dev
```
