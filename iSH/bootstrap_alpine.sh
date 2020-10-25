#!/bin/sh

APK="apk-tools-static-2.10.5-r1.apk"

if test ! $(which apk)
then
cd 
mkdir -p apk_tmp
wget http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/x86/$APK
tar xvzf ~/$APK
ln -s /sbin/apk.static /sbin/apk
cd
apk
fi

# sed -i -e 's/v[[:digit:]]\..*\//edge\//g' /etc/apk/repositories

apk add git
apk add openssh
apk add bash
apk add curl
apk add vim
apk add fzf
apk add fzf-vim
apk add python3
apk add go
apk add tmux
apk add emacs
