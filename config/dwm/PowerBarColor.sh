# PowerStatus-dwm
# Author - HashTag-4512
# Date - 19/5/21
# A modular powerline statusbar for dwm

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
  Hour="$(date '+%H:%M:%S')" #time in HH:MM:SS format
  printf "%s%s" "$(echo -e ^c$color6^ )^d^" "$(echo -e ^c$color3^^b$color6^ "" $Hour)"
}

datetime() {
  printf "%s%s" "$(DMY) $(hour)"
}

sound() {
  vol="$(amixer get Master | sed -n 's/^.*\[\([0-9]\+\)%.*$/\1/p' | uniq)"
  printf "%s%s" "$(echo -e ^c$color7^ $powerline_h)^d^" "$(echo -e ^c$color3^^b$color7^ "" $vol'% ')"
}

dwm_alsa() {
  STATUS=$(amixer sget Master | tail -n1 | sed -r "s/.*\[(.*)\]/\1/")
  VOL=$(amixer get Master | tail -n1 | sed -r "s/.*\[(.*)%\].*/\1/")
  if [ "$IDENTIFIER" = "unicode" ]; then
    if [ "$STATUS" = "off" ]; then
      printf "^c$color7^ $powerline_h)^d^ ^c$color3^^b$color7^ 🔇"
    else
      #removed this line becuase it may get confusing
      if [ "$VOL" -gt 0 ] && [ "$VOL" -le 33 ]; then
        printf "%s%s" "$(echo -e ^c$color7^ $powerline_h)^d^" "$(echo -e ^c$color3^^b$color7^ "🔈" $VOL'% ')"
      elif [ "$VOL" -gt 33 ] && [ "$VOL" -le 66 ]; then
        printf "%s%s" "$(echo -e ^c$color7^ $powerline_h)^d^" "$(echo -e ^c$color3^^b$color7^ "🔉" $VOL'% ')"
      else
        printf "%s%s" "$(echo -e ^c$color7^ $powerline_h)^d^" "$(echo -e ^c$color3^^b$color7^ "" $VOL'% ')"
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
  printf "^c$color14^$powerline_h^d^%s %s/%s (%s)" "^c$color15^^b$color14^$PREFIX_FILESYSTEM" "$STOUSED" "$STOTOT" "$STOPER"
}

memory() {
  free_output=$(free -h | grep Mem)
  MEMUSED=$(echo $free_output | awk '{print $3}')
  MEMTOT=$(echo $free_output | awk '{print $2}')
  ram="$(free -t | awk 'FNR == 2 {printf "%.0f", $3/$2*100}')"
  printf "%s%s" "$(echo -e ^c$color16^ $powerline_h)^d^" "$(echo -e ^c$color17^^b$color16^ " " $MEMTOT,$MEMUSED, $ram'% ')"
}

battery0() {
  BAT=$(upower -i $(upower -e | grep 'BAT') | grep 'percentage' | cut -d':' -f2 | tr -d '%,[:blank:]')
  AC=$(upower -i $(upower -e | grep 'BAT') | grep 'state' | cut -d':' -f2 | tr -d '[:blank:]')

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
  BAT=$(upower -i $(upower -e | grep 'BAT1') | grep 'percentage' | cut -d':' -f2 | tr -d '%,[:blank:]')
  AC=$(upower -i $(upower -e | grep 'BAT1') | grep 'state' | cut -d':' -f2 | tr -d '[:blank:]')

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
    printf "%s%s" "^c$color2^$powerline_h BT0%s,BT1%s^d^" "^c$color8^^b$color2^$(battery0)" "$(battery1)"
  else
    printf "%s%s" "^c$color2^$powerline_h^d^" "^c$color8^^b$color2^  "
  fi
}

process() {
  cpu="$(ps -eo pcpu | awk 'BEGIN {sum=0.0f} {sum+=$1} END {printf "%.0f", sum}')"
  printf "%s%s" "$(echo -e ^c$color10^ $powerline_h)^d^" "$(echo -e ^c$color17^^b$color10^ "" $cpu'%')"
}

PREFIX=' '
FIRE=' '

WARNING_LEVEL=80

get_cputemp() {

  if [ "$CPU_TYPE" = "AMD" ]; then
    CPU_TEMP="$(sensors | grep Tctl | awk 'NR==1{gsub("+", " "); gsub("\\..", " "); print $2}')"
  else
    CPU_TEMP="$(sensors | grep temp1 | awk 'NR==1{gsub("+", " "); gsub("\\..", " "); print $2}')"
  fi

  if [ -z $CPU_TEMP ]; then
    CPU_TEMP="$(sensors | grep Tctl | awk 'NR==1{gsub("+", " "); gsub("\\..", " "); print $2}')"
  fi

  if [ "$CPU_TEMP" -ge $WARNING_LEVEL ]; then
    PREFIX="^c$color4^$powerline_h^d^ ^c$color1^^b$color4^$FIRE$PREFIX"
  else
    PREFIX="^c$color1^$powerline_h^d^ ^c$color11^^b$color1^$PREFIX"
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
      if [ "$STATUS" = "Playing" ]; then
        STATUS="▶"
      else
        STATUS="⏸"
      fi
      if [ "$SHUFFLE" = "On" ]; then
        SHUFFLE="  "
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

    printf "%s%s %s-%s" "^c$color11^$powerline_h^d^" "^c$color1^^b$color11^$STATUS" "${ARTIST:0:14}" "${TRACK:0:9}..."
    printf "%0d:%02d/" $((POSITION % 3600 / 60)) $((POSITION % 60))
    printf "%0d:%02d" $((DURATION % 3600 / 60)) $((DURATION % 60))
    printf "%s" "$SHUFFLE "
  fi
}

sys_tray_space() {
  printf "%s%s" "$powerline_s" "    "
}

#update every 30 seconds
while true; do
  xsetroot -name "$(dwm_spotify) $(batteries_t480) $(get_cputemp) $(process) $(memory) $(get_disk) $(updates) $(dwm_alsa) $(datetime) $(sys_tray_space)"

  sleep 1
done
