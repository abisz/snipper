#!/bin/bash

bundle install
rails db:setup
rails test:controllers
rails test:models

git checkout brakeman

brakeman -z -q -o output.json

ERROR_COUNT=$( cat output.json | jq .scan_info.security_warnings )
LAST_ERROR_COUNT=$( cat last-output.json | jq .scan_info.security_warnings )

if [ ${ERROR_COUNT} -gt ${LAST_ERROR_COUNT} ]
then
    exit 0
fi

rm last-output.json
mv output.json last-output.json

git add .
git commit -m "brakeman output log"
git push -u origin brakeman

git checkout master