#!/bin/bash

echo "copy fonts"
if [[ ! -d "~/.local/share/fonts" ]]; then
    mkdir -p ~/.local/share/fonts
fi
cp -r ~/.dotfiles/fonts/*.* ~/.local/share/fonts
