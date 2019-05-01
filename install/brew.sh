#!/bin/bash

# Ask for the administrator password upfront
sudo -v

# Check for Homebrew and install it if missing
if test ! $(which brew)
then
  echo "Looks like we need homebrew first, installing..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Ok, we got homebrew - let's go"
brew update
brew upgrade --all

apps=(
    wget
)

brew install "${apps[@]}"

brew cleanup
