#!/bin/bash

cd application
mkdir img.bk
grep  -roh -E "(\.gitbook/assets/.*))" *.md | sed -e 's/.$//' -e 's/%20/ /g' -e 's/%21/!/g' -e 's/%23/#/g' -e 's/%24/$/g' -e 's/%26/\&/g' -e "s/%27/'/g" -e 's/%28/(/g' -e 's/%29/)/g' |  xargs -I 'IMG' cp -f IMG img.bk
rm -rf .gitbook/assets/*
cp - img.bk/* .gitbook/assets/
rm -rf img.bk
