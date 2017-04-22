#!/bin/bash

echo "bundle install"
bundle install

echo "rails db:setup"
rails db:setup

echo "rails test"
rails test:controllers
rails test:models

echo "brakeman -z -q -o output.json"
brakeman -z -q -o output.json

ERROR_COUNT=$( cat output.json | jq .scan_info.security_warnings )

rm output.json

echo "git checkout brakeman"
git checkout brakeman

LAST_ERROR_COUNT=$( cat last-count.txt )

if [ ${ERROR_COUNT} -gt ${LAST_ERROR_COUNT} ]
then
    echo "Error count (brakeman) increased"
    exit 0
fi

echo ${ERROR_COUNT} > last-count.txt

echo "push logs to git"
git config --global user.email $1
git config --global user.name $2

git add .
git commit -m "brakeman output log"
git push -u origin brakeman

git checkout master

echo "Commit Stage finished"