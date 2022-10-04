#!/usr/bin/bash
# PowerStatus-dwm
# Author - HashTag-4512
# Date - 19/5/21
# A modular powerline statusbar for dwm

#powerline symbols
powerline_h="" #"\ue0b2"
powerline_s="" #"\ue0b3"
interval=0
IDENTIFIER="unicode"
CPU_TYPE=$(grep -i 'model name' /proc/cpuinfo | head -n 1 | awk '{ print $4 }')
IS_LAP=$(upower -i $(upower -e | grep 'BAT'))

#main functions
datetime(){
  date_time="$(date '+%d-%b-%Y   %H:%M %p')" #date and time in dd-mm-yyy HH:MM format
  printf "%s%s" "$(echo -e $powerline_s)" "$(echo -e " " $date_time)"
}

#sound(){
  #vol="$(amixer get Master | sed -n 's/^.*\[\([0-9]\+\)%.*$/\1/p'| uniq)"
  #printf "%s%s" "$(echo -e $powerline_s)" "$(echo -e " " $vol'% ')"
#}

dwm_alsa () {
    STATUS=$(amixer sget Master | tail -n1 | sed -r "s/.*\[(.*)\]/\1/")
    VOL=$(amixer get Master | tail -n1 | sed -r "s/.*\[(.*)%\].*/\1/")
    printf "$powerline_s "
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
    #printf "%s\n" "$SEP2"
}

battery(){
  batc="$(cat  /sys/class/power_supply/BAT0/capacity)"   # contains a value from 0 to 100
  bats="$(cat /sys/class/power_supply/BAT0/status)"     # either "Charging" or "Discharging" 
  printf "%s%s %s" "$(echo -e $powerline_s)" "$(echo -e " " $batc'%')" "$(echo -e $bats)"
}

#memory(){
  #ram="$(free -t | awk 'FNR == 2 {print ""$3/$2*100}')"
  #printf "%s%s" "$(echo -e $powerline_s)" "$(echo -e " " $ram'% ')"
#}

memory() {
	ram_per="$(free -t | awk 'FNR == 2 {print ""$3/$2*100}')"
	printf "$powerline_s  $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g) (%s%%)" "${ram_per:0:4}"
}

updates() {
	updates=$(checkupdates | wc -l)
	if [ -z "$updates" ]; then
		printf "$powerline_s ^c#98C379^ Ok"
	else
		printf "$powerline_s ^c#98C379^ $updates"
	fi
}

check_updates(){
	
	if [[ $((interval % 180)) -eq 0 ]]; then
		printf "$(updates)"
	else 
		printf "$powerline_s ^c#98C379^ Ok"
	fi
}

process(){
  cpu=$(grep -o "^[^ ]*" /proc/loadavg)
  printf "%s%s" "$(echo -e $powerline_s)" "$(echo -e " " $cpu'%')"
}

PREFIX_CPU=' '
get_disk(){
    #TOTAL_SIZE=$( df -h --total | tail -1 | awk {'printf $2'})
    #USED_SIZE=$(df -h --total | tail -1 | awk {'printf $3'})
    #PERCENTAGE=$(df -h --total | tail -1 | awk {'printf $5'})
    TOTAL_SIZE=$(df -h --total | sed -n '4p' | awk {'printf $2'})
    USED_SIZE=$( df -h --total | sed -n '4p' | awk {'printf $3'})
    FREE_SIZE=$( df -h --total | sed -n '4p' | awk {'printf $4'})
    PERCENTAGE=$(df -h --total | sed -n '4p' | awk {'printf $5'})
    #echo "^c#FF00B9^ $PREFIX$TOTAL_SIZE/$USED_SIZE/$FREE_SIZE ($PERCENTAGE)"
    echo "$powerline_s $PREFIX_CPU$TOTAL_SIZE/$FREE_SIZE ($PERCENTAGE)"
}

brightness() {
	if [ -d IS_LAP ]; then
		LIGHT=$(printf "%.0f\n" `light -G`)
		if [[ ("$LIGHT" -ge "0") && ("$LIGHT" -le "25") ]]; then
			printf "$powerline_s  $LIGHT%%"
		elif [[ ("$LIGHT" -ge "25") && ("$LIGHT" -le "50") ]]; then
			printf "$powerline_s  $LIGHT%%"
		elif [[ ("$LIGHT" -ge "50") && ("$LIGHT" -le "75") ]]; then
			printf "$powerline_s  $LIGHT%%"
		elif [[ ("$LIGHT" -ge "75") && ("$LIGHT" -le "100") ]]; then
			printf "$powerline_s  $LIGHT%%"
		fi
	else
		printf "$powerline_s  $LIGHT%%"
	fi
}

PREFIX=' '
FIRE=' '

WARNING_LEVEL=60

