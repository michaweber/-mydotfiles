#!/bin/bash

apps=(
    git
    wget
    bash
    vim
    fzf
    tmux
    exiftool
    ghi
    duck
    ledger
)

echo "Updating Homebrew requires sudo!"
sudo -v

# Check for Homebrew and install it if missing
if test ! $(which brew)
then
  echo "Looks like we need homebrew first, installing..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Ok, we got homebrew - let's go"
brew update

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

for app in ${apps[@]}
do
  brew -v install $app
  if [[ $? -eq 1 ]]; then
    version=$(brew info $app | sed -n "s/$app:\ \(.*\)/\1/p")
    brew upgrade $app
   if [[ $? -eq 1 ]]; then
      echo "${red}${app} couldn't be installed or updated, skipping...${reset}"
    else 
      echo "${green}${app} upgraded successfully to ${version}${reset}"
    fi 
  else 
    echo "${green}${app} installed successfully${reset}"
  fi
done

brew cleanup
