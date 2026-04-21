# HomeBrewのインストール
if [ ! -x "$(which brew)" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew update
fi

# mas-cliのインストール
if [ ! -x "$(which mas)" ]; then
  brew install mas
fi

mas install 539883307  # LINE
mas install 803453959  # Slack
mas install 406056744  # Evernote
mas install 425955336  # Skitch
mas install 1176895641 # Spark
mas install 1278508951 # Trello
mas install 414855915  # WinArchiver Lite
mas install 1407015686 # Paste Plain Text
mas install 405399194  # Kindle
mas install 1429033973 # RunCat
mas install 1333542190 # 1Password 7
mas install 1339170533 # CleanMyMac X

brew install google-japanese-ime --cask # ime
brew install azookey --cask # ime
# brew install google-chrome --cask
# brew install firefox --cask
# brew install dropbox --cask
# brew install skype --cask
brew install cheatsheet --cask
brew install visual-studio-code --cask
brew install docker --cask
brew install iterm2 --cask
brew install macdown --cask
brew install authy --cask
brew install notable --cask
brew install postico --cask
brew install arduino --cask
# brew install sequel-pro --cask
brew install brooklyn --cask
brew install insomnia --cask
# brew install discord --cask
brew install wireshark --cask
brew install toggl-track --cask
brew install lens --cask # manage k8s
# brew install clipy --cask
brew install warp --cask    # ternimal
brew install ghostty --cask    # ternimal
brew install raycast --cask # rancher
# brew install tableplus --cask # db client
# brew install arc --cask       # cronium browser
brew install applite --cask  # manage homebrew cask app
brew install orbstack --cask # for Docker desktop replacement
# brew install cursor --cask    # AI editor
# /Applications/Visual Studio Code.app/Contents/Resources/app/bin/code - > /Applications/Cursor.app/Contents/Resources/app/bin/code
brew install keyclu --cask     # shortcuts cheet sheet
brew install sequel-ace --cask # db client
brew install sidekick --cask   # sidekick
brew install --cask drawio
brew install --cask cleanshot # cleanshot x

brew tap aws/tap
brew tap jhawthorn/fzy # enhancd
brew install git
brew install wget
# brew install asdf
brew install mise
brew install nvm
brew install postgresql
brew install mysql
brew install peco
brew install z
brew install ghq
brew install starship
brew install docker-compose
brew install yarn
brew install hub
brew install hey
brew install imagemagick
brew install stoplight-studio
brew install awscli
brew install aws-sam-cli
brew install openssh
brew install gh
brew install jquery
brew install kube-ps1
brew install graphviz
brew install zplug
brew install fzy ccat percol fzf           # for enhancd
brew install exa                           # for rich ls
brew install bat                           # for rich cat
brew install infracost                     # for terraform
brew install terraformer                   # for terraform
brew install hidetatz/tap/kubecolor        # for kubectl
brew install future-architect/tap/tftarget # for Terraform -target
brew install ecsgo                         # for AWS ECS terminal
brew install keidarcy/tap/e1s              # for AWS ECS k9s like terminal
bure install eks-node-viewer               # for AWS EKS
brew install localstack/tap/localstack-cli # for AWS localstack

# https://krew.sigs.k8s.io/docs/user-guide/setup/install/
# brew install krew # for kubectl pkg manager
