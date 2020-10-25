#!/bin/sh

cd
wget http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/x86/apk-tools-static-2.10.5-r1.apk
cd /
tar xvzf ~/apk-tools-static-2.10.5-r1.apk
ln -s /sbin/apk.static /sbin/apk
cd
apk

apk add git
apk add openssh
apk add bash
