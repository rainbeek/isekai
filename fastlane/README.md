fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### install_flutter_dependencies

```sh
[bundle exec] fastlane install_flutter_dependencies
```

Flutterの依存関係をインストールします。

### generate

```sh
[bundle exec] fastlane generate
```

自動コードを生成します。

### release_notes

```sh
[bundle exec] fastlane release_notes
```



----


## iOS

### ios install_dependencies

```sh
[bundle exec] fastlane ios install_dependencies
```

iOSの依存関係をインストールします。

### ios build_dev

```sh
[bundle exec] fastlane ios build_dev
```

Dev環境向けアプリをビルドします。

### ios build_dev_with_no_code_sign

```sh
[bundle exec] fastlane ios build_dev_with_no_code_sign
```

Dev環境向けアプリを電子署名なしにビルドします。

### ios deploy_dev

```sh
[bundle exec] fastlane ios deploy_dev
```

Dev環境向けアプリをFirebase App Distributionにデプロイします。

----


## Android

### android build_dev

```sh
[bundle exec] fastlane android build_dev
```

Dev環境向けアプリをビルドします。

### android deploy_dev

```sh
[bundle exec] fastlane android deploy_dev
```

Dev環境向けアプリをFirebase App Distributionにデプロイします。

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
