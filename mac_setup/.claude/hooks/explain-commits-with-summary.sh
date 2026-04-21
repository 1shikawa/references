#!/bin/bash

# カレントブランチのコミット内容を説明するスクリプト（全体サマリー付き）

set -e
set -o pipefail

# 色付け用の変数
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# リポジトリのルートディレクトリを取得
GIT_ROOT=$(git rev-parse --show-toplevel)
CURRENT_DIR=$(pwd)

# .claudeディレクトリを作成（存在しない場合）
CLAUDE_DIR="$GIT_ROOT/.claude"
mkdir -p "$CLAUDE_DIR"

# マークダウン専用出力関数
md_output() {
  echo "$@" | sed 's/\x1b\[[0-9;]*m//g' >>"$MD_FILE"
}

# 分岐元ブランチを自動検出する関数（最も近いブランチを選択）
find_base_branch() {
  local current_branch=$1
  local base_branch=""
  local min_distance=999999
  
  # リモートブランチを更新
  git fetch --quiet 2>/dev/null || true
  
  # 全てのリモートブランチを検査
  for branch in $(git branch -r | grep -v HEAD | sed 's/^[ \t]*//'); do
    # 自分自身は除外
    if [ "$branch" == "origin/$current_branch" ]; then
      continue
    fi
    
    # 共通祖先を取得
    local merge_base=$(git merge-base "$branch" "$current_branch" 2>/dev/null || true)
    if [ -z "$merge_base" ]; then
      continue
    fi
    
    # 共通祖先から現在のブランチまでの距離を計算
    # (共通祖先から分岐元ブランチまでのコミット数 + 共通祖先から現在のブランチまでのコミット数)
    local distance_to_branch=$(git rev-list --count "$merge_base".."$branch" 2>/dev/null || echo 999999)
    local distance_to_current=$(git rev-list --count "$merge_base".."$current_branch" 2>/dev/null || echo 999999)
    local total_distance=$((distance_to_branch + distance_to_current))
    
    # より近いブランチが見つかったら更新
    if [ $total_distance -lt $min_distance ]; then
      min_distance=$total_distance
      base_branch="$branch"
    fi
  done
  
  echo "$base_branch"
}

# 現在のブランチ名を取得
BRANCH=$(git branch --show-current)
# ブランチ名をファイル名用に変換（スラッシュをアンダースコアに）
BRANCH_FILENAME=$(echo "$BRANCH" | sed 's/\//_/g')
MD_FILE="$CLAUDE_DIR/${BRANCH_FILENAME}.md"

# 分岐元ブランチを検出（最も近いブランチを自動選択）
printf "${BLUE}最も近い分岐元ブランチを検出中...${NC}\n"
BASE_BRANCH=$(find_base_branch "$BRANCH")

# 分岐元が見つからない場合はエラー
if [ -z "$BASE_BRANCH" ]; then
  printf "${RED}エラー: 分岐元ブランチが見つかりません。${NC}\n"
  printf "${RED}リモートブランチが存在することを確認してください。${NC}\n"
  printf "${RED}(git fetch を実行してリモートブランチ情報を更新してください)${NC}\n"
  exit 1
fi

printf "${GREEN}分岐元: $BASE_BRANCH${NC}\n"

# 分岐元との距離を表示（デバッグ情報）
if [ -n "$BASE_BRANCH" ]; then
  MERGE_BASE_TEMP=$(git merge-base "$BASE_BRANCH" "$BRANCH" 2>/dev/null || true)
  if [ -n "$MERGE_BASE_TEMP" ]; then
    DISTANCE_TO_BASE=$(git rev-list --count "$MERGE_BASE_TEMP".."$BASE_BRANCH" 2>/dev/null || echo 0)
    DISTANCE_TO_CURRENT=$(git rev-list --count "$MERGE_BASE_TEMP".."$BRANCH" 2>/dev/null || echo 0)
    printf "${BLUE}(分岐元までの距離: $DISTANCE_TO_BASE コミット, 現在のブランチまで: $DISTANCE_TO_CURRENT コミット)${NC}\n"
  fi
fi
# 分岐点を取得
MERGE_BASE=$(git merge-base "$BASE_BRANCH" "$BRANCH")
# 分岐元から現在のブランチまでのコミットを取得
COMMITS=$(git rev-list --reverse "$MERGE_BASE..$BRANCH")
COMMIT_COUNT=$(echo "$COMMITS" | wc -l | tr -d ' ')

# コミットがない場合の処理
if [ "$COMMIT_COUNT" -eq 0 ]; then
  printf "${YELLOW}警告: 分岐元ブランチとの差分コミットがありません。${NC}\n"
  printf "${YELLOW}現在のブランチは分岐元と同じ状態です。${NC}\n"
  exit 0
