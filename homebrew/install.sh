#!/bin/bash

apps=(
    git@2.26.2
    wget@1.20.3
    bash@5.0.17
    vim@8.2.0800
    fzf@0.21.1
    tmux@3.1b
    exiftool@11.85
    ghi@1.2.0
    duck@7.3.1.32784
    ledger@3.2.1
)

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
# brew update

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

for app in ${apps[@]}
do
  app_name=$(echo "$app"|awk -F"@" '{print $1}')
  app_version=$(echo "$app"|awk -F"@" '{print $2}')
  version=$(brew info $app_name | sed -n "s/$app_name:\ \(.*\)/\1/p" |awk -F" " '{print $2}')
  if [[ "$app_version" != "$version" ]]; then
    echo "$app_name version is different, installing: $app"
    brew -v install $app
    if [[ $? -eq 1 ]]; then
      brew upgrade $app
      if [[ $? -eq 1 ]]; then
        echo "${red}${app} couldn't be installed or updated, skipping...${reset}"
      else 
        echo "${green}${app} upgraded successfully to ${version}${reset}"
      fi 
    else 
      echo "${green}${app} installed successfully${reset}"
    fi

  fi
done

# brew cleanup
