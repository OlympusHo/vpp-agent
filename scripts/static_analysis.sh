#!/bin/bash

# files to exclude based on file content
excludeContent="^// DO NOT EDIT|^// File generated by|^// Code generated by|^// Automatically generated"
filesToExclude=$(echo $(echo $(grep -lrE "$excludeContent" | grep '\.go' | fgrep -v vendor/ | sed -e "s/$/|/g") | sed -e "s/| /|/g") | sed -e "s/|$//g")

# linters to run based on parameters of this script
enabledLinters=""
for linterName in $*;
do
  enabledLinters="$enabledLinters --enable=$linterName"
done

# running linters (excluding vendor,...)
gometalinter --vendor --deadline 1m --enable-gc --disable-all $enabledLinters --exclude="should not use dot imports" --exclude="$filesToExclude" ./...
