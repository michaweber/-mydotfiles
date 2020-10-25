#!/bin/bash

# https://github.com/cantino/reckon

if ! command -v gem &> /dev/null
then
    echo "gem could not be found, unable to install reckon"
    exit
fi

gem install --user reckon
