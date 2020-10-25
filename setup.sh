#!/usr/bin/env bash

command_exists() {
  type "$1" > /dev/null 2>&1
}

[[ -x `command -v wget` ]] && CMD="wget --no-check-certificate -O -"
[[ -x `command -v curl` ]] >/dev/null 2>&1 && CMD="curl -#L"

is_macos() {
  OS_NAME="$(uname -s)"
  if [ "$OS_NAME" != "Darwin" ]; then
    return 1  
  fi
  return 0
}

is_linux() {
  OS_NAME="$(uname -a)"
  if ["$OS_NAME" != "Linux" ]; then
    return 1
  fi
  return 0
}

if [ -z "$CMD" ]; then
  echo "No curl or wget available. Aborting."
  exit 1
fi
  

#echo " -> Check for brew and install"
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/michaweber/mydotfiles/master/install/brew.sh)"

echo " -> Installing dotfiles" 
DOTFILES_REP="$HOME/.dotfiles"
mkdir -p "$DOTFILES_REP"
cd "$DOTFILES_REP"
 
if git rev-parse --git-dir > /dev/null 2>&1; then
  echo " -> updating existing repository"
  git pull
else
  echo " -> cloning dotfiles repository"
  git clone git@github.com:michaweber/mydotfiles.git .
fi

if is_macos $1; then
  echo " -> Installing Apps through brew-cask"
  . "$DOTFILES_REP/install/brew-cask.sh"
fi
