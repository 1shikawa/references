## Functions

# fzf (Ctrl+T: ファイル検索)
export FZF_CTRL_T_COMMAND="fd --type f --max-depth 8"
export FZF_CTRL_T_OPTS="
    --select-1 --exit-0
    --tmux 80%
    --bind 'ctrl-l:execute(tmux splitw -h -- nvim {})'
    --bind '>:reload($FZF_ALT_C_COMMAND -H -E .git )'
    --bind '<:reload($FZF_ALT_C_COMMAND)'
    --preview 'bat -r :100 --color=always --style=header,grid {}'"

# fzf (Ctrl+F,Ctrl+F: ディレクトリ検索)
export FZF_ALT_C_COMMAND=$(cat <<"EOF"
( (type fd > /dev/null) &&
  fd --type d --max-depth 8 \
    --strip-cwd-prefix \
    --exclude '{node_modules}/**' ) \
  || $find_ignore d -print 2> /dev/null
EOF
)

function fzf-cd-widget() {
    local current_input="${LBUFFER}"
    local selected=$(eval "$FZF_ALT_C_COMMAND" | \
        fzf --reverse \
            --select-1 --exit-0 \
            --tmux 80% \
            --bind "tab:replace-query" \
            --preview 'tree -aC -L 2 {} | head -200'
    )
    # --bind "tab:replace-query,tab:reload(fd --type d --max-depth 1 --strip-cwd-prefix {})" \

    selected=$(echo "$selected" | sed -E 's/([() ])/\\\1/g')
    if [ -n "$selected" ]; then
        LBUFFER="$current_input$selected"
        zle redisplay
    fi
}
bindkey '^f^f' fzf-cd-widget



# Git Worktree管理ツール (git-gtr + gum + fzf)

# ヘルパー関数: ZLEがアクティブな場合のみzleを呼び出す
function _gwm_zle_if_active() {
    [[ -n "$WIDGET" ]] && zle "$@" 2>/dev/null
    return 0
}

# ヘルパー関数: デフォルトブランチを取得
function _gwm_get_default_branch() {
    local default_branch=""
    if git remote | grep -q .; then
        # リモートが存在する場合
        default_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    fi
    # リモートがない、またはHEADが設定されていない場合はローカルで判定
    if [[ -z "$default_branch" ]]; then
        # 1. init.defaultBranch設定を確認
        default_branch=$(git config --get init.defaultBranch 2>/dev/null)
        # 2. 設定がない、またはそのブランチが存在しない場合は一般的な名前を順にチェック
        if [[ -z "$default_branch" ]] || ! git rev-parse --verify "$default_branch" >/dev/null 2>&1; then
            for branch in main master trunk develop; do
                if git rev-parse --verify "$branch" >/dev/null 2>&1; then
                    default_branch="$branch"
                    break
                fi
            done
        fi
    fi
    echo "$default_branch"
}

# ヘルパー関数: メッセージ表示して待機
function _gwm_show_message_and_wait() {
    local message="$1"
    local color="${2:-220}"  # デフォルトは警告色

    gum style --foreground "$color" "$message"
    echo ""
    gum style --foreground 240 "Press any key to continue..."
    read -k1 -s
}

