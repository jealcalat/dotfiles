#!/bin/bash

# usage: ./git2repo.sh <path-to-repository> <commit-message> <github-token> <sleep-time> <shut-down>

# Set default values for variables
SHUT=false
GH_REPOSITORY=""
GH_TOKEN=""
SLEEP_TIME=""
COMMIT_MSG=""

# Function to read the GitHub token from a file
read_gh_token() {
  GH_TOKEN=$(cat /home/mrrobot/Dropbox/utils_bash_scripts/token.txt)
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --SHUT)
      SHUT=true
      shift
      ;;
    --DIR2GH)
      if [ "$2" = "false" ]; then
        echo "Write your repository name: "
        read GH_REPOSITORY
      fi
      shift 2
      ;;
    --SLEEP)
      SLEEP_TIME="$2"
      shift 2
      ;;
    --MSG)
      COMMIT_MSG="$2"
      shift 2
      ;;
    *)
      # Assume the argument is the repository directory
      REPO_DIR="$1"
      shift
      ;;
  esac
done

# Set your GitHub username
echo "Write your user name: "
read GH_USERNAME

# Set the repository directory if not provided as an argument
if [ -z "$REPO_DIR" ]; then
  echo "Write your repository directory: "
  read REPO_DIR
fi

# Set your GitHub token by calling the read_gh_token function
read_gh_token

# Set the sleep time if not provided via --SLEEP
if [ -z "$SLEEP_TIME" ]; then
  echo "Write the sleep time in seconds: "
  read SLEEP_TIME
fi

# Set the commit message if not provided via --MSG
if [ -z "$COMMIT_MSG" ]; then
  echo "Write your commit message: "
  read COMMIT_MSG
fi

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
cd "$REPO_DIR"

# Stage all changes
git add .

# Commit with your custom message
git commit -m "$COMMIT_MSG"

# Push changes to GitHub using the token
# Replace 'origin' with the name of the remote repository if it's not 'origin'
# Replace 'main' with the name of the branch you want to push to if it's not 'main'
git push "https://$GH_TOKEN@github.com/$GH_USERNAME/$GH_REPOSITORY.git" main
git push origin

# Shut down the computer if --SHUT is true
if [ "$SHUT" = true ]; then
  echo "Shutting down the computer..."
  sleep 1
  shutdown -h now
fi
