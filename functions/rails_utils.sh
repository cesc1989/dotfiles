#!/usr/bin/env bash

## Print the installed gem version
#
# Use:
#     cat_gemfile [GEM_NAME]
function cat_gemfile() {
  cat Gemfile.lock | grep $1
}

## Kills rails server on port 3000
function matar_servidor_rails() {
  kill -9 $(lsof -i tcp:3000 -t)
}
