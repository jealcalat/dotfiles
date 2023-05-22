#!/bin/bash

# Set the repository directory
REPO_DIR=$1

# Set your commit message
COMMIT_MSG=$2

# Set your GitHub token
GH_TOKEN=$3

SLEEP_TIME=$4

# Wait for $SLEEP_TIME seconds
sleep $SLEEP_TIME

# Navigate to your repository
cd $REPO_DIR

# Stage all changes
git add .

# Commit with your custom message
git commit -m "$COMMIT_MSG"

# Push changes to GitHub
# Replace 'origin' with the name of the remote repository if it's not 'origin'
# Replace 'master' with the name of the branch you want to push to if it's not 'master'
git push origin main

# Shut down the computer
# sudo shutdown -h now
