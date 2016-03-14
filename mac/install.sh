#!/usr/bin/env sh

# Install brew
if ! hash brew 2>/dev/null; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap caskroom/cask
fi

PACKAGES=(
ag
curl
dark-mode
ffind
neovim/neovim/neovim
node
tmux
wget
)

for pkg in ${PACKAGES[@]} ; do
    brew install $pkg
done

# Install cask
CASK_PACKAGES=(
1password
alfred
docker
dropbox
evernote
firefox
google-chrome
karabiner
seil
spectacle
spotify
sublime-text
utorrent
vagrant
virtualbox
vlc
)

for pkg in ${CASK_PACKAGES[@]} ; do
    brew cask install $pkg
done

if ! hash bower ; then
    npm intstall -g bower
fi
