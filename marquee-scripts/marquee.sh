#!/bin/bash

# GEN SCRIPT

	new_name=${3}
	newer_name=${3}

	if [[ ${new_name} == *:* ]]; then
		newer_name=${new_name//:/ -};
	fi

	if [[ ${new_name} == Pokémon* ]]; then
		newer_name=${new_name//Pokémon/Pokemon -}
	fi

#	if [[ ${new_name} == Disney's* ]]; then
#		newer_name=${new_name//Disney's /}
#	fi

	if [[ "${3}" =~ ^The[[:space:]]+(.+) ]]; then
		newer_name="${BASH_REMATCH[1]}, The"
	fi

# END GEN SCRIPT

echo ${newer_name} >> /tmp/marquee_pipe
echo ${newer_name} >> /home/pi/.emulationstation/scripts/marquee_logs.txt
