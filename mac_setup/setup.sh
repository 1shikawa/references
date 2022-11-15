# HomeBrewのインストール
if [ ! -x "`which brew`" ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update
fi

# mas-cliのインストール
if [ ! -x "`which mas`" ]; then
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

brew install google-japanese-ime --cask
brew install google-chrome       --cask
# brew install firefox             --cask
brew install dropbox             --cask
# brew install skype               --cask
brew install cheatsheet          --cask
brew install visual-studio-code  --cask
brew install docker              --cask
brew install iterm2              --cask
brew install macdown             --cask
brew install authy               --cask
brew install notable             --cask
brew install postico             --cask
brew install arduino             --cask
# brew install sequel-pro          --cask
brew install brooklyn            --cask
brew install insomnia            --cask
# brew install discord             --cask
brew install wireshark           --cask
brew install toggl-track         --cask
brew install lens                --cask
# brew install clipy               --cask
brew install warp                --cask # ternimal
brew install raycast             --cask # rancher
brew install tableplus           --cask # sql client

brew tap aws/tap
brew tap jhawthorn/fzy # enhancd
brew install git
brew install wget
brew install asdf
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
brew install krew
brew install graphviz
brew install fzy ccat percol fzf # enhancd
brew install exa
brew install bat
brew install infracost # for terraform
brew install terraformer # for terraform

