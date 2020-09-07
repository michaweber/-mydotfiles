#!/bin/bash

echo "Updating Homebrew requires sudo!"
sudo -v



# Check for Homebrew and install it if missing
if test ! $(which brew)
then
  echo "Looks like we need homebrew first, installing..."
  # Install the correct homebrew for each OS type
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  # if test "$(uname)" = "Darwin"
  # then
  #   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  # elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  # then
  #   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
  # fi
fi

echo "Ok, we got homebrew - let's go"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

brew bundle --file $DIR/Brewfile
brew bundle cleanup -f --file $DIR/Brewfile

echo "Cleaning AppStore Apps"
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for app in `mas list`;do
  id=$(echo "$app"|awk -F" " '{print $1}')
  grep -q "$id" $DIR/Brewfile
  found=$?
  if [[ $found -eq 1 ]];then
    sudo mas uninstall $id
  fi
done
IFS=$SAVEIFS

if test "$(uname)" = "Darwin"
then
  echo "Looking for Deleted Apps in Trash and removing them"
  sudo find /private/var/root/.Trash -name '*.app' -exec rm -rf "{}" \;
fi
