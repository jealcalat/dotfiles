#!/usr/bin/bash

interval=0

SEP1="|"
SEP2="|"
IDENTIFIER="unicode"
CPU_TYPE=$(grep -i 'model name' /proc/cpuinfo | head -n 1 | awk '{ print $4 }')
IS_LAP=$(upower -i $(upower -e | grep 'BAT'))

## Cpu Info
cpu_info() {
	cpu_load=$(grep -o "^[^ ]*" /proc/loadavg)
	printf "^c#3b414d^ ^b#7ec7a2^ CPU"
	printf "^c#abb2bf^ ^b#353b45^ $cpu_load"
}

df_check_location='/home'
PREFIX_CPU=''
dwm_resources () {
	# get all the infos first to avoid high resources usage
	free_output=$(free -h | grep Mem)
	df_output=$(df -h $df_check_location | tail -n 1)
	# Used and total memory
	MEMUSED=$(echo $free_output | awk '{print $3}')
	MEMTOT=$(echo $free_output | awk '{print $2}')
	# CPU temperature
	CPU=$(top -bn1 | grep Cpu | awk '{print $2}')%
	#CPU=$(sysctl -n hw.sensors.cpu0.temp0 | cut -d. -f1)
	# Used and total storage in /home (rounded to 1024B)
	STOUSED=$(echo $df_output | awk '{print $3}')
	STOTOT=$(echo $df_output | awk '{print $2}')
	STOPER=$(echo $df_output | awk '{print $5}')

	printf "%s" "$SEP1"
	if [ "$IDENTIFIER" = "unicode" ]; then
		printf "^c#C678DD^^b#1e222a^💻 RAM %s/%s | CPU %s " "$MEMUSED" "$MEMTOT" "$CPU" 
		printf "^c#7ec7a2^^b#1e222a^%s %s/%s (%s)" "$PREFIX_CPU" "$STOUSED" "$STOTOT" "$STOPER"
	else
		printf "STA | MEM %s/%s CPU %s STO %s/%s(%s)" "$MEMUSED" "$MEMTOT" "$CPU" "$STOUSED" "$STOTOT" "$STOPER"
	fi
	#printf "%s\n" "$SEP2"
}

PREFIX=' '
FIRE=' '
WARNING_LEVEL=80

get_cputemp(){

        if [ "$CPU_TYPE" = "AMD" ]; then
                CPU_TEMP="$(sensors | grep Tctl | awk 'NR==1{gsub("+", " "); gsub("\\..", " "); print $2}')"
        else
                CPU_TEMP="$(sensors | grep temp1 | awk 'NR==1{gsub("+", " "); gsub("\\..", " "); print $2}')"
        fi

        if [ "$CPU_TEMP" -ge $WARNING_LEVEL ]; then
                PREFIX="^c#668EE3^$FIRE$PREFIX"
        fi

        printf "^c#E3DC66^$SEP1$PREFIX$CPU_TEMP°C"
}

dwm_alsa () {
    STATUS=$(amixer sget Master | tail -n1 | sed -r "s/.*\[(.*)\]/\1/")
    VOL=$(amixer get Master | tail -n1 | sed -r "s/.*\[(.*)%\].*/\1/")
    printf "%s" "$SEP1"
    if [ "$IDENTIFIER" = "unicode" ]; then
        if [ "$STATUS" = "off" ]; then
                    printf "🔇"
        else
                #removed this line becuase it may get confusing
                if [ "$VOL" -gt 0 ] && [ "$VOL" -le 33 ]; then
                    printf "🔈 %s%%" "$VOL"
                elif [ "$VOL" -gt 33 ] && [ "$VOL" -le 66 ]; then
                    printf "🔉 %s%%" "$VOL"
                else
                    printf "🔊 %s%%" "$VOL"
                fi
                fi
    else
        if [ "$STATUS" = "off" ]; then
                printf "MUTE"
        else
                # removed this line because it may get confusing
                if [ "$VOL" -gt 0 ] && [ "$VOL" -le 33 ]; then
                    printf "VOL %s%%" "$VOL"
                elif [ "$VOL" -gt 33 ] && [ "$VOL" -le 66 ]; then
                    printf "VOL %s%%" "$VOL"
                else
                    printf "VOL %s%%" "$VOL"
                fi
        fi
    fi
    printf "%s\n" "$SEP2"
}

