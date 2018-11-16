#!/bin/bash

# See webpro installation script: https://github.com/webpro/dotfiles/blob/master/runcom/.bash_profile

for DOTFILE in $HOME/.dotfiles/system/.{alias,prompt}; do
  [ -f "$DOTFILE" ] && source $DOTFILE
done
