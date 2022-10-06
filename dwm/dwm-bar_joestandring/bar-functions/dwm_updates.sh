#!/bin/sh

updates() {
	updates=$(checkupdates | wc -l)
	if [ -z "$updates" ]; then
		printf "$SEP1  Ok $SEP2"
	else
		printf "$SEP1  $updates $SEP2"
	fi
}

check_updates(){
	
	if [[ $((interval % 180)) -eq 0 ]]; then
		printf "$(updates)"
	else 
		printf "$SEP1  Ok $SEP2"
	fi
}

check_updates