fi

# マークダウンファイルを初期化
echo "# コミット内容説明: $BRANCH" >"$MD_FILE"
md_output ""
md_output "生成日時: $(date '+%Y-%m-%d %H:%M:%S')"
md_output ""

printf "${BLUE}=== 解析中: $BRANCH ===${NC}\n"

# マークダウンファイルにブランチ情報を記録
md_output "## ブランチ情報"
md_output ""
md_output "ブランチ: \`$BRANCH\`"
md_output "分岐元: \`$BASE_BRANCH\`"
md_output "コミット数: $COMMIT_COUNT"
md_output ""

# 全体サマリー用の変数を初期化
FILE_CHANGES_SUMMARIES=()
# ファイルタイプカウント用の変数を個別に定義
COUNT_TYPESCRIPT=0
COUNT_JAVASCRIPT=0
COUNT_JSON=0
COUNT_YAML=0
COUNT_LOCK=0
COUNT_TERRAFORM=0
COUNT_PYTHON=0
COUNT_SHELL=0
COUNT_MARKDOWN=0
COUNT_OTHER=0
TOTAL_ADDED_LINES=0
TOTAL_DELETED_LINES=0

printf "${GREEN}全コミット情報を取得中...${NC}\n"

# マークダウン用のセクション
md_output "## コミット一覧"
md_output ""
md_output "| ハッシュ | メッセージ | 作成者 | 日時 |"
md_output "|---------|------------|---------|------|"

# 各コミットの情報を表に追加
for commit in $COMMITS; do
  COMMIT_SHORT=$(git rev-parse --short "$commit")
  COMMIT_MSG=$(git log -1 --pretty=%s "$commit")
  COMMIT_AUTHOR=$(git log -1 --pretty=%an "$commit")
  COMMIT_DATE=$(git log -1 --pretty=%ad --date=format:'%Y-%m-%d %H:%M:%S' "$commit")
  md_output "| \`$COMMIT_SHORT\` | $COMMIT_MSG | $COMMIT_AUTHOR | $COMMIT_DATE |"
done
md_output ""

# 一時ディレクトリを作成
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# ファイルごとの最終的な変更内容を生成
printf "${BLUE}ファイルごとの最終的な変更内容を生成中...${NC}\n"
printf "\n"

# 変更統計を取得
cd "$GIT_ROOT"
# 分岐元との差分を取得
CHANGED_FILES=$(git diff --name-only "$MERGE_BASE" HEAD)
DIFF_STAT=$(git diff --stat "$MERGE_BASE" HEAD)

# 追加・削除行数を抽出（最後の行から）
if [[ "$DIFF_STAT" =~ ([0-9]+)\ files?\ changed ]]; then
  if [[ "$DIFF_STAT" =~ ([0-9]+)\ insertions?\(\+\) ]]; then
    TOTAL_ADDED_LINES=${BASH_REMATCH[1]}
  fi
  if [[ "$DIFF_STAT" =~ ([0-9]+)\ deletions?\(\-\) ]]; then
    TOTAL_DELETED_LINES=${BASH_REMATCH[1]}
  fi
fi

FILE_COUNT=$(echo "$CHANGED_FILES" | grep -c . || echo 0)
printf "${YELLOW}変更されたファイル: $FILE_COUNT 件${NC}\n"

# 全体サマリー用のプレースホルダーを追加（後で更新）
SUMMARY_PLACEHOLDER="<!-- OVERALL_SUMMARY_PLACEHOLDER -->"
md_output "$SUMMARY_PLACEHOLDER"
md_output ""

# 変更されたファイルのリストをマークダウンに記録
md_output "## ファイルごとの変更内容"
md_output ""
md_output "変更されたファイル一覧:"
echo "$CHANGED_FILES" | while IFS= read -r file; do
  [ -n "$file" ] && md_output "- \`$file\`"
done
md_output ""

# ファイルごとに最終的な変更内容を解析
PROCESSED=0
# プロセス置換を避けるため、ファイルリストを配列に変換
IFS=$'\n'
FILES_ARRAY=($CHANGED_FILES)
unset IFS

