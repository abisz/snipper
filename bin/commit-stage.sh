#!/bin/bash

echo "bundle install"
bundle install

echo "rails db:setup"
rails db:setup

echo "rails test:controllers"
rails test:controllers
echo "rails test:models"
rails test:models

echo "git checkout brakeman"
git checkout brakeman

echo "brakeman -z -q -o output.json"
brakeman -z -q -o output.json

ERROR_COUNT=$( cat output.json | jq .scan_info.security_warnings )
LAST_ERROR_COUNT=$( cat last-output.json | jq .scan_info.security_warnings )

if [ ${ERROR_COUNT} -gt ${LAST_ERROR_COUNT} ]
then
    echo "Error count (brakeman) increased"
    exit 0
fi

echo "clean up branch"
rm last-output.json
mv output.json last-output.json

echo "push logs to git"
git add .
git commit -m "brakeman output log"
git push -u origin brakeman

git checkout master

echo "Commit Stage finished"