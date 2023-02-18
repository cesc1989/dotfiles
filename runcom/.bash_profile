#!/bin/bash

# See webpro installation script: https://github.com/webpro/dotfiles/blob/master/runcom/.bash_profile

for DOTFILE in $HOME/projects/dotfiles/system/.{alias,prompt}; do
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

  # This loads nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  # This loads nvm bash_completion
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# This is for the IW MBP - macOS Mojave
if [ -d "/Users/fquintero/Library/Python/2.7/bin" ]; then
  export PATH="$PATH:/Users/fquintero/Library/Python/2.7/bin"
fi

# Make gpg commit signing work or evade problems
#
# See https://github.com/keybase/keybase-issues/issues/2798
export GPG_TTY=$(tty)

# To change between several AWS accounts configured in `~/.aws/credentials`
#
# Examples:
#
#    $ setaws staging
#    $ setaws uat
setaws() {
  if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    echo "Example: setaws staging"
  else
    echo "Exporting aws profiles to: $1"
    export AWS_PROFILE=$1
    echo "export AWS_PROFILE=$1"
    export AWS_DEFAULT_PROFILE=$1
    echo "export AWS_DEFAULT_PROFILE=$1"
    export AWS_SDK_LOAD_CONFIG=1
  fi
}

# Make Postman available via command line
#
# This is for Linux Mint personal computer
if [ -d "/home/cesc/Postman" ]; then
  export PATH=$HOME/Postman:$PATH
fi

# Load RVM into a shell session as a function
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Load Image Magick
#
# This is for macos Ventura
if [ -d "/opt/homebrew/opt/imagemagick@6/bin" ]; then
  export PATH="/opt/homebrew/opt/imagemagick@6/bin:$PATH"
fi

# Load Hub bash completion script
if [ -f ~/hub.bash_completion.sh ]; then
  echo "aqui estoy"
  . ~/hub.bash_completion.sh
fi
