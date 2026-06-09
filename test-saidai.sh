#!/bin/bash

# テスト成否フラグ（1つでも失敗したら最後に1にする）
failed=0

# テスト用関数（正常系：期待する出力と一致するか）
assert_success() {
    local num1=$1
    local num2=$2
    local expected=$3
    
    result=$(./saidai.sh "$num1" "$num2" 2>/dev/null)
    status=$?
    
    if [ $status -eq 0 ] && [ "$result" = "$expected" ]; then
        echo "SUCCESS: ./saidai.sh $num1 $num2 -> $result"
    else
        echo "ERROR: ./saidai.sh $num1 $num2 (Expected: $expected, Got: $result, Status: $status)" >&2
        failed=1
    fi
}

# テスト用関数（異常系：エラー終了するか）
assert_error() {
    local args=("$@")
    
    # 引数をそのままスクリプトに渡して実行
    output=$(./saidai.sh "${args[@]}" 2>&1)
    status=$?
    
    if [ $status -ne 0 ] && [ -n "$output" ]; then
        echo "SUCCESS (Error Caught): ./saidai.sh ${args[*]} -> Status: $status, Message: $output"
    else
        echo "ERROR (Expected Error): ./saidai.sh ${args[*]} did not fail correctly. (Status: $status)" >&2
        failed=1
    fi
}

echo "=== 正常系のテスト開始 ==="
assert_success 2 4 2
assert_success 12 18 6
assert_success 101 10 1
assert_success 24 60 12

echo "=== 異常系のテスト開始 ==="
assert_error 3            # 引数が少ない
assert_error 2 4 6          # 引数が多い
assert_error文字 4        # 引数に文字が含まれる
assert_error 12 2.5         # 引数に小数が含まれる
assert_error -5 10          # 負の数
assert_error 0 5            # 0（自然数ではない）
assert_error "" 10          # 空文字

echo "=== テスト結果の判定 ==="
if [ $failed -eq 0 ]; then
    echo "All tests passed successfully!"
    exit 0
else
    echo "Some tests failed." >&2
    exit 1
fi
