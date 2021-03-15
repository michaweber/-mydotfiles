#!/bin/bash

is_macArm() {
  OS_NAME="$(uname -s)"
  PROC_ARCH="$(uname -m)"
  if [ "$OS_NAME" != "Darwin" ]; then
    if [ "${PROC_ARCH}" = "arm64" ]; then
      echo "Apple silicon mac with arm64 architecture"
      return 1 # Apple silicon with arm64
    elif [ "${PROC_ARCH}" = "x86_64" ]; then
      echo "Intel-based mac with x86_64 architecture or Rosetta2 translated process"
      if [ "$(sysctl -in sysctl.proc_translated)" = "1" ]; then
        echo "Running on Rosetta 2" 
        return 1 
      else
        echo "Running on native Intel"
      fi
    else
      echo "Unknown architecture: ${PROC_ARCH}"
    fi  
  fi
  return 0
}

is_linux() {
  OS_NAME="$(uname -s)"
  if [ "$OS_NAME" != "Linux" ]; then
    return 1
  fi
  return 0
}

is_macos() {
  OS_NAME="$(uname -s)"
  if [ "$OS_NAME" != "Darwin" ]; then
    return 1  
  fi
  return 0
}

if command -v sudo &> /dev/null
then
    echo "Updating Homebrew requires sudo!"
    sudo -v
fi

[[ -x `command -v wget` ]] && CMD="wget --no-check-certificate -O -"                                                                                               
[[ -x `command -v curl` ]] >/dev/null 2>&1 && CMD="curl -#L"                                                                                                       
                                                                                                                                                                   
# Check for Homebrew and install it if missing
if test ! $(which brew)
then
  echo "Looks like we need homebrew first, installing..."
  # Install the correct homebrew for each OS type
  /bin/bash -c "$($CMD https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  # if test "$(uname)" = "Darwin"
  # then
  #   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  # elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
  # then
  #   ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
  # fi
  source ~/.bash_profile
  source ~/.bashrc
fi

if test ! $(which brew)
then
    echo "brew not found, something went wrong installing homebrew"
    exit 1
fi
echo "Ok, we got homebrew - let's go"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if is_macos $1; then
  if is_macArm $1; then
    brew bundle --verbose --file $DIR/Brewfile.mac
    brew bundle cleanup --verbose -f --file $DIR/Brewfile.mac
    /usr/local/bin/brew bundle --verbose --file $DIR/Brewfile.rosetta
    /usr/local/bin/brew bundle cleanup --verbose -f --file $DIR/Brewfile.rosetta
  else 
    brew bundle --verbose --file $DIR/Brewfile
    brew bundle cleanup --verbose -f --file $DIR/Brewfile
  fi
elif is_linux $1; then
  brew bundle --verbose --file $DIR/Brewfile.linux
  brew bundle cleanup --verbose -f --file $DIR/Brewfile.linux
fi

if test "$(uname)" = "Darwin"
then

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

  echo "Looking for Deleted Apps in Trash and removing them"
  sudo find /private/var/root/.Trash -name '*.app' -exec rm -rf "{}" \;
fi
