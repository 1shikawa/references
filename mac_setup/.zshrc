if [ "$(uname -m)" = "arm64" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  export PATH="/opt/homebrew/bin:$PATH"

  . /opt/homebrew/opt/asdf/libexec/asdf.sh
else
  eval "$(/usr/local/bin/brew shellenv)"

  export ASDF_DATA_DIR=~/.asdf_x86
  . /usr/local/opt/asdf/libexec/asdf.sh
fi

eval "$(starship init zsh)"

bindkey -v
autoload -U compinit
compinit -u

export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=100000
setopt extended_history

alias cls="clear"
alias lsa="ls -la"
# alias be='bundle exec'
# alias get_idf='. $HOME/esp/esp-idf/export.sh'
# alias arm64e='arch -arm64e zsh'
# alias x86_64='arch -x86_64 zsh'


# kubernetes
alias k="kubectl"
alias kc='kubectx | peco | xargs kubectx'
alias kn='kubens | peco | xargs kubens'

# ghq+peco+vscode
alias ghcd='code $(ghq root)/$(ghq list | peco)'

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

##### kube-ps1 #####
source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
PROMPT='$(kube_ps1)'$PROMPT

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
