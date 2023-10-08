# Dev Agent

本モジュールは、Chat-GPT を利用してタスクの要約から自動でコード修正の提案を行うためのツールです。

## 事前準備

Python と [virtualenv](https://virtualenv.pypa.io/en/latest/) をインストールします。

以下コマンドにより Python の仮想環境を作ります。

```bash
virtualenv env
```

以下コマンドにより有効化します(Mac の手順)。

```bash
source env/bin/activate
```

以下コマンドにより依存関係をインストールします。

```bash
pip install -r requirements.txt
```

以下コマンドにより `.env` ファイルを作ります。

```bash
cp .env.example .env
```

`.env` ファイルの中身を適切に修正します。

| キー                     | 内容                                                                                                                         |
| :----------------------- | :--------------------------------------------------------------------------------------------------------------------------- |
| `OPENAI_ORGANIZATION_ID` | Open AI API の Organization ID。[Organization > Settings](https://platform.openai.com/account/org-settings) で確認可能です。 |
| `OPENAI_API_KEY`         | Open AI API で発行した API Key。[User > API Keys](https://platform.openai.com/account/api-keys) で確認可能です。             |
| `PROMPT`                 | 修正したい内容の要約。例: `home_screenのタイトルを"スレッド一覧"に変更する`                                                  |

## 実行方法

VSCode の実行とデバッグ画面で、「Run」を実行してください。
