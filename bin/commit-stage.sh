#!/bin/bash

bundle install
rails db:setup
rails test:controllers
rails test:models
brakeman -z
#brakeman -z -q -o brakeman-output.json

#LAST_ERROR_COUNT=$( cat brakeman-output.json | jq .scan_info.security_warnings )
#
#echo ${LAST_ERROR_COUNT}