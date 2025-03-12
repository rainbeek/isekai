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

`dart-defines_example.json` を必要な環境のものだけ以下ファイル名でコピーし、それぞれ値を書き換えます。

- Emulator: `dart-defines_emulator.json`
  - `FLAVOR`: `emulator` と記載します。
  - `FIREBASE_EMULATOR_HOST`: ローカルマシンの IP アドレスを指定します。
- Dev: `dart-defines_dev.json`
  - `FLAVOR`: `dev` と記載します。
  - `FIREBASE_EMULATOR_HOST`: 使われないため、空文字を指定します。

#### 5. Firebase の構成ファイルを配置

以下のファイルを開発責任者から受け取り、ローカルに配置します。

| ファイルパス                                            | 説明                                                   |
| ------------------------------------------------------- | ------------------------------------------------------ |
| `lib/firebase_options_emulator.dart`                    | Flutter 用の Emulator 環境向けの Firebase 構成ファイル |
| `lib/firebase_options_dev.dart`                         | Flutter 用の Dev 環境向けの Firebase 構成ファイル      |
| `ios/Runner/Firebase/Emulator/GoogleService-Info.plist` | iOS 用の Emulator 環境向けの Firebase 構成ファイル     |
| `ios/Runner/Firebase/Dev/GoogleService-Info.plist`      | iOS 用の Dev 環境向けの Firebase 構成ファイル          |
| `android/app/src/emulator/google-services.json`         | Android 用の Emulator 環境向けの Firebase 構成ファイル |
| `android/app/src/dev/google-services.json`              | Android 用の Dev 環境向けの Firebase 構成ファイル      |

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

### アプリをデプロイ

#### 事前に必要な手順

[rbenv](https://github.com/rbenv/rbenv) をインストールします。

以下コマンドを実行し、リポジトリで利用しているバージョンの Ruby をインストールします。
このコマンドにより、[.ruby-version](/.ruby-version) に指定されているバージョンの Ruby がインストールされます。

```shell
rbenv install
```

以下コマンドを実行し、Ruby の依存関係をインストールします。

```shell
bundle install
```

以下のファイルを開発責任者から受け取り、ローカルに配置します。

| ファイルパス                                      | 説明                                                             |
| ------------------------------------------------- | ---------------------------------------------------------------- |
| `fastlane/.env`                                   | Fastlane 用の環境変数                                            |
| `fastlane/app-store-connect-api-key.p8`           | App Store Connect の API キー                                    |
| `fastlane/firebase-app-distribution-develop.json` | Firebase App Distribution へのデプロイ用のサービスアカウントキー |

#### デプロイ手順

Fastlane が自動生成する [README](/fastlane/README.md) を参照してください。
README のコマンドを実行する際は、`bundle exec` を先頭に付与して実行します。

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

事前準備として、以下のドキュメントに従って Firebase CLI をインストールし、ログインしておきます。

https://firebase.google.com/docs/flutter/setup?hl=ja&platform=ios#install-cli-tools

以下コマンドを実行します。
途中の選択肢は、"Build configutaion"と、"Debug-emulator"または"Debug-dev"を選択します。

```shell
flutterfire config \
  --project=shicolabs-dev \
  --out=lib/firebase_options_emulator.dart \
  --ios-bundle-id=com.rainbeek.isekai.emulator \
  --ios-out=ios/Runner/Firebase/Emulator/GoogleService-Info.plist \
  --android-package-name=com.rainbeek.isekai.emulator \
  --android-out=android/app/src/emulator/google-services.json
flutterfire config \
  --project=shicolabs-dev \
  --out=lib/firebase_options_dev.dart \
  --ios-bundle-id=com.rainbeek.isekai.dev \
  --ios-out=ios/Runner/Firebase/Dev/GoogleService-Info.plist \
  --android-package-name=com.rainbeek.isekai.dev \
  --android-out=android/app/src/dev/google-services.json
```
