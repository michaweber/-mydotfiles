#!/bin/bash

DIR=~/.emacs.d

if [ ! -d "$DIR" ]; then 
  git clone --depth 1 https://github.com/hlissner/doom-emacs "$DIR" 
  ${DIR}/bin/doom install
else 
  echo "$DIR already exists skipping"
fi
