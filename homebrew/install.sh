#!/bin/bash

echo "Updating Homebrew requires sudo!"
sudo -v



# Check for Homebrew and install it if missing
if test ! $(which brew)
then
  echo "Looks like we need homebrew first, installing..."
  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
  fi
fi

echo "Ok, we got homebrew - let's go"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

brew bundle --file $DIR/Brewfile
brew bundle cleanup -f --file $DIR/Brewfile

