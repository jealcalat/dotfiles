#!/bin/bash

# Check if an extension is provided
if [ -z "$1" ]; then
    echo "Please provide an extension as an argument (e.g., mp4, gif)."
    exit 1
fi

# Get the current date and time to use in the filename
DATE=$(date '+%Y-%m-%d_%H-%M-%S')

# Use slop to select the area and get the geometry
GEOMETRY=$(slop -f "%x %y %w %h")

# Extract coordinates and dimensions
IFS=' ' read -ra PARAMS <<< "$GEOMETRY"

if [ -z "$GEOMETRY" ]; then
    exit 1
fi

# Start capturing
ffmpeg -f x11grab -s ${PARAMS[2]}x${PARAMS[3]} -i :0.0+${PARAMS[0]},${PARAMS[1]} -f alsa -ac 2 -i pulse -acodec aac -strict experimental -y ${DATE}.mp4 &

# Get ffmpeg process ID
PID=$!

# Wait for the Esc key to stop capturing
read -rsn1 -p "Press Esc to stop recording." stop
[[ "$stop" == $'\e' ]]

# Stop capturing
kill $PID

# Convert to the desired format if it's not mp4
if [ "$1" != "mp4" ]; then
    ffmpeg -i ${DATE}.mp4 -vf "fps=10,scale=320:-1:flags=lanczos" ${DATE}.$1
fi
