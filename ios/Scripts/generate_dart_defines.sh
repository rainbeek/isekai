#!/bin/bash

# 環境の設定が格納されているキー名
ENV_KEY='SERVER_ENV'

# 環境ごとの xcconfig を include するファイル
OUTPUT_FILE="${SRCROOT}/Flutter/DartDefines.xcconfig"

# Flutter 2.2 以降で必要な、Dart-Define のデコード処理
function decode_url() { echo "${*}" | base64 --decode; }

# 最初にファイル内容をいったん空にする
: > "$OUTPUT_FILE"

IFS=',' read -r -a define_items <<<"$DART_DEFINES"

for index in "${!define_items[@]}"
do
    item=$(decode_url "${define_items[$index]}")
    # 環境値が含まれる Dart-Define の場合
    is_flavor_item=$(echo "$item" | grep "$ENV_KEY")
    if [ "$is_flavor_item" ]; then
        value=${item#*=}
        # 環境に対応した xcconfig ファイルを include する
        echo "#include \"$value.xcconfig\"" >> "$OUTPUT_FILE"
    fi
done