for file in "${FILES_ARRAY[@]}"; do
  [ -z "$file" ] && continue
  PROCESSED=$((PROCESSED + 1))
  printf "${GREEN}[$PROCESSED/$FILE_COUNT] $file を解析中...${NC}\n"
  md_output "### \`$file\`"
  md_output ""

  # ファイルの最終的な差分を取得（分岐元との差分）
  git diff "$MERGE_BASE" HEAD -- "$file" >"$TEMP_DIR/diff_$(basename $file).txt"

  # ファイルタイプに応じたプロンプトを設定
  if [[ "$file" == *.ts || "$file" == *.tsx ]]; then
    FILE_TYPE="TypeScript"
  elif [[ "$file" == *.js || "$file" == *.jsx ]]; then
    FILE_TYPE="JavaScript"
  elif [[ "$file" == *.json ]]; then
    FILE_TYPE="JSON"
  elif [[ "$file" == *.yaml || "$file" == *.yml ]]; then
    FILE_TYPE="YAML"
  elif [[ "$file" == *.lock ]]; then
    FILE_TYPE="Lock file"
  elif [[ "$file" == *.tf || "$file" == *.hcl ]]; then
    FILE_TYPE="Terraform"
  elif [[ "$file" == *.py ]]; then
    FILE_TYPE="Python"
  elif [[ "$file" == *.sh ]]; then
    FILE_TYPE="Shell"
  elif [[ "$file" == *.md ]]; then
    FILE_TYPE="Markdown"
  else
    FILE_TYPE="text"
  fi

  # ファイルタイプをカウント
  case "$FILE_TYPE" in
    "TypeScript") ((COUNT_TYPESCRIPT++)) ;;
    "JavaScript") ((COUNT_JAVASCRIPT++)) ;;
    "JSON") ((COUNT_JSON++)) ;;
    "YAML") ((COUNT_YAML++)) ;;
    "Lock file") ((COUNT_LOCK++)) ;;
    "Terraform") ((COUNT_TERRAFORM++)) ;;
    "Python") ((COUNT_PYTHON++)) ;;
    "Shell") ((COUNT_SHELL++)) ;;
    "Markdown") ((COUNT_MARKDOWN++)) ;;
    *) ((COUNT_OTHER++)) ;;
  esac

  # Lockファイルの場合は特別な処理
  if [[ "$file" == *.lock ]]; then
    printf "  → Lockファイルのためスキップ\n"
    md_output "依存関係のバージョンがロックされました。これは通常、package.jsonの変更に伴う自動的な更新です。"
    md_output ""
    FILE_CHANGES_SUMMARIES+=("$file: 依存関係のバージョン更新")
    continue
  fi

  # 差分のサイズをチェック（10KB以上は切り詰める）
  DIFF_SIZE=$(wc -c <"$TEMP_DIR/diff_$(basename $file).txt")
  if [ "$DIFF_SIZE" -gt 10240 ]; then
    # 最初の100行と最後の50行だけ取得
    head -n 100 "$TEMP_DIR/diff_$(basename $file).txt" >"$TEMP_DIR/diff_truncated.txt"
    printf "\n... [差分が大きいため省略] ...\n" >>"$TEMP_DIR/diff_truncated.txt"
    tail -n 50 "$TEMP_DIR/diff_$(basename $file).txt" >>"$TEMP_DIR/diff_truncated.txt"
    DIFF_CONTENT=$(cat "$TEMP_DIR/diff_truncated.txt")
  else
    DIFF_CONTENT=$(cat "$TEMP_DIR/diff_$(basename $file).txt")
  fi

  # Gemini CLIで説明を生成
  PROMPT="以下は$FILE_TYPEファイル '$file' の git diff です。この変更内容を日本語で簡潔に説明してください。技術的な詳細も含めて、なぜこの変更が必要だったのかを推測して説明してください。

差分:
$DIFF_CONTENT"

  # Gemini APIを呼び出し（エラーハンドリング付き）
  printf "  → Gemini APIに問い合わせ中...\n"
  if OUTPUT=$(gemini -p "$PROMPT" 2>&1 </dev/null); then
    printf "  → 完了\n"
    md_output "$OUTPUT"
    md_output ""
    # サマリー用に変更内容を記録（最初の2行程度を抽出）
    SUMMARY_LINE=$(echo "$OUTPUT" | head -n 2 | tr '\n' ' ' | sed 's/  */ /g')
    FILE_CHANGES_SUMMARIES+=("$file: $SUMMARY_LINE")
  else
    printf "  → ${RED}エラー発生${NC}\n"
    md_output "**エラー**: Gemini APIの呼び出しに失敗しました"
    md_output "エラー詳細: $OUTPUT"
    md_output ""
    FILE_CHANGES_SUMMARIES+=("$file: エラーにより説明を生成できませんでした")
  fi
done

cd "$CURRENT_DIR"

# 全体サマリーの生成
printf "\n"
printf "${BLUE}全体サマリーを生成中...${NC}\n"

