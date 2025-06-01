# アーキテクチャ

本プロジェクトは、Flutter による iOS と Android のアプリケーションである。

- [`./android/`](/android/): Android 専用のプロダクトコードやプロジェクト設定
- [`./ios/`](/ios/): iOS 専用のプロダクトコードやプロジェクト設定
- [`./lib/`](/lib/): OS 間で共通のプロダクトコード
  - [`./data/`](/lib/data/): 情報の保持・取得や、OS レイヤーとのやりとり
    - [`./definition/`](/lib/data/definition/): 情報の保持・取得や、OS レイヤーとのやりとりに利用する共通化された定義
    - [`./model/`](/lib/data/model/): ドメインモデル。UI に依存しない純粋なデータ構造や、UI に依存しない `Exception`、`Error` などを配置する。
    - [`./repository/`](/lib/data/repository/): Repository。具体的な向き先を抽象化しつつ、情報の保持・取得を行う処理の定義
    - [`./service/`](/lib/data/service/): Service。OS や Firebase との接続を定義
  - [`./ui/`](/lib/ui/): 画面描画や表示ロジックの定義

本アプリでは、Swift Package Manager(SPM) を有効化しており、CocoaPods と併用している。
SPM は以下のコマンドにより、Flutter 本体で有効化している。

```bash
flutter config --enable-swift-package-manager
```

SPM はベータ版機能であるため、ビルドなどで問題が発生することがある。
その際は、Flutter の報告されている Issue を調査したり、未知の問題が発生している可能性があることを考慮するなどにより、トラブルシューティングを行う。

# 開発ガイド

## 一般的なルール

### ドキュメンテーション

クラスアーキテクチャやディレクトリ構造に関して、新しい概念が導入された場合は、以下のドキュメントを更新する。

- [doc/rules-for-ai_japanese.md](/doc/rules-for-ai_japanese.md)
- [.clinerules](/.clinerules)
- [ARCHITECTURE.md](/ARCHITECTURE.md)

### スタイル

Linter やコンパイラの警告は、即時解決しなさい。

早期リターンを必ず使用して、ネストを減らす。

`try`-`catch` 文は、throw する可能性のある処理のみを囲み、できるだけ小さなスコープで使用する。

利用されていないコードは、即時削除する。

### コードの一貫性を保つ

同様の機能を持つ処理は、同様の流れで実装する。周辺に同様の処理がすでに実装されていないかを確認し、実装されている場合はそれに従う。

- 特に、データの取得・変換・フィルタリングのフローは統一する。

### コメントの十分性を保つ

コードの意図や目的を明確にする必要がある場合のみにコメントを追加する。コードの内容が明確な場合はコメントを避ける。

特に重要な注意点や落とし穴については、理由も含めて詳細に記述する。

コメントは日本語で記述する。

### 命名の可読性を保つ

変数名はその目的や内容を明確に表す名前をつける。

一時変数においても意味のある名前をつける。

同じ種類のデータを扱う変数には、一貫した命名パターンを使用する。

## Flutter に関するルール

### ドメインモデルの定義

ドメインモデルは明確に分離し、適切なファイルに配置する。

`freezed` を利用したイミュータブルなドメインモデルを定義する。`sealed class` を使用する場合も `freezed` を利用する。

### 関数型プログラミングを活用する

コレクション操作には関数型メソッドを使用する。

- 例: `map`, `where`, `fold`, `expand`

複雑なデータ変換は複数のステップに分けて可読性を高める。

コレクションの変換時は、変換された新しいコレクションが返却される処理を使用する。

- 例: `collection` パッケージの `sortedBy` など。

### 状態管理には `Riverpod` を適切に使用する

状態管理には `Riverpod` を使用する。

プロバイダーは `@riverpod` アノテーションを使用したコード生成を利用して定義する。

複数の非同期プロバイダーを扱う場合、状態リセットを防ぐために全てのプロバイダーを先に `watch` してから後で `await` する。

例:

```dart
@riverpod
Future<String> currentUser(Ref ref) async {
  final data1Future = ref.watch(provider1.future);
  final data2Future = ref.watch(provider2.future);

  final data1 = await data1Future;
  final data2 = await data2Future;

  // 後続の処理
}
```

### エラーハンドリングを適切に行う

非同期処理のエラーは適切にキャッチし、ユーザーに通知する。

### UI を適切に構築する

UI 要素の表示・非表示状態は専用の状態管理クラスで管理する。

- 例: `HouseWorkVisibilities`

状態変更のロジックはプレゼンターに実装する。

表示・非表示の状態に基づいて、データをフィルタリングする処理はプロバイダー内で行う。

コンテンツが多くなる可能性がある場合は、`SingleChildScrollView`を使用してスクロール可能にする。

デバイスの安全領域を考慮したパディングを追加する。

- 例: `EdgeInsets.only(left: 16 + MediaQuery.of(context).viewPadding.left, ...)`

ウィジェットをクラスとして分割し、可読性を高める。

例:

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(),
        _Content(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Header');
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Content');
  }
}
```

ウィジェットのローカル変数への格納 → 余白をつけて組み立て、の 2 ステップで処理を分ける。

例:

```dart
Widget build(BuildContext context) {
  // ウィジェットのローカル変数への格納
  const firstText = Text('1st');
  const secondText = Text('2nd');

  // 余白をつけて組み立て
  return = Column(
    children: const [
      firstText,
      Padding(
        padding: EdgeInsets.only(top: 16),
        child: secondText,
      ),
    ],
  );
}
```

色はテーマとして定義されたもの利用する。

- 例: `Theme.of(context).colorScheme.primary`。

テキストのスタイルはテキストテーマとして定義されたものを利用する。

- 例: `Theme.of(context).textTheme.headline6`。

ユーザーが操作できる箇所にはツールチップを追加し、アクセシビリティを考慮する。

UI に表示する文字列は、ドメインモデルに含めず、ウィジェット構築の処理で定義する。

### 画面ナビゲーション

画面には静的フィールドで `MaterialPageRoute` を定義し、その画面に遷移する際には静的フィールドと`Navigator` を使用する。

例:

```dart
class SomeScreen extends StatelessWidget {
  const SomeScreen({super.key});

  static const name = 'AnalysisScreen';

  static MaterialPageRoute<SomeScreen> route() =>
      MaterialPageRoute<SomeScreen>(
        builder: (_) => const SomeScreen(),
        settings: const RouteSettings(name: name),
      );

  @override
  Widget build(BuildContext context) {
    // 画面のビルド処理
  }
}

// 遷移する際
Navigator.of(context).push(SomeScreen.route);
```
