#!/bin/bash

# See webpro installation script: https://github.com/webpro/dotfiles/blob/master/runcom/.bash_profile

export EDITOR="subl -w"

# Homebrew (Apple Silicon)
#
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Load all current dotfiles
for DOTFILE in $HOME/projects/dotfiles/system/.{prompt,alias,work_aliases}; do
  [ -f "$DOTFILE" ] && source $DOTFILE
done

# Load all functions
for FUNCTION in $HOME/projects/dotfiles/functions/*.sh; do
  [ -f "$FUNCTION" ] && source $FUNCTION
done

## Symlink ssh config to ~/.ssh/config and Zellij layouts
#
config_link="$HOME/.ssh/config"
if [[ ! -L ${config_link} ]] && [[ ! -e ${config_link} ]]; then
  echo "Symlink de ssh config"
  ln -sv "/Users/$(whoami)/projects/dotfiles/ssh/config" ~/.ssh/config
fi

os_type=""
case "$OSTYPE" in
  darwin*) os_type="macos" ;;
  linux*)  os_type="linux" ;;
  *)       os_type="desconocido"
esac

echo "Symlink de Zellij templates para $os_type"
echo ""

if [[ $os_type == "macos" ]]; then
  two_panes_link="$HOME/.config/zellij/layouts/two_panes.kdl"
  if [[ ! -L ${two_panes_link} && ! -e ${two_panes_link} ]]; then
    echo "Symlink de Zellij ${two_panes_link} layout"
    ln -sv "/Users/$(whoami)/projects/dotfiles/zellij/layouts/two_panes.kdl" ~/.config/zellij/layouts/two_panes.kdl
  fi

  devaspros_link="$HOME/.config/zellij/layouts/devaspros.kdl"
  if [[ ! -L ${devaspros_link} && ! -e ${devaspros_link} ]]; then
    echo "Symlink de Zellij ${devaspros_link} layout"
    ln -sv "/Users/$(whoami)/projects/dotfiles/zellij/layouts/devaspros.kdl" ~/.config/zellij/layouts/devaspros.kdl
  fi

  personal_link="$HOME/.config/zellij/layouts/personal.kdl"
  if [[ ! -L ${personal_link} && ! -e ${personal_link} ]]; then
    echo "Symlink de Zellij ${personal_link} layout"
    ln -sv "/Users/$(whoami)/projects/dotfiles/zellij/layouts/personal.kdl" ~/.config/zellij/layouts/personal.kdl
  fi
elif [[ $os_type == "linux" ]]; then
  two_panes_link="$HOME/.config/zellij/layouts/two_panes.kdl"
  if [[ ! -L ${two_panes_link} && ! -e ${two_panes_link} ]]; then
    echo "Symlink de Zellij ${two_panes_link} layout"
    ln -sv "/home/$(whoami)/projects/dotfiles/zellij/layouts/two_panes.kdl" ~/.config/zellij/layouts/two_panes.kdl
  fi

  devaspros_link="$HOME/.config/zellij/layouts/devaspros.kdl"
  if [[ ! -L ${devaspros_link} && ! -e ${devaspros_link} ]]; then
    echo "Symlink de Zellij ${devaspros_link} layout"
    ln -sv "/home/$(whoami)/projects/dotfiles/zellij/layouts/devaspros.kdl" ~/.config/zellij/layouts/devaspros.kdl
  fi

  personal_link="$HOME/.config/zellij/layouts/personal.kdl"
  if [[ ! -L ${personal_link} && ! -e ${personal_link} ]]; then
    echo "Symlink de Zellij ${personal_link} layout"
    ln -sv "/home/$(whoami)/projects/dotfiles/zellij/layouts/personal.kdl" ~/.config/zellij/layouts/personal.kdl
  fi
fi

## Load git autocompletion script
#
# -f is for regular files. Those that can be created with `touch` command
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash

  # Git completion to aliases
  __git_complete g _git_main
  __git_complete ga _git_add
  __git_complete gcm _git_commit

  __git_complete gb _git_branch
  __git_complete gco _git_checkout
  __git_complete gmrg _git_merge

  __git_complete grbs _git_rebase

  __git_complete gps _git_push
  __git_complete gpl _git_pull
  __git_complete gf _git_fetch
fi

## Load NVM - Node Version Manager
#
# -d is for directories
if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"

  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

####
## MACOS
####

# Load chruby in macos M1 Ventura
#
if [ -d "/opt/homebrew/opt/chruby/share/chruby" ]; then
  source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
  source /opt/homebrew/opt/chruby/share/chruby/auto.sh
fi

# Load Image Magick
#
# This is for macos Ventura
if [ -d "/opt/homebrew/opt/imagemagick@6/bin" ]; then
  export PATH="/opt/homebrew/opt/imagemagick@6/bin:$PATH"
fi

# PostgreSQL@17 with Homebrew asked for this
#
# for macos Ventura
if [ -d "/opt/homebrew/opt/postgresql@17/bin" ]; then
  export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
fi

# Load ffmpeg
#
if [ -d "$HOME/ffmpeg" ]; then
  export PATH="$HOME/ffmpeg:$PATH"
fi

# Load yt-dlp
#
if [ -d "$HOME/yt-dlp" ]; then
  export PATH="$HOME/yt-dlp:$PATH"
fi

# Load OpenCode
#
if [ -d "/Users/francisco/.opencode/bin/" ]; then
  export PATH="/Users/francisco/.opencode/bin:$PATH"
fi

# Claude Code (instalador nativo) y otros binarios de usuario
#
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

####
## LINUX MINT
####

# Load chruby in Linux Mint
#
if [ -d "/usr/local/share/chruby/" ]; then
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh
fi

if [ -d "/home/cesc/Zellij" ]; then
  export PATH=$HOME/Zellij:$PATH
fi

if [ -d "/home/cesc/Delta" ]; then
  export PATH=$HOME/Delta:$PATH
fi

####
## GENERAL
####

# Make gpg commit signing work or evade problems
#
# See https://github.com/keybase/keybase-issues/issues/2798
export GPG_TTY=$(tty)

# Load Hub bash completion script
if [ -f ~/hub.bash_completion.sh ]; then
  . ~/hub.bash_completion.sh
fi

# Prevent when running scripts in a rails console it breaks.
#
export DISABLE_SPRING=true

## Configuración para nnn: https://github.com/jarun/nnn
#
# Estos son los colores de los contextos (paneles)
export NNN_COLORS="#0a1b2c3d"

# Estos son los colores para los archivos y directorios
export NNN_FCOLORS="c1e2272e006033f7c6d6abc4"

# Dracula https://draculatheme.com/nnn
# export NNN_FCOLORS="D4DEB778E79F9F67D2E5E5D2"

# export NNN_FIFO=/tmp/nnn.fifo
