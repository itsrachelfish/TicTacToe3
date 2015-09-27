#!/bin/bash

# Get dependencies
pub get
echo "PUB GOT!"

ls

# Build
pub build

ls

ls ./build/
