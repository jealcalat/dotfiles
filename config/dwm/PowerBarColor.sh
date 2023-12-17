#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.

#powerline symbols
powerline_h="" #"\ue0b2"
powerline_s="" #"\ue0b3"

#colors
color1="#282828"
color2="#928374"
color3="#FBF0C9"
color4="#FB4934"
color5="#447A59"
color6="#116677"
color7="#83A598"
color8="#AD3B14"
color9="#B16286"
color10="#D3869B"
color11="#D79921"
color12="#98971A"
color13="#D65D0E"
color14="#D5C4A3"
color15="#7C6F65"
color16="#BDAE93"
color17="#3C3836"
color18="#A89985"

export IDENTIFIER="unicode"

#main functions

DMY() {
    date="$(date '+%d-%m-%Y')" #date in dd-mm-yyy format
    printf "%s%s" "$(echo -e ^c$color5^ )^d^" "$(echo -e ^c$color3^^b$color5^ "" $date)"
}

hour() {
    
    clock=$(date '+%I')
    
    case "$clock" in
        "00") icon="🕛" ;;
        "01") icon="🕐" ;;
        "02") icon="🕑" ;;
        "03") icon="🕒" ;;
        "04") icon="🕓" ;;
        "05") icon="🕔" ;;
        "06") icon="🕕" ;;
        "07") icon="🕖" ;;
        "08") icon="🕗" ;;
        "09") icon="🕘" ;;
        "10") icon="🕙" ;;
        "11") icon="🕚" ;;
        "12") icon="🕛" ;;
    esac
    
    HOUR=$(date "+ %I:%M%p")
    
    # Hour="$(date '+%H:%M:%S')" #time in HH:MM:SS format
    printf "%s%s" "$(echo -e ^c$color6^ )^d^" "$(echo -e ^c$color3^^b$color6^ $icon $HOUR)"
}

datetime() {
    printf "%s%s" "$(DMY) $(hour)"
}

sound() {
    vol="$(amixer get Master | sed -n 's/^.*\[\([0-9]\+\)%.*$/\1/p' | uniq)"
    printf "%s%s" "$(echo -e ^c$color7^ $powerline_h)^d^" "$(echo -e ^c$color3^^b$color7^ "" $vol'%')"
}

dwm_alsa() {
    STATUS=$(amixer sget Master | tail -n1 | sed -r "s/.*\[(.*)\]/\1/")
    VOL=$(amixer get Master | tail -n1 | sed -r "s/.*\[(.*)%\].*/\1/")
    if [ "$IDENTIFIER" = "unicode" ]; then
        if [ "$STATUS" = "off" ]; then
            printf "%s%s" "$(echo -e ^c$color7^ $powerline_h)^d^" "$(echo -e ^c$color3^^b$color7^ 🔇)"
        else
            #removed this line becuase it may get confusing
            if [ "$VOL" -gt 0 ] && [ "$VOL" -le 33 ]; then
                printf "%s%s" "$(echo -e ^c$color7^ $powerline_h)^d^" "$(echo -e ^c$color3^^b$color7^ "🔈" $VOL'%')"
                elif [ "$VOL" -gt 33 ] && [ "$VOL" -le 66 ]; then
                printf "%s%s" "$(echo -e ^c$color7^ $powerline_h)^d^" "$(echo -e ^c$color3^^b$color7^ "🔉" $VOL'%')"
            else
                printf "%s%s" "$(echo -e ^c$color7^ $powerline_h)^d^" "$(echo -e ^c$color3^^b$color7^ "" $VOL'%')"
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
}

updates() {
    updates=$(checkupdates | wc -l)
    if [ -z "$updates" ]; then
        printf "^c$color12^$powerline_h^d^" "^c$color1^^b$color12^  Ok"
    else
        printf "%s%s" "^c$color12^$powerline_h^d^" "^c$color1^^b$color12^  $updates"
    fi
}

