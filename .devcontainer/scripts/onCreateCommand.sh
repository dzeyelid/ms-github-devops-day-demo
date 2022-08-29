#!/bin/bash

node -v
if [ 0 -lt $? ]; then
nvm install 16
fi

npm install -g npm
npm install -g @azure/static-web-apps-cli

az bicep version
if [ 0 -lt $? ]; then
  az bicep install
fi
