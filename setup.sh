#!/usr/bin/env bash

command_exists() {
  type "$1" > /dev/null 2>&1
}

[[ -x `command -v wget` ]] && CMD="wget --no-check-certificate -O -"
[[ -x `command -v curl` ]] >/dev/null 2>&1 && CMD="curl -#L"

is_macos() {
  declare -r OS_NAME="$(uname -s)"
  if [ "$OS_NAME" != "Darwin" ]; then
    return 1  
  fi
  return 0
}

if [ -z "$CMD" ]; then
  echo "No curl or wget available. Aborting."
  exit 1
fi
  
echo "======= Installing dotfiles ========"
DOTFILES_REP="$HOME/.dotfiles"
mkdir -p "$DOTFILES_REP"
cd "$DOTFILES_REP"
 
if is_macos $1; then
  echo " -> checking for if xcode commandline tools exist"
  xcode-select -p 1>/dev/null
  ret=$?
  if [ $ret -eq 2 ]; then
    echo " -> install xcode comandline Tools"
    xcode-select --install
  fi
fi

if git rev-parse --git-dir > /dev/null 2>&1; then
  echo " -> updating existing repository"
  git pull
else
  git clone https://github.com/michaweber/mydotfiles.git .
fi

. "$DOTFILES_REP/install/brew.sh"

# if is_macos $1; then
#   . "$DOTFILES_REP/install/brew-cask.sh"
# fi
