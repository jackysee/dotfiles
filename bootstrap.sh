#!/bin/bash


echo "add ppa"
sudo add-apt-repository ppa:jonathonf/vim -y

echo "install apt packages"
sudo apt install -q -y \
    build-essential \
    zsh \
    git \
    htop \
    tmux \
    silversearh-ag \
    less \
    jq \
    curl \
    python3 \
    python3-pip \
    ruby-full \
    tree \
    wget \
    vim-gtk \
    --no-install-recommends \

# install-dot.sh
# install-fonts.sh

echo "install tmuxinator"
gem install tmuxinator


echo "change default shell to zsh"
chsh -s $(which zsh)


echo "Relogin with zsh to install tools."
echo "set up .gitconfig.local / .hgrc.local "
echo "Open vim to install plugin via zplug."
