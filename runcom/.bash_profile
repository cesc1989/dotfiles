#!/bin/bash

# See webpro installation script: https://github.com/webpro/dotfiles/blob/master/runcom/.bash_profile

for DOTFILE in $HOME/.dotfiles/system/.{alias,prompt}; do
  [ -f "$DOTFILE" ] && source $DOTFILE
done

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
  
  # Add git completion to aliases
  __git_complete g _git_main
  __git_complete ga _git_add
  # __git_complete gaA _git_add
  __git_complete gcm _git_commit
  # __git_complete gcma _git_commit

  __git_complete gb _git_branch
  # __git_complete gbd _git_branch
  # __git_complete gcob _git_checkout
  __git_complete gco _git_checkout
  __git_complete gmrg _git_merge
  __git_complete grbs _git_rebase

  __git_complete gps _git_push
  __git_complete gpl _git_pull
  __git_complete gf _git_fetch
fi
