#!/bin/bash

# This script automates the process of pushing changes to GitHub.
# It takes 4 arguments:
# 1. The path to your repository
# 2. Your commit message
# 3. Your GitHub token
# 4. The time in seconds to sleep before pushing to GitHub
# Also, you need to set your GitHub username and repository name in the script.

# Usage:
# ./git_automate.sh <path-to-repository> <commit-message> <github-token> <sleep-time>

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

SHUT=$5

# Wait for $SLEEP_TIME seconds

# Define progress bar function
progress_bar() {
  local duration=${1}
  local bar_length=50
  local sleep_interval=$(echo "scale=5; $duration / $bar_length" | bc)
  local progress=""
  local current_progress=""

  for ((i = 0; i <= bar_length; i++)); do
    progress+="="
    current_progress="${progress}"
    printf "\r[%-${bar_length}s] %d%%" "${current_progress}" $((i * 100 / bar_length))
    sleep ${sleep_interval}
  done
  echo ""
}

# Display sleep progress bar
echo "Sleeping for $SLEEP_TIME seconds..."
progress_bar ${SLEEP_TIME}

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
git push origin

# Shut down the computer

if [ $SHUT = TRUE ]; then
  echo "Shutting down the computer..."
  sleep 1
  shutdown -h now
fi
