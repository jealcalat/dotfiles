#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3
## Autostart Programs

# Kill already running process
_ps=(picom dunst ksuperkey mpd xfce-polkit xfce4-power-manager)
for _prs in "${_ps[@]}"; do
	if [[ $(pidof ${_prs}) ]]; then
		killall -9 ${_prs}
	fi
done

# Fix cursor
xsetroot -cursor_name left_ptr

# Polkit agent
/usr/lib/xfce-polkit/xfce-polkit &

# Enable power management
xfce4-power-manager &

# Enable Super Keys For Menu
ksuperkey -e 'Super_L=Alt_L|F1' &
ksuperkey -e 'Super_R=Alt_L|F1' &

# Restore wallpaper
hsetroot -cover /home/mrrobot/.config/dwm/wallpapers/keyboards.jpg

# Lauch dwmbar
# /home/mrrobot/.config/dwm/dwmbar.sh &
/home/mrrobot/.config/dwm/PowerBarColor.sh &
# /home/mrrobot/.config/dwm/PowerBar.sh &
# /home/mrrobot/.config/dwm/dwm-bar_joestandring/dwm_bar.sh &
# Lauch notification daemon
/home/mrrobot/.config/dwm/dwmdunst.sh

# Lauch compositor
/home/mrrobot/.config/dwm/dwmcomp.sh

# Start mpd
# exec mpd &

# Fix Java problems
wmname "LG3D"
export _JAVA_AWT_WM_NONREPARENTING=1

## Add your autostart programs here --------------
sxhkd &
udiskie &
(sleep 10s && /home/mrrobot/.config/polybar/launch_polybar_spotify.sh) &
(sleep 20s && dropbox) &
(sleep 20s && megasync) &
(sleep 2s && setxkbmap -layout es) &

## -----------------------------------------------

# Launch DWM
while
	dwm
	[ $? -ne 0 ]
do echo "start dwm"; done
