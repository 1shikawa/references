eval "$(mise activate zsh)"
export PATH="$HOME/.local/share/mise/shims:$PATH"

# zsh plugin manager
eval "$(sheldon source)"

eval "$(zoxide init zsh)"

# bindkey -v
autoload -U compinit
compinit -u
source /Users/toru_ishikawa/.config/zsh/plugins/git-worktree-manager.zsh
bindkey '^[w' git-worktree-manager

# export HISTFILE=${HOME}/.zsh_history
# export HISTSIZE=1000
# export SAVEHIST=100000
# setopt extended_history

# alias cd=z
alias cls="clear"
alias ei="eza --icons --git"
alias ea="eza -la --icons --git"
alias ee="eza -aahl --icons --git"
alias et="eza -T -L 3 -a -I 'node_modules|.git|.cache' --icons"
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git'
alias lt='eza --tree --level=2 --icons'
alias cat=bat
alias grep=rg

# alias lsa='ls -la'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gui='gitui'
alias tf='terraform'
alias tg='terragrunt --log-disable'
# alias gcld='gcloud'
alias d='docker'
alias dc='docker compose'
alias cl='cd "$(git rev-parse --show-toplevel 2>/dev/null || echo "$(pwd)")" && claude'
alias claude='claude --dangerously-skip-permissions'
alias yolo='claude --dangerously-skip-permissions --effort max'
alias gemi='gemini'
alias chp='change_project'
function change_project() {
  gcloud config configurations activate $(gcloud config configurations list | awk '{print $1}' | grep -v NAME | peco)
}

# kubernetes
alias k="kubectl"
alias kc='kubectx | peco | xargs kubectx'
alias kn='kubens | peco | xargs kubens'
alias ppy="popeye"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# ghq+peco+etc
alias ghcd='cd $(ghq root)/$(ghq list | peco)'
alias ghcde='code $(ghq root)/$(ghq list | peco)'

###### Added by Zinit's installer
# if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
#   print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
#   command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
#   command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
#     print -P "%F{33} %F{34}Installation successful.%f%b" || \
#     print -P "%F{160} The clone has failed.%f%b"
# fi

# source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
# autoload -Uz _zinit
# (( ${+_comps} )) && _comps[zinit]=_zinit
##### End of Zinit's installer chunk

# zinit light johnhamelink/env-zsh

# zinit light scmbreeze/scm_breeze
# zinit light zsh-users/zsh-autosuggestions
# zinit light zdharma/fast-syntax-highlighting
# zinit light mollifier/anyframe

# bindkey '^f' anyframe-widget-cdr
# autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
# add-zsh-hook chpwd chpwd_recent_dirs
# bindkey '^r' anyframe-widget-execute-history
# bindkey '^b' anyframe-widget-checkout-git-branch
# bindkey '^g' anyframe-widget-cd-ghq-repository
# bindkey '^k' anyframe-widget-kill

source <(kubectl completion zsh)

###### AWS MFA SESSION TOKEN #####
set-awssession-token() {
    profile_name=$1
    code=$2

    mfa_device=$(cat ~/.aws/config | grep -A 4 $profile_name | grep mfa-device | cut -f 3 -d " ")
    session_token=$(aws sts get-session-token --serial-number $mfa_device --token-code $code --profile $profile_name)
    export AWS_ACCESS_KEY_ID=$(echo $session_token | jq -r .Credentials.AccessKeyId)
    export AWS_SECRET_ACCESS_KEY=$(echo $session_token | jq -r .Credentials.SecretAccessKey)
    export AWS_SESSION_TOKEN=$(echo $session_token | jq -r .Credentials.SessionToken)
    env | grep AWS
    echo "vim ~/.aws/credentials"
    echo "[oca-aws-mfa"]
}

release-awssession-token() {
    export -n AWS_ACCESS_KEY_ID
    export -n AWS_SECRET_ACCESS_KEY
    export -n AWS_SESSION_TOKEN
}
###################################

