#!/bin/bash

# 1. 引数の数のチェック（正確に2つであること）
if [ $# -ne 2 ]; then
    echo "Usage: $0 <natural_number1> <natural_number2>" >&2
    exit 1
fi

# 2. 入力が自然数（正の整数）であるかのチェック（正規表現を使用）
# 負の数、小数、文字、空文字をすべて弾きます
if [[ ! "$1" =~ ^[1-9][0-9]*$ ]] || [[ ! "$2" =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: Inputs must be natural numbers (positive integers)." >&2
    exit 1
fi

# 数値を型変換（念のため取得）
a=$1
b=$2

# 3. ユークリッドの互除法による最大公約数の計算
while [ $b -ne 0 ]; do
    remainder=$((a % b))
    a=$b
    b=$remainder
done

# 結果を出力
echo "$a"
exit 0
