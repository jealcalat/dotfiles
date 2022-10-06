#!/bin/sh
## Wi-fi
wlan() {
	case "$(cat /sys/class/net/w*/operstate 2>/dev/null)" in
		up) printf "$SEP1   $SEP2";;
		down) printf "$SEP1 睊  $SEP2";;
	esac
}
wlan