###### AWS MFA SESSION TOKEN 2 ######
function _aws_get_session_token() {
    local PROFILE_NAME=$1
    local MFA_TOKEN_CODE=$2
    local DURATION_SECONDS=43200

    # プロファイル, mfa
    if [ $# -ne 2 ]; then
        echo "引数が足りません"
        return 1
    fi

    local TARGET_AWS_ACCOUNT_ID=$(aws sts get-caller-identity \
        --query 'Account' \
        --output text \
        --profile $PROFILE_NAME \
        )

    local SERIAL_NUMBER=$(aws sts get-caller-identity \
        --query 'Arn' \
        --output text \
        --profile $PROFILE_NAME \
        | sed -e s/:user/:mfa/g
        )

    local SESSION_TOKEN=$(aws sts get-session-token \
        --duration-seconds ${DURATION_SECONDS} \
        --serial-number $SERIAL_NUMBER \
        --token-code $MFA_TOKEN_CODE \
        --profile $PROFILE_NAME \
        )

    echo "${TARGET_AWS_ACCOUNT_ID} MFA Authentication Success. (${SERIAL_NUMBER})"

    _unset_aws_session_token

    export AWS_ACCESS_KEY_ID=$(echo $SESSION_TOKEN | jq -r .Credentials.AccessKeyId)
    export AWS_SECRET_ACCESS_KEY=$(echo $SESSION_TOKEN | jq -r .Credentials.SecretAccessKey)
    export AWS_SESSION_TOKEN=$(echo $SESSION_TOKEN | jq -r .Credentials.SessionToken)
}

function _unset_aws_session_token() {
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
}

# エイリアスコマンド
alias mfa_session_token="_aws_get_session_token oca-aws"

##############################################

# autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C /Users/ishikawa/.asdf_x86/installs/terraform/1.1.7/bin/terraform terraform
# source ~/enhancd/init.sh

# ZSH_THEME="powerlevel10k/powerlevel10k"


##### kube-ps1 #####
# source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
# PROMPT='$(kube_ps1)'$PROMPT

# eval "$(~/.local/bin/mise activate zsh)"
# BEGIN_AWS_SSO_CLI

# AWS SSO requires `bashcompinit` which needs to be enabled once and
# only once in your shell.  Hence we do not include the two lines:
#
# autoload -Uz +X compinit && compinit
# autoload -Uz +X bashcompinit && bashcompinit
#
# If you do not already have these lines, you must COPY the lines
# above, place it OUTSIDE of the BEGIN/END_AWS_SSO_CLI markers
# and of course uncomment it

# __aws_sso_profile_complete() {
#      local _args=${AWS_SSO_HELPER_ARGS:- -L error}
#     _multi_parts : "($(/Users/toru_ishikawa/.local/share/mise/installs/aws-sso-cli/1.17/bin/aws-sso ${=_args} list --csv Profile))"
# }

# aws-sso-profile() {
#     local _args=${AWS_SSO_HELPER_ARGS:- -L error}
#     if [ -n "$AWS_PROFILE" ]; then
#         echo "Unable to assume a role while AWS_PROFILE is set"
#         return 1
#     fi
#
#     if [ -z "$1" ]; then
#         echo "Usage: aws-sso-profile <profile>"
#         return 1
#     fi
#
#     eval $(/Users/toru_ishikawa/.local/share/mise/installs/aws-sso-cli/1.17/bin/aws-sso ${=_args} eval -p "$1")
#     if [ "$AWS_SSO_PROFILE" != "$1" ]; then
#         return 1
#     fi
# }

# aws-sso-clear() {
#     local _args=${AWS_SSO_HELPER_ARGS:- -L error}
#     if [ -z "$AWS_SSO_PROFILE" ]; then
#         echo "AWS_SSO_PROFILE is not set"
#         return 1
#     fi
#     eval $(/Users/toru_ishikawa/.local/share/mise/installs/aws-sso-cli/1.17/bin/aws-sso ${=_args} eval -c)
# }

# Fix for _safe_eval function missing issue
# _safe_eval() {
#   eval "$@"
# }

# compdef __aws_sso_profile_complete aws-sso-profile
# complete -C /Users/toru_ishikawa/.local/share/mise/installs/aws-sso-cli/1.17/bin/aws-sso aws-sso

# END_AWS_SSO_CLI

# GitHub mcp server
export GITHUB_PERSONAL_ACCESS_TOKEN="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"

# https://github.com/yukukotani/mcp-gemini-google-search
# Vertex AI for gemini mcp server
export GEMINI_PROVIDER="vertex"
export VERTEX_PROJECT_ID="dev-eb-sol-pf"
export VERTEX_LOCATION="us-central1"  # Optional (default: us-central1)
export GEMINI_MODEL="gemini-2.5-flash"  # Optional (default: gemini-2.5-flash)

# Pal mcp server
export GEMINI_API_KEY="AIzaSyDyAxMqCz_irpSLeCcLNEEk93bQcz69pZU"


# Added by CodeRabbit CLI installer
export PATH="/Users/toru_ishikawa/.local/bin:$PATH"

# Task Master aliases added on 10/18/2025
alias tm='task-master'
alias taskmaster='task-master'

# Git worktree
export PATH="$PATH:/Users/toru_ishikawa/ghq/github.com/coderabbitai/git-worktree-runner/bin"
source /Users/toru_ishikawa/.config/op/plugins.sh
source /Users/toru_ishikawa/.config/zsh/plugins/git-worktree-manager.zsh
alias gw='git-worktree-manager'
bindkey '^[w' git-worktree-manager

export PATH="$PATH:/Users/toru_ishikawa/.local/share/mise/shims/coreutils"

eval "$(starship init zsh)"

# bun completions
[ -s "/Users/toru_ishikawa/.bun/_bun" ] && source "/Users/toru_ishikawa/.bun/_bun"

alias claude-mem='/Users/toru_ishikawa/.bun/bin/bun "/Users/toru_ishikawa/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs"'
source ~/.safe-chain/scripts/init-posix.sh # Safe-chain Zsh initialization script
