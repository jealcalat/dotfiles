#!/usr/bin/bash

interval=0

## Cpu Info
cpu_info() {
	cpu_load=$(grep -o "^[^ ]*" /proc/loadavg)

	printf "^c#3b414d^ ^b#7ec7a2^ CPU"
	printf "^c#abb2bf^ ^b#353b45^ $cpu_load"
}

## Memory
memory() {
	printf "^c#C678DD^^b#1e222a^   $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g) "
}

## Wi-fi
wlan() {
	case "$(cat /sys/class/net/w*/operstate 2>/dev/null)" in
		up) printf "^c#36A11B^   ^d^";;
		down) printf "^c#E06C75^ 睊  ^d^";;
	esac
}

## Time
PREFIX_DATE=''
clock() {
	printf "^c#1e222a^^b#668ee3^  "
	printf "^c#1e222a^^b#7aa2f7^ $(date '+%a, %I:%M %p') "
	printf "^c#1D4291^^b#916C1D^ $PREFIX_DATE "
	printf "^c#1D4291^^b#E3BB66^ $(date '+%d-%m-%y')"
}

## System Update
updates() {
	updates=$(checkupdates | wc -l)

	if [ -z "$updates" ]; then
		printf "^c#98C379^^b#1e222a^  Ok"
	else
		printf "^c#98C379^^b#1e222a^  $updates"""
	fi
}

## Battery Info
battery0() {
	BAT=$(upower -i `upower -e | grep 'BAT'` | grep 'percentage' | cut -d':' -f2 | tr -d '%,[:blank:]')
	AC=$(upower -i `upower -e | grep 'BAT'` | grep 'state' | cut -d':' -f2 | tr -d '[:blank:]')

	if [[ "$AC" == "charging" ]]; then
		printf "^c#E49263^^b#1e222a^  $BAT%%"
	elif [[ "$AC" == "fully-charged" ]]; then
		printf "^c#E06C75^^b#1e222a^ "
	else
		if [[ ("$BAT" -ge "0") && ("$BAT" -le "20") ]]; then
			printf "^c#E98CA4^^b#1e222a^  $BAT%%"
		elif [[ ("$BAT" -ge "20") && ("$BAT" -le "40") ]]; then
			printf "^c#E98CA4^^b#1e222a^  $BAT%%"
		elif [[ ("$BAT" -ge "40") && ("$BAT" -le "60") ]]; then
			printf "^c#E98CA4^^b#1e222a^  $BAT%%"
		elif [[ ("$BAT" -ge "60") && ("$BAT" -le "80") ]]; then
			printf "^c#E98CA4^^b#1e222a^  $BAT%%"
		elif [[ ("$BAT" -ge "80") && ("$BAT" -le "100") ]]; then
			printf "^c#E98CA4^^b#1e222a^  $BAT%%"
		fi
	fi
}

battery1() {
	BAT=$(upower -i `upower -e | grep 'BAT1'` | grep 'percentage' | cut -d':' -f2 | tr -d '%,[:blank:]')
	AC=$(upower -i `upower -e | grep 'BAT1'` | grep 'state' | cut -d':' -f2 | tr -d '[:blank:]')

	if [[ "$AC" == "charging" ]]; then
		printf "^c#E49263^^b#1e222a^  $BAT%%"
	elif [[ "$AC" == "fully-charged" ]]; then
		printf "^c#E06C75^^b#1e222a^ "
	else
		if [[ ("$BAT" -ge "0") && ("$BAT" -le "20") ]]; then
			printf "^c#E98CA4^^b#1e222a^  $BAT%%"
		elif [[ ("$BAT" -ge "20") && ("$BAT" -le "40") ]]; then
			printf "^c#E98CA4^^b#1e222a^  $BAT%%"
		elif [[ ("$BAT" -ge "40") && ("$BAT" -le "60") ]]; then
			printf "^c#E98CA4^^b#1e222a^  $BAT%%"
		elif [[ ("$BAT" -ge "60") && ("$BAT" -le "80") ]]; then
			printf "^c#E98CA4^^b#1e222a^  $BAT%%"
		elif [[ ("$BAT" -ge "80") && ("$BAT" -le "100") ]]; then
			printf "^c#E98CA4^^b#1e222a^  $BAT%%"
		fi
	fi
}

#

