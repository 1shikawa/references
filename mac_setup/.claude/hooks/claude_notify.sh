#!/bin/zsh
# ~/.claude/hooks/claude_notify.sh

TYPE="$1"
INPUT="$(cat -)"

# 作業ディレクトリ
WORKDIR=$(echo "$INPUT" | jq -r '.cwd // "unknown"')

# リポジトリ名（ディレクトリ名から取得）
REPO_NAME=$(basename "$WORKDIR")

# ブランチ名を取得
BRANCH_NAME=$(cd "$WORKDIR" 2>/dev/null && git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

# 通知メッセージ
MSG="$BRANCH_NAME"

SOUND_NAME="Glass"

# osascriptの引数として渡す（UTF-8対応）
osascript - "$MSG" "Claude Code ($TYPE)" "$REPO_NAME" "$SOUND_NAME" <<'EOF'
on run argv
    set theMessage to item 1 of argv
    set theTitle to item 2 of argv
    set theSubtitle to item 3 of argv
    set theSoundname to item 4 of argv
    display notification theMessage with title theTitle subtitle theSubtitle sound name theSoundname
end run
EOF
