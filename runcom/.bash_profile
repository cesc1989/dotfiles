#!/bin/bash

# See webpro installation script: https://github.com/webpro/dotfiles/blob/master/runcom/.bash_profile

set -e

DOTFILES_DIR="$HOME/.dotfiles"

for DOTFILE in "$DOFTILES_DIR"/system/.{alias,prompt}; do
  [ -f “$DOTFILE” ] && source “$DOTFILE”
done
