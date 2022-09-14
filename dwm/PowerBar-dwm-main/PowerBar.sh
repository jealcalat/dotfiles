#!/usr/bin/bash
# PowerStatus-dwm
# Author - HashTag-4512
# Date - 19/5/21
# A modular powerline statusbar for dwm

#powerline symbols
powerline_h="" #"\ue0b2"
powerline_s="" #"\ue0b3"
interval=0

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
    if [ "$interval" == 0 ] || [ $(("$interval" % 3600)) == 0 ]; then
		updates=$(checkupdates | wc -l)
	fi

	if [ -z "$updates" ]; then
		printf "$powerline_s ^c#98C379^ Ok"
	else
		printf "$powerline_s ^c#98C379^ $updates"
	fi
}

process(){
  cpu="$(ps -eo pcpu | awk 'BEGIN {sum=0.0f} {sum+=$1} END {print sum}')"
  printf "%s%s" "$(echo -e $powerline_s)" "$(echo -e " " $cpu'%')"
}

brightness() {
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
}

PREFIX=' '
FIRE=' '

WARNING_LEVEL=60

get_cputemp(){
	# CPU_T=$(cat /sys/devices/platform/coretemp.0/hwmon/hwmon?/temp2_input)
	# CPU_TEMP=$(expr $CPU_T / 1000)

	CPU_TEMP="$(sensors | grep temp1 | awk 'NR==1{gsub("+", " "); gsub("\\..", " "); print $2}')"

	if [ "$CPU_TEMP" -ge $WARNING_LEVEL ]; then
		PREFIX="^c#668EE3^$FIRE$PREFIX"
	fi

	echo "$powerline_s $PREFIX$CPU_TEMP°C"
}

IDENTIFIER="unicode"
dwm_spotify () {
    if ps -C spotify > /dev/null; then
        ARTIST=$(playerctl -p spotify metadata artist)
        TRACK=$(playerctl -p spotify metadata title)
        #TRACK_LEN=$(expr length $TRACK)
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
        
        printf "$powerline_s %s %s-%s" "$STATUS" "$ARTIST":"$(echo "${TRACK:0:9}...")"
        #printf "%0d:%02d" $((DURATION%3600/60)) $((DURATION%60))
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
	printf "$powerline_s BT0%s,BT1%s" "$(battery0)" "$(battery1)"
}

## Wi-fi
wlan() {
	case "$(cat /sys/class/net/w*/operstate 2>/dev/null)" in
		up) printf "$powerline_s  %s%s" " Connected " ;;
		down) printf "$powerline_s 睊 %s";;
	esac
}

BLUETOOTH_ON_ICON=''
BLUETOOTH_OFF_ICON=''

get_bluetooth(){
    status=$(systemctl is-active bluetooth.service)

    if [ "$status" == "active" ]
    then
        echo "$BLUETOOTH_ON_ICON"
    else
        echo "$BLUETOOTH_OFF_ICON"
    fi
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


#update every 30 seconds
while true; do
  interval=$((interval + 1))
  xsetroot -name "^c#F5E4CE^$(dwm_spotify) $(process) $(get_cputemp) $(memory) $(get_disk) $(batteries_t480) $(updates) ^c#F5E4CE^$(wlan) $(get_bluetooth) $(brightness) $(dwm_alsa) $(datetime)"
  sleep 1
done