IDENTIFIER="unicode"
dwm_spotify () {
    if ps -C spotify > /dev/null; then
        ARTIST=$(playerctl -p spotify metadata artist)
        TRACK=$(playerctl -p spotify metadata title)
        TRACK_LEN=$(expr length $TRACK)
        DURATION=$(playerctl -p spotify metadata mpris:length | sed 's/.\{6\}$//')
        STATUS=$(playerctl -p spotify status)

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
        
        if [ $TRACK_LEN > 9 ]; then
			TRACK=$(echo "${TRACK:0:9}..")
		fi
        
        printf "^c#BDE51A^ %s%s %s - %s " "$SEP1" "$STATUS" "$ARTIST" "$TRACK"
        printf "%0d:%02d" $((DURATION%3600/60)) $((DURATION%60))
        printf "%s\n" "$SEP2"
    fi
}

# disk usage

PREFIX_CPU=' '

get_disk(){
    #TOTAL_SIZE=$( df -h --total | tail -1 | awk {'printf $2'})
    #USED_SIZE=$(df -h --total | tail -1 | awk {'printf $3'})
    #PERCENTAGE=$(df -h --total | tail -1 | awk {'printf $5'})
    TOTAL_SIZE=$( df -h --total | sed -n '4p' | awk {'printf $2'})
    USED_SIZE=$( df -h --total | sed -n '4p' | awk {'printf $3'})
    FREE_SIZE=$( df -h --total | sed -n '4p' | awk {'printf $4'})
    PERCENTAGE=$(df -h --total | sed -n '4p' | awk {'printf $5'})
    #echo "^c#FF00B9^ $PREFIX$TOTAL_SIZE/$USED_SIZE/$FREE_SIZE ($PERCENTAGE)"
    echo "^c#3b414d^ ^b#7ec7a2^ $PREFIX_CPU$TOTAL_SIZE/$FREE_SIZE ($PERCENTAGE)"
}

## Brightness
brightness() {
	LIGHT=$(printf "%.0f\n" `light -G`)

	if [[ ("$LIGHT" -ge "0") && ("$LIGHT" -le "25") ]]; then
		printf "^c#56B6C2^^b#1e222a^  $LIGHT%%"
	elif [[ ("$LIGHT" -ge "25") && ("$LIGHT" -le "50") ]]; then
		printf "^c#56B6C2^^b#1e222a^  $LIGHT%%"
	elif [[ ("$LIGHT" -ge "50") && ("$LIGHT" -le "75") ]]; then
		printf "^c#56B6C2^^b#1e222a^  $LIGHT%%"
	elif [[ ("$LIGHT" -ge "75") && ("$LIGHT" -le "100") ]]; then
		printf "^c#56B6C2^^b#1e222a^  $LIGHT%%"
	fi
}

# Prints out the bluetooth status

BLUETOOTH_ON_ICON=''
BLUETOOTH_OFF_ICON=''

get_bluetooth(){
    status=$(systemctl is-active bluetooth.service)

    if [ "$status" == "active" ]
    then
        echo "^b#1e222a^$BLUETOOTH_ON_ICON"
    else
        echo "^b#1e222a^$BLUETOOTH_OFF_ICON"
    fi
}

# Gets temperature of the CPU
# Dependencies: lm_sensors

PREFIX=' '
FIRE=' '

WARNING_LEVEL=80

get_cputemp(){
	# CPU_T=$(cat /sys/devices/platform/coretemp.0/hwmon/hwmon?/temp2_input)
	# CPU_TEMP=$(expr $CPU_T / 1000)

	CPU_TEMP="$(sensors | grep temp1 | awk 'NR==1{gsub("+", " "); gsub("\\..", " "); print $2}')"

	if [ "$CPU_TEMP" -ge $WARNING_LEVEL ]; then
		PREFIX="^c#668EE3^$FIRE$PREFIX"
	fi

	echo "^c#E3DC66^$PREFIX$CPU_TEMP°C"
}

## Main
while true; do
  [ "$interval" == 0 ] || [ $(("$interval" % 3600)) == 0 ] && updates=$(updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$(dwm_spotify) $(get_disk) $(updates) $(battery0) $(battery1) $(brightness) $(cpu_info) $(get_cputemp) $(memory) $(wlan) $(get_bluetooth) $(clock) $(get_date)"
done
