#!/usr/bin/env bash

# launch ranger in alacritty float
## i3wm config
CONFIG="/home/mrrobot/.config/dwm/alacritty/alacritty.yml"

alacritty --class 'alacritty-float,alacritty-float' --config-file "$CONFIG" -e ranger