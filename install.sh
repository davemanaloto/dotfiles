#!/usr/bin/env bash
DOTFILES="${HOME}/.dotfiles"

function link_file {
    echo "Linking $1 -> $2"
    ln -s $1 $2
}

function rm_file {
    echo "Deleting $1"
    rm $1
}

function mv_file {
    echo "Moving $1 -> $2"
    mv $1 $2
}

function rotate_file {
    count=0
    new_target="$1.backup.$count"
    while [ -e $new_target ]
    do
        count=$(( $count + 1 ))
        new_target="$1.backup.$count"
    done
    echo "Moving $1 -> $new_target"
    mv $1 $new_target
}

function clean {
    echo "Force cleaning"
    files=(.editorconfig .tmux.conf .vim .vimrc .zshrc .zgen .fzf .fzf.bash fzf.zsh .tmux )
    for file in ${files[@]} ; do
        target="$HOME/$file"
        if [[ -L $target ]]; then
            rm_file $target
        elif [[ -e $target ]]; then
            rotate_file $target
        fi
    done
}

if [[ $1 = "clean" ]]; then
    clean
    exit
fi

# Setup symlinks
SYMLINKS=$( find $DOTFILES -name '*.symlink' )
for file in $SYMLINKS ; do
    target="$HOME/.$( basename $file '.symlink' )"
    if [[ ! -e $target ]]; then
        link_file $file $target
    fi
done

if [[ ! -d ~/.fzf ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --no-update-rc --key-bindings --completion
fi

if [[ ! -d ~/.tmux/plugins/tpm ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ~/.tmux/plugins/tpm/bin/install_plugins
fi

if [[ ! -d ~/.zgen ]]; then
    git clone https://github.com/tarjoilija/zgen.git ~/.zgen
fi

if [[ ! -f ~/local/bin/fasd ]]; then
    dir=`mktemp -d` && cd $dir

    if [[ ! -z $dir ]]; then
        git clone https://github.com/clvv/fasd.git $dir
        pushd $dir
        PREFIX=$HOME/local make install
        popd
        rm -rf $dir
    fi
fi

if [[ ! -d ~/.vim ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    cd ~/.vim
    INSTALLMODE=1 vim -i NONE -c PlugInstall -c quitall
fi

if [[ ! -d ~/.config/nvim ]]; then
    curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    link_file $HOME/.dotfiles/init.vim  $HOME/.config/nvim/init.vim
    INSTALLMODE=1 nvim -i NONE -c PlugInstall -c quitall
fi

if [[ `uname` == "Darwin" ]]; then
    if [[ -L ~/Library/Application\ Support/Karabiner/private.xml ]]; then
        rm ~/Library/Application\ Support/Karabiner/private.xml
    fi
    ln -s ~/.dotfiles/mac/private.xml ~/Library/Application\ Support/Karabiner/private.xml
fi

if [[ ! -d ~/local/nerd-fonts ]]; then
    git clone https://github.com/ryanoasis/nerd-fonts.git ~/local/nerd-fonts
    ~/local/nerd-fonts/install.sh
fi
