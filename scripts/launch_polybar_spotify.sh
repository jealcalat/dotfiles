#!/bin/bash

# the name of your polybar bar (as it appears in your polybar config)
bar_name=$1
# the name of your polybar launch script
launch_script=""

while true; do
    if pgrep -x "spotify" > /dev/null || pgrep -x "spotifyd" > /dev/null || pgrep -x "ncspot" > /dev/null; then
        # spotify or spotifyd or ncspot is running
        # check if polybar is already running
        if ! pgrep -x "polybar" > /dev/null; then
            # polybar isn't running, so start it
            polybar $bar_name &
        fi
    else
        # neither spotify nor spotifyd nor ncspot is running
        # check if polybar is running
        if pgrep -x "polybar" > /dev/null; then
            # polybar is running, so kill it
            pkill polybar
        fi
    fi
    # sleep for 1 second before checking again
    sleep 1
done