dwm_networkmanager () {
    CONNAME=$(nmcli -a | grep 'Wired connection' | awk 'NR==1{ gsub(":", ""); print $1}')
    if [ "$CONNAME" = "" ]; then
        CONNAME=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -c 5-)
    fi

    PRIVATE=$(nmcli -a | grep 'inet4 192' | awk '{print $2}')
    PUBLIC=$(curl -s https://ipinfo.io/ip)
    NET="${CONNAME} ${PRIVATE} ${PUBLIC}"
    NET="$(echo $NET | awk 'NR==1{gsub("  ", "_"); print $1, $2}')"
    printf "^c#CDDFDF^^b#353b45^$SEP1 $CONNAME"
}

dwm_weather() {
    LOCATION="Guadalajara+Jalisco"
    DATA=$(curl -s "wttr.in/${LOCATION}?format=1")
    printf "^d^Tmp: ^c#FF7F00^$($DATA | awk '{ print $1,$2}')"
    #printf "^c#FF7F00^$(echo $LOCATION | cut -d+ -f1):$DATA"
}


## Memory
memory() {
	printf "^c#C678DD^^b#1e222a^   $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g) "
}

## Wi-fi
wlan() {
	case "$(cat /sys/class/net/w*/operstate 2>/dev/null)" in
		up) printf "^c#3b414d^^b#7aa2f7^  ^d^%s" " ^c#7aa2f7^Connected " ;;
		down) printf "^c#3b414d^^b#E06C75^ 睊 ^d^%s" " ^c#E06C75^Disconnected " ;;
	esac
}

## Time
clock() {
	printf "^c#1e222a^^b#668ee3^$SEP1  "
	printf "^c#1E222A^ $(date '+%I:%M:%S %p') "
	printf "^c#1e222a^^b#BC9B15^  "
	printf "^c#1E222A^^b#BC9B15^ $(date '+%d/%b/%Y, %A')"
}

## System Update
updates() {
	updates=$(checkupdates | wc -l)

	if [ -z "$updates" ]; then
		printf "^c#98C379^$SEP1  Updated"
	else
		printf "^c#98C379^$SEP1  $updates"
	fi
}

updates() {
    if [ "$interval" == 0 ] || [ $(("$interval" % 3600)) == 0 ]; then
		updates=$(checkupdates | wc -l)
	fi

	if [ -z "$updates" ]; then
		printf "^c#98C379^$SEP1  Ok"
	else
		printf "^c#98C379^$SEP1  $updates"
	fi
}

## Battery Info
battery() {
	BAT=$(upower -i `upower -e | grep 'BAT'` | grep 'percentage' | cut -d':' -f2 | tr -d '%,[:blank:]')
	AC=$(upower -i `upower -e | grep 'BAT'` | grep 'state' | cut -d':' -f2 | tr -d '[:blank:]')

	if [[ "$AC" == "charging" ]]; then
		printf "^c#E49263^  $BAT%%"
	elif [[ "$AC" == "fully-charged" ]]; then
		printf "^c#E06C75^  Full"
	else
		if [[ ("$BAT" -ge "0") && ("$BAT" -le "20") ]]; then
			printf "^c#E98CA4^  $BAT%%"
		elif [[ ("$BAT" -ge "20") && ("$BAT" -le "40") ]]; then
			printf "^c#E98CA4^  $BAT%%"
		elif [[ ("$BAT" -ge "40") && ("$BAT" -le "60") ]]; then
			printf "^c#E98CA4^  $BAT%%"
		elif [[ ("$BAT" -ge "60") && ("$BAT" -le "80") ]]; then
			printf "^c#E98CA4^  $BAT%%"
		elif [[ ("$BAT" -ge "80") && ("$BAT" -le "100") ]]; then
			printf "^c#E98CA4^  $BAT%%"
		fi
	fi
}