df_check_location='/home'
PREFIX_FILESYSTEM='🖴'
get_disk() {
    df_output=$(df -h $df_check_location | tail -n 1)
    STOUSED=$(echo $df_output | awk '{print $3}')
    STOTOT=$(echo $df_output | awk '{print $2}')
    STOPER=$(echo $df_output | awk '{print $5}')
    printf "^c$color14^$powerline_h^d^%s %s,%s" "^c$color15^^b$color14^$PREFIX_FILESYSTEM" "$STOTOT" "$STOUSED"
}

memory() {
    free_output=$(free -h | grep Mem)
    MEMUSED=$(echo $free_output | awk '{print $3}')
    MEMTOT=$(echo $free_output | awk '{print $2}')
    #ram="$(free -t | awk 'FNR == 2 {printf "%.0f", $3/$2*100}')"
    printf "%s%s" "$(echo -e ^c$color16^$powerline_h)^d^" "$(echo -e ^c$color17^^b$color16^ " T/U:" $MEMTOT,$MEMUSED )"
}

battery_status() {
    local bat=$1
    local ac=$(upower -i "$(upower -e | grep "$bat")" | grep 'state' | awk -F'[:] ' '{print $2}')
    local percent=$(upower -i "$(upower -e | grep "$bat")" | grep 'percentage' | awk -F'[:] ' '{print $2}' | tr -d '%,[:blank:]')
    
    if [[ -z $ac ]]; then
        printf " " # No battery information available
        elif [[ $ac == "charging" ]]; then
        printf "  $percent%%"
        elif [[ $ac == "fully-charged" ]]; then
        printf " "
    else
        if [[ $percent -ge 0 && $percent -le 20 ]]; then
            printf "^c$color13^  $percent%%^d^"
            elif [[ $percent -ge 20 && $percent -le 40 ]]; then
            printf "^c$color13^  $percent%%^d^"
            elif [[ $percent -ge 40 && $percent -le 60 ]]; then
            printf "^c$color11^  $percent%%^d^"
            elif [[ $percent -ge 60 && $percent -le 80 ]]; then
            printf "^c$color12^  $percent%%^d^"
            elif [[ $percent -ge 80 && $percent -le 100 ]]; then
            printf "^c$color6^  $percent%%^d^"
        fi
    fi
}

batteries_t480() {
    local battery0_status=$(battery_status 'BAT0')
    local battery1_status=$(battery_status 'BAT1')
    
    if [[ -n $battery0_status && -n $battery1_status ]]; then
        printf "%s%s" "^c$color17^$powerline_h^d^" "^c$color11^^b$color17^$battery0_status"
        # else
        #   printf "%s%s" "^c$color17^$powerline_h^d^ ^c$color8^^b$color2^  "
    fi
}

# By Luke Smith
# Module showing CPU load as a changing bars.
# Just like in polybar.
# Each bar represents amount of load on one core since
# last run.

# Cache in tmpfs to improve speed and reduce SSD load

cpu_usage() {
    cache=/tmp/cpubarscache
    # id total idle
    stats=$(awk '/cpu[0-9]+/ {printf "%d %d %d\n", substr($1,4), ($2 + $3 + $4 + $5), $5 }' /proc/stat)
    [ ! -f $cache ] && echo "$stats" >"$cache"
    old=$(cat "$cache")
    printf "🖥 "
    echo "$stats" | while read -r row; do
        id=${row%% *}
        rest=${row#* }
        total=${rest%% *}
        idle=${rest##* }
        
        case "$(echo "$old" | awk '{if ($1 == id)
            printf "%d\n", (1 - (idle - $3)  / (total - $2))*100 /12.5}' \
            id="$id" total="$total" idle="$idle")" in
                
                "0") printf "^c$color6^▁^d^" ;;
                "1") printf "^c$color6^▂^d^" ;;
                "2") printf "^c$color12^▃^d^" ;;
                "3") printf "^c$color12^▄^d^" ;;
                "4") printf "^c$color12^▅^d^" ;;
                "5") printf "^c$color11^▆^d^" ;;
                "6") printf "^c$color11^▇^d^" ;;
                "7") printf "^c$color13^█^d^" ;;
                "8") printf "^c$color13^█^d^" ;;
        esac
    done
    # printf "\\n"
    echo "$stats" >"$cache"
}

PREFIX=' '
FIRE=' '

