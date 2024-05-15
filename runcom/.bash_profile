#!/bin/bash

# See webpro installation script: https://github.com/webpro/dotfiles/blob/master/runcom/.bash_profile

# Load all current dotfiles
for DOTFILE in $HOME/projects/dotfiles/system/.{prompt,alias,work_aliases,functions}; do
  [ -f "$DOTFILE" ] && source $DOTFILE
done

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
## PYTHON STUFF
####

# Load Python 2 - for node-sass
#
# This is for macOS Mojave
if [ -d "$HOME/Library/Python/2.7/bin" ]; then
  export PATH="$PATH:/Users/fquintero/Library/Python/2.7/bin"
fi

# Load pyenv
#
# This is for macOS Ventura (v13)
if [ -d "$HOME/.pyenv/shims" ]; then
  export PATH="$HOME/.pyenv/shims:${PATH}"
fi

# Load pipenv
#
# As explained here https://pipenv.pypa.io/en/latest/installation/#preferred-installation-of-pipenv
export PATH="$HOME/.local/bin:${PATH}"

####
## END PYTHON STUFF
####

# Make gpg commit signing work or evade problems
#
# See https://github.com/keybase/keybase-issues/issues/2798
export GPG_TTY=$(tty)

# To change between several AWS accounts configured in `~/.aws/config`
#
# Example:
#
#    $ setaws alpha
setaws() {
  if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "Example: setaws alpha"
  else
    echo "Exporting aws profiles to: $1"
    export AWS_PROFILE=$1
  fi
}

# Make Postman available via command line
#
# This is for Linux Mint personal computer
if [ -d "/home/cesc/Postman" ]; then
  export PATH=$HOME/Postman:$PATH
fi

# Load chruby in macos M1 Ventura
#
if [ -d "/opt/homebrew/opt/chruby/share/chruby" ]; then
  # chruby ruby-3.0.2

  source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
  source /opt/homebrew/opt/chruby/share/chruby/auto.sh
fi

# Load chruby in Linux Mint
#
if [ -d "/usr/local/share/chruby/" ]; then
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh
fi

# Load Image Magick
#
# This is for macos Ventura
if [ -d "/opt/homebrew/opt/imagemagick@6/bin" ]; then
  export PATH="/opt/homebrew/opt/imagemagick@6/bin:$PATH"
fi

# Load Hub bash completion script
if [ -f ~/hub.bash_completion.sh ]; then
  . ~/hub.bash_completion.sh
fi

# Load logcli for Luna x_logs script
if [ -d "$HOME/log-cli" ]; then
  export PATH="$HOME/log-cli:$PATH"
fi

# Luna CLI configuration
if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin/:$PATH"
  [[ \$commands[luna] ]] && source <(luna completion bash)
fi

# Setup asdf if .asdf folder exists
#
# See https://asdf-vm.com/guide/getting-started.html
if [ -d "$HOME/.asdf" ]; then
  . "$HOME/.asdf/asdf.sh"
  . "$HOME/.asdf/completions/asdf.bash"
fi

# Grimoire stuff
export KERL_CONFIGURE_OPTIONS="--disable-debug --disable-silent-rules --without-javac --enable-shared-zlib --enable-dynamic-ssl-lib --enable-threads --enable-kernel-poll --enable-wx --enable-webview --enable-darwin-64bit --enable-gettimeofday-as-os-system-time"
