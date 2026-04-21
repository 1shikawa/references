#!/bin/bash

echo "Current working directory: $(pwd)"

# Git repository root に移動
git_root=$(git rev-parse --show-toplevel 2>/dev/null)
if [ $? -eq 0 ] && [ "$git_root" != "$(pwd)" ]; then
    echo "Moving to Git repository root: $git_root"
    cd "$git_root"
fi

# git add されたファイルを取得
# 変更されたファイル (Modified)
staged_modified=$(git diff --cached --name-only --diff-filter=M)
# 新規追加されたファイル (Added)
staged_added=$(git diff --cached --name-only --diff-filter=A)

# 処理対象ファイルを結合
files=$(echo -e "$staged_modified\n$staged_added" | grep -v '^$' | sort -u)

if [ -z "$files" ]; then
    echo "No staged files found."
    exit 0
fi

# 各ファイルを処理
for file in $files; do
    echo ""
    echo "========== $file =========="
    
    # ファイルが変更されたものか、新規追加されたものかを判定
    if echo "$staged_modified" | grep -q "^$file$"; then
        # 既存ファイルの変更の場合、差分を処理
        echo "[Modified file - showing diff]"
        echo ""
        git diff --cached "$file" | gemini -p "この差分の変更内容を説明して"
    elif echo "$staged_added" | grep -q "^$file$"; then
        # 新規ファイルの場合、全体を処理
        echo "[New file - showing full content]"
        echo ""
        cat "$file" | gemini -p "このファイルの内容を説明して"
    fi
    echo ""
done
