#!/bin/bash

npm install -g npm
npm install -g @azure/static-web-apps-cli

az bicep version
if [ 0 -lt $? ]; then
  az bicep install
fi
