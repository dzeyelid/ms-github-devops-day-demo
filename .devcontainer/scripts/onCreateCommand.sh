#!/bin/bash

az bicep version
if [ 0 -lt $? ]; then
  az bicep install
fi