## Brightness
brightness() {
	LIGHT=$(printf "%.0f\n" `light -G`)

	if [[ ("$LIGHT" -ge "0") && ("$LIGHT" -le "25") ]]; then
		printf "^c#56B6C2^  $LIGHT%%"
	elif [[ ("$LIGHT" -ge "25") && ("$LIGHT" -le "50") ]]; then
		printf "^c#56B6C2^  $LIGHT%%"
	elif [[ ("$LIGHT" -ge "50") && ("$LIGHT" -le "75") ]]; then
		printf "^c#56B6C2^  $LIGHT%%"
	elif [[ ("$LIGHT" -ge "75") && ("$LIGHT" -le "100") ]]; then
		printf "^c#56B6C2^  $LIGHT%%"
	fi
}

dwm_spotify () {
    if ps -C spotify > /dev/null; then
        PLAYER="spotify"
    elif ps -C spotifyd > /dev/null; then
        PLAYER="spotifyd"
    elif ps -C ncspot > /dev/null; then
		PLAYER="ncspot"
    fi

    if [ "$PLAYER" = "spotify" ] || [ "$PLAYER" = "spotifyd" ] || [ "$PLAYER" = "ncspot" ]; then
        ARTIST=$(playerctl -p $PLAYER metadata artist)
        TRACK=$(playerctl -p $PLAYER metadata title)
        POSITION=$(playerctl position | sed 's/..\{6\}$//')
        DURATION=$(playerctl -p $PLAYER metadata mpris:length | sed 's/.\{6\}$//')
        STATUS=$(playerctl status)
        SHUFFLE=$(playerctl shuffle)
        
        if [ "$IDENTIFIER" = "unicode" ]; then
            if [ "$STATUS" = "Playing" ]; then
                STATUS="▶"
            else
                STATUS="⏸"
            fi
        else
            if [ "$STATUS" = "Playing" ]; then
                STATUS="PLA"
            else
                STATUS="PAU"
            fi
        fi

        printf "%s %s-%s" "$STATUS" "${ARTIST:0:10}...""${TRACK:0:9}..."
        printf "%0d:%02d/" $((POSITION%3600/60)) $((POSITION%60))
        printf "%0d:%02d" $((DURATION%3600/60)) $((DURATION%60))
        printf "%s" "$SHUFFLE"
    fi
}

dwm_mpc () {
    if ps -C mpd > /dev/null; then
        ARTIST=$(mpc current -f %artist%)
        TRACK=$(mpc current -f %title%)
        POSITION=$(mpc status | grep "%)" | awk '{ print $3 }' | awk -F/ '{ print $1 }')
        DURATION=$(mpc current -f %time%)
        STATUS=$(mpc status | sed -n 2p | awk '{print $1;}')
        SHUFFLE=$(mpc status | tail -n 1 | awk '{print $6}')

        if [ "$IDENTIFIER" = "unicode" ]; then
            if [ "$STATUS" = "[playing]" ]; then
                STATUS="▶"
            else
                STATUS="⏸"
            fi

            if [ "$SHUFFLE" = "on" ]; then
                SHUFFLE=" 🔀"
            else
                SHUFFLE=""
            fi
        else
            if [ "$STATUS" = "[playing]" ]; then
                STATUS="PLA"
            else
                STATUS="PAU"
            fi

            if [ "$SHUFFLE" = "on" ]; then
                SHUFFLE=" S"
            else
                SHUFFLE=""
            fi
        fi
        
        printf "%s%s %s - %s %s/%s%s%s" "$STATUS" "${ARTIST:0:10}..." "${TRACK:0:9}..." "$POSITION" "$DURATION" "$SHUFFLE"
    fi
}

## Main
while true; do
  [ "$interval" == 0 ] || [ $(("$interval" % 3600)) == 0 ] && updates=$(updates)
  interval=$((interval + 1))
  xsetroot -name "$(dwm_spotify) $(dwm_networkmanager) $(updates) $(dwm_resources) $(get_cputemp) $(clock) $(dwm_alsa)"
  sleep 1
done
