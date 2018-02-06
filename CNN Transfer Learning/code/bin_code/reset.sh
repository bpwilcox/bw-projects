#!/bin/bash

if [ -d ./data/train ]; then
    rm -r ./data/train
fi
if [ -d ./data/validation ]; then
    rm -r ./data/validation
fi
