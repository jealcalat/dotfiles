#!/usr/bin/env bash

# launch ranger in alacritty float
## i3wm config
CONFIG="/home/$USER/.config/dwm/alacritty/alacritty.yml"

alacritty --class 'alacritty-float,alacritty-float' --config-file "$CONFIG" -e ranger
