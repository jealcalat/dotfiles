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
hsetroot -cover /home/$USER/.config/dwm/wallpapers/lain4.jpg

# Lauch dwmbar
# /home/$USER/.config/dwm/dwmbar.sh &
# /home/$USER/Documents/GitHub/dotfiles/dwm/PowerBar-dwm-main/PowerBar.sh &
/home/$USER/.config/dwm/dwm-bar_joestandring/dwm_bar.sh &
# Lauch notification daemon
/home/$USER/.config/dwm/dwmdunst.sh

# Lauch compositor
/home/$USER/.config/dwm/dwmcomp.sh

# Start mpd
# exec mpd &

# Fix Java problems
wmname "LG3D"
export _JAVA_AWT_WM_NONREPARENTING=1

## Add your autostart programs here --------------
sxhkd &
(sleep 5 && dropbox) &
(sleep 15 && ibus) &
## -----------------------------------------------

# Launch DWM
while
	dwm
	[ $? -ne 0 ]
do echo "start dwm"; done
