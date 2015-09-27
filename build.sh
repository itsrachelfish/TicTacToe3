#!/bin/bash

# Exit with nonzero exit code if anything fails
set -e

# Compile
pub build

# Go to the build directory's web folder and create a *new* Git repo
cd build/web/
git init

# Log in to GitHub
git config user.name "KlikiniBot"
git config user.email "andyccastille+klikinibot@gmail.com"

# Commit the built files
git add .
git commit -m "[Travis CI] Build"

# Force push from the current repo's master branch to the remote
# repo's gh-pages branch. (All previous history on the gh-pages branch
# will be lost, since we are overwriting it.) We redirect any output to
# /dev/null to hide any sensitive credential data that might otherwise be exposed.
# # git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:gh-pages > /dev/null 2 > &1
git status