get_cputemp(){

        if [ "$CPU_TYPE" = "AMD" ]; then
                CPU_TEMP="$(sensors | grep Tctl | awk 'NR==1{gsub("+", " "); gsub("\\..", " "); print $2}')"
        else
                CPU_TEMP="$(sensors | grep temp1 | awk 'NR==1{gsub("+", " "); gsub("\\..", " "); print $2}')"
        fi
        
        if [ -z $CPU_TEMP ]; then
			CPU_TEMP="$(sensors | grep Tctl | awk 'NR==1{gsub("+", " "); gsub("\\..", " "); print $2}')"; 
        fi

        if [ "$CPU_TEMP" -ge $WARNING_LEVEL ]; then
                PREFIX="^c#668EE3^$FIRE$PREFIX"
        fi

        printf "$powerline_s ^c#E3DC66^$PREFIX$CPU_TEMP°C"
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
			if [ "$SHUFFLE" = "On" ]; then
                SHUFFLE=" 🔀"
            else
                SHUFFLE=""
            fi
        else
            if [ "$STATUS" = "Playing" ]; then
                STATUS="PLA"
            else
                STATUS="PAU"
            fi
			if [ "$SHUFFLE" = "On" ]; then
                SHUFFLE=" SHF ON"
            else
                SHUFFLE=""
            fi
        fi

        printf "%s %s- %s" "$STATUS" "${ARTIST:0:14}" "${TRACK:0:9}..."
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
        
        printf "%s%s %s - %s %s/%s%s%s" "$STATUS" "${ARTIST:0:14}..." "${TRACK:0:9}..." "$POSITION" "$DURATION" "$SHUFFLE"
    fi
}

battery0() {
	BAT=$(upower -i `upower -e | grep 'BAT'` | grep 'percentage' | cut -d':' -f2 | tr -d '%,[:blank:]')
	AC=$(upower -i `upower -e | grep 'BAT'` | grep 'state' | cut -d':' -f2 | tr -d '[:blank:]')

	if [[ "$AC" == "charging" ]]; then
		printf "  $BAT%%"
	elif [[ "$AC" == "fully-charged" ]]; then
		printf " "
	else
		if [[ ("$BAT" -ge "0") && ("$BAT" -le "20") ]]; then
			printf "  $BAT%%"
		elif [[ ("$BAT" -ge "20") && ("$BAT" -le "40") ]]; then
			printf "  $BAT%%"
		elif [[ ("$BAT" -ge "40") && ("$BAT" -le "60") ]]; then
			printf "  $BAT%%"
		elif [[ ("$BAT" -ge "60") && ("$BAT" -le "80") ]]; then
			printf "  $BAT%%"
		elif [[ ("$BAT" -ge "80") && ("$BAT" -le "100") ]]; then
			printf "  $BAT%%"
		fi
	fi
}

battery1() {
	BAT=$(upower -i `upower -e | grep 'BAT1'` | grep 'percentage' | cut -d':' -f2 | tr -d '%,[:blank:]')
	AC=$(upower -i `upower -e | grep 'BAT1'` | grep 'state' | cut -d':' -f2 | tr -d '[:blank:]')

	if [[ "$AC" == "charging" ]]; then
		printf "  $BAT%%"
	elif [[ "$AC" == "fully-charged" ]]; then
		printf " "
	else
		if [[ ("$BAT" -ge "0") && ("$BAT" -le "20") ]]; then
			printf "  $BAT%%"
		elif [[ ("$BAT" -ge "20") && ("$BAT" -le "40") ]]; then
			printf "  $BAT%%"
		elif [[ ("$BAT" -ge "40") && ("$BAT" -le "60") ]]; then
			printf "  $BAT%%"
		elif [[ ("$BAT" -ge "60") && ("$BAT" -le "80") ]]; then
			printf "  $BAT%%"
		elif [[ ("$BAT" -ge "80") && ("$BAT" -le "100") ]]; then
			printf "  $BAT%%"
		fi
	fi
}

batteries_t480() {
	if [ -d "upower -i $(upower -e | grep 'BAT')" ]; then
		printf "$powerline_s BT0%s,BT1%s" "$(battery0)" "$(battery1)"
	else
		printf "" # "$powerline_s  "
	fi
}

## Wi-fi
wlan() {
	case "$(cat /sys/class/net/w*/operstate 2>/dev/null)" in
		up) printf "$powerline_s  %s%s" "Connected" ;;
		down) printf "$powerline_s 睊 %s";;
	esac
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
    printf "$powerline_s $CONNAME"
}

if [ CPU_TYPE=="AMD" ];then 
	NET_NAME=$(dwm_networkmanager);
else 
	NET_NAME=$(wlan);
fi

BLUETOOTH_ON_ICON=''
BLUETOOTH_OFF_ICON=''

get_bluetooth(){
    status=$(systemctl is-active bluetooth.service)

    if [ "$status" == "active" ]; then
        echo "$powerline_s $BLUETOOTH_ON_ICON"
    else
        echo "$powerline_s $BLUETOOTH_OFF_ICON"
    fi
}

dwm_countdown () {
    for f in /tmp/countdown.*; do
        if [ -e "$f" ]; then
            if [ "$IDENTIFIER" = "unicode" ]; then
                printf "$powerline_s ^c#AB3D2B^⏳ %s" "$(tail -1 /tmp/countdown.*)"
            else
                printf "CDN %s" "$(tail -1 /tmp/countdown.*)"
            fi

            break
        fi
    done
}

while true; do
  ((interval++))
  xsetroot -name "^c#F5E4CE^$(dwm_spotify) $(process) $(get_cputemp)^c#F5E4CE^ $(memory) $(get_disk) $(batteries_t480) $(check_updates)^c#F5E4CE^ $(dwm_alsa) $(datetime) $(dwm_countdown)"
  sleep 1
done




