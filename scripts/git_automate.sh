#!/bin/bash

# Set your GitHub username
echo "Write your user name: "
read GH_USERNAME

# Set your GitHub repository name
echo "Write your repository name: "
read GH_REPOSITORY

# Set the repository directory
REPO_DIR=$1

# Set your commit message
COMMIT_MSG=$2

# Set the sleep time in seconds
SLEEP_TIME=$4

# Set your GitHub token
GH_TOKEN=$3

# Wait for $SLEEP_TIME seconds

sleep $SLEEP_TIME

# Navigate to your repository
cd $REPO_DIR

# Stage all changes
git add .

# Commit with your custom message
git commit -m "$COMMIT_MSG"

# Push changes to GitHub using the token
# Replace 'origin' with the name of the remote repository if it's not 'origin'
# Replace 'main' with the name of the branch you want to push to if it's not 'main'
git push "https://$GH_TOKEN@github.com/$GH_USERNAME/$GH_REPOSITORY.git" main

# Shut down the computer
# sudo shutdown -h now
