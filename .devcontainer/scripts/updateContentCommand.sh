#!/bin/bash

if [ -d "frontend/app" ]; then
pushd frontend/app
npm install
popd
fi