# ファイルタイプ統計の作成
FILE_TYPE_SUMMARY=""
[ $COUNT_TYPESCRIPT -gt 0 ] && FILE_TYPE_SUMMARY+="- TypeScript: ${COUNT_TYPESCRIPT}件\n"
[ $COUNT_JAVASCRIPT -gt 0 ] && FILE_TYPE_SUMMARY+="- JavaScript: ${COUNT_JAVASCRIPT}件\n"
[ $COUNT_JSON -gt 0 ] && FILE_TYPE_SUMMARY+="- JSON: ${COUNT_JSON}件\n"
[ $COUNT_YAML -gt 0 ] && FILE_TYPE_SUMMARY+="- YAML: ${COUNT_YAML}件\n"
[ $COUNT_LOCK -gt 0 ] && FILE_TYPE_SUMMARY+="- Lock file: ${COUNT_LOCK}件\n"
[ $COUNT_TERRAFORM -gt 0 ] && FILE_TYPE_SUMMARY+="- Terraform: ${COUNT_TERRAFORM}件\n"
[ $COUNT_PYTHON -gt 0 ] && FILE_TYPE_SUMMARY+="- Python: ${COUNT_PYTHON}件\n"
[ $COUNT_SHELL -gt 0 ] && FILE_TYPE_SUMMARY+="- Shell: ${COUNT_SHELL}件\n"
[ $COUNT_MARKDOWN -gt 0 ] && FILE_TYPE_SUMMARY+="- Markdown: ${COUNT_MARKDOWN}件\n"
[ $COUNT_OTHER -gt 0 ] && FILE_TYPE_SUMMARY+="- その他: ${COUNT_OTHER}件\n"

# 全ファイルの変更サマリーを結合
ALL_CHANGES_SUMMARY=""
for summary in "${FILE_CHANGES_SUMMARIES[@]}"; do
  ALL_CHANGES_SUMMARY+="$summary\n"
done

# Gemini APIで全体サマリーを生成
OVERALL_PROMPT="以下は、Gitブランチ '$BRANCH' の '$BASE_BRANCH' からの変更内容の概要です。これらの変更を総合的に分析し、以下の観点から日本語で説明してください：

1. **変更の主な目的**: このブランチで達成しようとしている主要な目標
2. **変更の種類**: 機能追加、バグ修正、リファクタリング、設定変更など
3. **影響範囲**: どのようなコンポーネントやシステムに影響があるか
4. **技術的な特徴**: 使用された技術的アプローチや設計パターン
5. **リスクや注意点**: レビュー時に特に注意すべき点があれば

## 変更統計
- 総ファイル数: $FILE_COUNT
- 追加行数: +$TOTAL_ADDED_LINES
- 削除行数: -$TOTAL_DELETED_LINES

## ファイルタイプ別統計
$FILE_TYPE_SUMMARY

## 各ファイルの変更概要
$ALL_CHANGES_SUMMARY"

printf "  → Gemini APIで全体サマリーを生成中...\n"
if OVERALL_SUMMARY=$(gemini -p "$OVERALL_PROMPT" 2>&1 </dev/null); then
  printf "  → ${GREEN}完了${NC}\n"
  # 一時ファイルを作成してサマリーセクションを挿入
  TEMP_MD=$(mktemp)
  sed "/$SUMMARY_PLACEHOLDER/r /dev/stdin" "$MD_FILE" <<EOF >"$TEMP_MD"
## 全体サマリー

$OVERALL_SUMMARY
EOF
  # プレースホルダーを削除
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "/$SUMMARY_PLACEHOLDER/d" "$TEMP_MD"
  else
    sed -i "/$SUMMARY_PLACEHOLDER/d" "$TEMP_MD"
  fi
  mv "$TEMP_MD" "$MD_FILE"
else
  printf "  → ${RED}エラー発生${NC}\n"
  # エラーの場合はプレースホルダーをエラーメッセージで置換
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/$SUMMARY_PLACEHOLDER/## 全体サマリー\n\n**エラー**: 全体サマリーの生成に失敗しました/" "$MD_FILE"
  else
    sed -i "s/$SUMMARY_PLACEHOLDER/## 全体サマリー\n\n**エラー**: 全体サマリーの生成に失敗しました/" "$MD_FILE"
  fi
fi

printf "\n"
printf "${BLUE}=== 変更内容の説明完了 ===${NC}\n"
printf "\n"
printf "${GREEN}マークダウンファイルが生成されました:${NC}\n"
printf "  → $MD_FILE\n"

md_output ""
md_output "---"
md_output ""
md_output "*このドキュメントは \`explain-commits-with-summary.sh\` により自動生成されました*"