# ヘルパー関数: ブランチ名からworktreeのパスを取得
function _gwm_get_worktree_path() {
    local branch="$1"
    git worktree list --porcelain | awk -v branch="$branch" '
        /^worktree / { path = substr($0, 10) }
        /^branch / {
            b = substr($0, 8)
            gsub(/^refs\/heads\//, "", b)
            if (b == branch) { print path; exit }
        }
    '
}

# ヘルパー関数: worktreeディレクトリへ自動cd
function _gwm_cd_to_worktree() {
    local target="$1"
    local worktree_path=$(_gwm_get_worktree_path "$target")

    if [[ -z "$worktree_path" ]]; then
        gum style --foreground 196 "❌ Could not find worktree path for '$target'"
        return 1
    fi

    # 直接cdを実行
    builtin cd "$worktree_path"
    gum style --foreground 82 "📂 Changed to: $worktree_path"

    # ZLE環境の場合はプロンプトを再描画
    _gwm_zle_if_active reset-prompt
    return 0
}

# ヘルパー関数: worktreeリストから選択
# 引数: $1=default_branch, $2=exclude_default (true/false)
# 戻り値: 0=成功, 1=worktreeが存在しない, 2=キャンセルされた
function _gwm_select_worktree() {
    local default_branch="$1"
    local exclude_default="${2:-true}"

    local worktree_list=$(git gtr list --porcelain 2>/dev/null | \
        grep -v '^\[!\]' | \
        cut -f2 | \
        awk '{print $1}')

    # デフォルトブランチを除外する場合
    if [[ "$exclude_default" == "true" ]]; then
        worktree_list=$(echo "$worktree_list" | grep -v "^${default_branch}$")
    fi

    if [[ -z "$worktree_list" ]]; then
        return 1  # worktreeが存在しない
    fi

    # fzfで選択
    local selected=$(echo "$worktree_list" | \
        fzf --header "Select Worktree" \
            --reverse \
            --height 60% \
            --border rounded \
            --preview 'git log --oneline --graph --color=always {} 2>/dev/null | head -20' \
            --preview-window right:60%)

    if [[ -z "$selected" ]]; then
        return 2  # キャンセルされた
    fi

    echo "$selected"
    return 0
}

function git-worktree-manager() {
    # Gitリポジトリチェック
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "❌ Not a git repository"
        return 1
    fi

    # 必要なコマンドの存在確認
    if ! type git-gtr > /dev/null 2>&1; then
        echo "❌ git-gtr is not installed"
        return 1
    fi
    if ! type gum > /dev/null 2>&1; then
        echo "❌ gum is not installed"
        return 1
    fi

    # デフォルトブランチを取得
    local default_branch=$(_gwm_get_default_branch)

    # メインメニュー
    local action=$(gum choose \
        --header "Git Worktree Manager" \
        --cursor.foreground="212" \
        "📂 Open/Switch" \
        "✨ New Worktree" \
        "🗑️  Delete Worktree" \
        "📋 List All")

    if [[ -z "$action" ]]; then
        _gwm_zle_if_active reset-prompt
        return 0
    fi

    case "$action" in
        "✨ New Worktree")
            # 入力方法を選択
            local input_method=$(gum choose \
                --header "How to specify branch?" \
                "🔍 Search existing branches (local + remote)" \
                "✏️  Enter new branch name")

            if [[ -z "$input_method" ]]; then
                _gwm_zle_if_active reset-prompt
                return 0
            fi

            local branch_name=""

            if [[ "$input_method" == "🔍 Search existing branches (local + remote)" ]]; then
                # リモートブランチを含む全ブランチを取得（デフォルトブランチとoriginは除外）
                local branches=$(git branch -a --format='%(refname:short)' | \
                    sed 's|^origin/||' | \
                    grep -v '^HEAD' | \
                    grep -v '^origin$' | \
                    grep -v "^${default_branch}$" | \
                    sort -u)

                # fzfで選択
                branch_name=$(echo "$branches" | \
                    fzf --header "Select branch (local + remote)" \
                        --reverse \
                        --height 60% \
                        --border rounded \
                        --preview 'git log --oneline --graph --color=always {} 2>/dev/null | head -20' \
                        --preview-window right:60%)
            else
                # 手動入力
                branch_name=$(gum input \
                    --placeholder "Branch name (e.g. feature/login)" \
                    --prompt "🌿 " \
                    --width 50)
            fi

            if [[ -n "$branch_name" ]]; then
                # 確認ダイアログ
                if gum confirm "Create worktree '$branch_name'?"; then
                    # git-gtrコマンド実行（リモートがない場合は現在のブランチから作成）
                    local gtr_opts=()
                    if ! git remote | grep -q .; then
                        gtr_opts=(--from-current --no-fetch)
                    fi
                    if git gtr new "$branch_name" "${gtr_opts[@]}"; then
                        gum style --foreground 212 "✅ Created worktree: $branch_name"
                        # worktreeディレクトリへ自動cd
                        _gwm_cd_to_worktree "$branch_name"
                    else
                        gum style --foreground 196 "❌ Failed to create worktree"
                    fi
                fi
            fi
            ;;

        "📂 Open/Switch"|"🗑️  Delete Worktree")
            # worktreeを選択
            # Open/Switch: mainブランチ含む, Delete: mainブランチ除外
            local exclude_default="true"
            [[ "$action" == "📂 Open/Switch" ]] && exclude_default="false"

            local selected
            selected=$(_gwm_select_worktree "$default_branch" "$exclude_default")
            local ret=$?

            if [[ $ret -eq 1 ]]; then
                # worktreeが存在しない場合のみエラー表示
                if [[ "$action" == "🗑️ Delete Worktree" ]]; then
                    _gwm_show_message_and_wait "⚠️  No worktrees to delete (${default_branch} branch is protected)"
                else
                    _gwm_show_message_and_wait "⚠️  No worktrees found"
                fi
                _gwm_zle_if_active reset-prompt
                return 0
            elif [[ $ret -eq 2 ]]; then
                # キャンセルされた場合は静かに戻る
                _gwm_zle_if_active reset-prompt
                return 0
            fi

            # 選択されたブランチ名をそのまま使用
            local target="$selected"

            if [[ "$action" == "📂 Open/Switch" ]]; then
                # worktreeディレクトリへ自動cd
                _gwm_cd_to_worktree "$target"
            else
                # 削除確認
                if gum confirm "Really delete '$target'?" --affirmative "Delete" --negative "Cancel"; then
                    # 削除前にmainブランチのworktreeへ移動
                    local main_worktree_path=$(_gwm_get_worktree_path "$default_branch")
                    if [[ -n "$main_worktree_path" ]]; then
                        builtin cd "$main_worktree_path"
                        gum style --foreground 240 "📂 Moved to: $main_worktree_path"
                    fi

                    if git gtr rm "$target" --delete-branch --force --yes; then
                        gum style --foreground 212 "🗑️  Deleted: $target"
                    else
                        gum style --foreground 196 "❌ Failed to delete worktree"
                    fi
                fi
            fi
            ;;

        "📋 List All")
            # リスト表示
            git gtr list
            echo ""
            gum style --foreground 240 "Press any key to continue..."
            read -k1 -s
            ;;
    esac

    _gwm_zle_if_active reset-prompt
    return 0
}

zle -N git-worktree-manager
# Option+wでGit Worktreeマネージャーを起動
bindkey '^[w' git-worktree-manager
