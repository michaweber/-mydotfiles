#!/bin/bash

echo "Updating Homebrew Casks may require sudo!"
sudo -v

# Packages 
apps=(
    little-snitch
    alfred
    appzapper
    balsamiq-mockups
    cryptomator
    docker
    gemini
    imageoptim
    1password
    dropbox
    icloud-control
    google-drive-file-stream
    printopia
    cyberduck
    mountain-duck
    synergy
    soulver
    jetbrains-toolbox
    noteplan
    postico
    paw
    data-rescue
    dash
    iterm2
    firefox
    firefox-nightly
    google-chrome
    google-chrome-canary
    resilio-sync
#    kaleidoscope # https://www.kaleidoscopeapp.com
    slack
    transmit
# Quick Look Plugins (https://github.com/sindresorhus/quick-look-plugins)
    qlcolorcode 
    qlstephen 
    qlmarkdown 
    quicklook-json 
    qlprettypatch 
    quicklook-csv 
    betterzip
    qlimagesize 
    webpquicklook 
    suspicious-package
)


# Install Caskroom
brew tap homebrew/cask-cask
brew tap caskroom/versions

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

for cask in ${apps[@]}
do
  brew cask install $cask
  if [[ $? -eq 1 ]]; then
    version=$(brew cask info $cask | sed -n "s/$cask:\ \(.*\)/\1/p")
    brew cask upgrade $cask
   if [[ $? -eq 1 ]]; then
      echo "${red}${cask} couldn't be installed or updated, skipping...${reset}"
    else 
      echo "${green}${cask} upgraded successfully to ${version}${reset}"
    fi 
  else 
    echo "${green}${cask} installed successfully${reset}"
  fi
done
