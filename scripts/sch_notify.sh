#!/bin/bash

# Path to the CSV file containing the schedule
schedule_file=$1

# Read the CSV file line by line
while IFS=',' read -r hour duration task comment; do
  # Skip the header line
  if [[ "$hour" == "hour" ]]; then
    continue
  fi

  # Get the current time in the format HH:MM AM/PM
  current_time=$(date +"%I:%M %p")

  # Convert the scheduled hour to 24-hour format
  scheduled_time=$(date -d "$hour" +"%H:%M")

  # Check if the current time matches the scheduled time
  if [[ "$current_time" == "$scheduled_time" ]]; then
    # Create a notification for task start using Dunst
    dunstify -a "Scheduled Task" -u low "Task Start: $task" "$comment"

    # Calculate the task end time
    end_time=$(date -d "$hour $duration minutes" +"%I:%M %p")

    # Create a notification for task end using Dunst
    dunstify -a "Scheduled Task" -u low "Task End: $task" "End Time: $end_time"
  fi
done <"$schedule_file"
