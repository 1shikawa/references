if [ "$(uname -m)" = "arm64" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export PATH="/opt/homebrew/bin:$PATH"

  . /opt/homebrew/opt/asdf/libexec/asdf.sh
else
  eval "$(/usr/local/bin/brew shellenv)"

  export ASDF_DATA_DIR=~/.asdf_x86
  . /usr/local/opt/asdf/libexec/asdf.sh
fi

bindkey -v
autoload -U compinit
compinit -u

export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=100000
setopt extended_history

alias cls="clear"
# alias ls='exa -hGF --icons'
alias ls='exa -h --icons --git'
# alias lt='exa -h -T -L 3 -a -I "node_modules|.git|.cache" --icons'
alias lt='exa -h -T -L 3 -a -I "node_modules|.git|.cache" -l --icons --git'
alias lsa="ls -la"
alias cat='bat -p'
alias tf='terraform'

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
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
    print -P "%F{33} %F{34}Installation successful.%f%b" || \
    print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
##### End of Zinit's installer chunk

zinit light johnhamelink/env-zsh
zinit light scmbreeze/scm_breeze
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting
zinit light mollifier/anyframe

bindkey '^f' anyframe-widget-cdr
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
bindkey '^r' anyframe-widget-execute-history
bindkey '^b' anyframe-widget-checkout-git-branch
bindkey '^g' anyframe-widget-cd-ghq-repository
bindkey '^k' anyframe-widget-kill

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

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /Users/ishikawa/.asdf_x86/installs/terraform/1.1.7/bin/terraform terraform
source ~/enhancd/init.sh

ZSH_THEME="powerlevel10k/powerlevel10k"

eval "$(starship init zsh)"

##### kube-ps1 #####
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
PROMPT='$(kube_ps1)'$PROMPT
