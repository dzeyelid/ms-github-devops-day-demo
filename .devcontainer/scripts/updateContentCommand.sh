#!/bin/bash

if [ -d "frontend/app" ]; then
pushd frontend/app
npm install
popd
fi

if [ -d "backend/api" ]; then
pushd backend/api
npm install
npm run build
popd
fi