WARNING_LEVEL=80

intel_cpu_temp() {
    sensors | awk -F '[+°]' '/^Core [0-9]+:/ {s+=$2; c++; m==""?m=x=$2:0;
    if ($2>x) x=$2; if ($2<m) m=$2} END {if (c>0) printf("μ: %.1f ∈ [%d, %d]\n", s/c, m, x)}'
}

get_cputemp() {
    
    if [ "$CPU_TYPE" = "AMD" ]; then
        CPU_TEMP="$(sensors | grep Tctl | awk 'NR==1{gsub("+", " "); gsub("\\..", " "); print $2}')"
    else
        # Get temperature data just for CPU cores and calculate min, max, and mean
        CPU_TEMP="$(intel_cpu_temp)"
    fi
    
    if [ -z $CPU_TEMP ]; then
        CPU_TEMP="$(sensors | grep Tctl | awk 'NR==1{gsub("+", " "); gsub("\\..", " "); print $2}')"
    fi
    
    if [ "$CPU_TEMP" -ge $WARNING_LEVEL ]; then
        PREFIX="^b$color4^$FIRE$PREFIX"
    fi
    
    printf "$PREFIX$CPU_TEMP°C"
}

dwm_spotify() {
    if ps -C spotify >/dev/null; then
        PLAYER="spotify"
        elif ps -C spotifyd >/dev/null; then
        PLAYER="spotifyd"
        elif ps -C ncspot >/dev/null; then
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
            [ "$STATUS" = "Playing" ] && STATUS="▶" || STATUS="⏸"
            [ "$SHUFFLE" = "On" ] && SHUFFLE="  " || SHUFFLE=""
        else
            [ "$STATUS" = "Playing" ] && STATUS="PLA" || STATUS="PAU"
            [ "$SHUFFLE" = "On" ] && SHUFFLE=" SHF ON" || SHUFFLE=""
        fi
        
        #printf "%s%s %s-%s %02d:%02d/%02d:%02d%s\n" "^c$color11^$powerline_h^d^" "^c$color1^^b$color11^$STATUS" "${ARTIST:0:10}" "${TRACK:0:9}>" $((POSITION % 3600 / 60)) $((POSITION % 60)) $((DURATION % 3600 / 60)) $((DURATION % 60)) "$SHUFFLE"
        # printf "%s%s-%s %02d:%02d/%02d:%02d%s\n" "^c$color11^$powerline_h^d^" "^c$color1^^b$color11^${ARTIST:0:10}" "${TRACK:0:10}>" $((POSITION % 3600 / 60)) $((POSITION % 60)) $((DURATION % 3600 / 60)) $((DURATION % 60))
        printf "%s%s %s-%s" "^c$color11^$powerline_h^d^" "^c$color1^^b$color11^$STATUS" "${ARTIST:0:10}" "${TRACK:0:9}"
    else
        printf "^c$color11^$powerline_h^d^^c$color1^^b$color11^Off"
    fi
}


sys_tray_space() {
    printf "        "
}

max_length=22

while true; do
    # ## Get current Spotify status
    # spotify_status=$(dwm_spotify)
    
    # # Calculate the number of spaces to append
    # current_length=${#spotify_status}
    # spaces_to_append=$((max_length - current_length))
    
    # # If spaces_to_append is negative, just set it to 0
    # if (( spaces_to_append < 0 )); then
    #     max_length=$((current_length + 10))  # Add 20 or any other number you think is appropriate
    #     spaces_to_append=$((max_length - current_length))
    # fi
    
    # # Append space characters to the status
    # spotify_status_padded="$spotify_status$(printf '%*s' $spaces_to_append)"
    
    # xsetroot -name "$spotify_status_padded$(batteries_t480) | $(get_cputemp) | $(cpu_usage)$(memory)$(get_disk)$(updates)$(dwm_alsa)$(datetime)$(sys_tray_space)"
    xsetroot -name "$(batteries_t480) | $(get_cputemp) | $(cpu_usage)$(memory)$(get_disk)$(updates)$(dwm_alsa)$(datetime)$(sys_tray_space)"
    sleep 1
done
