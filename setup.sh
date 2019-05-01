#!/usr/bin/env bash

  [[ -x `command -v wget` ]] && CMD="wget --no-check-certificate -O -"
  [[ -x `command -v curl` ]] >/dev/null 2>&1 && CMD="curl -#L"

  if [ -z "$CMD" ]; then
    echo "No curl or wget available. Aborting."
    exit 1
  fi
  
  echo "======= Installing dotfiles ========"
  DOTFILES_REP="$HOME/Code/src/github.com/michaweber/mydotfiles"
  mkdir -p "$DOTFILES_REP"
  cd "$DOTFILES_REP"
  git clone https://github.com/michaweber/mydotfiles.git .
