#!/bin/bash

menu(){

HEIGHT=21
WIDTH=90
CHOICE_HEIGHT=1
BACKTITLE="AB-HUB75-RPI-Marquee"
TITLE="AB-HUB75-RPi-Marquee Driver Installer."
MENU="Welcome to the AB-HUB75-RPi-Marquee Driver Installer.
(Adafruit Bonnet / HUB75 Displays / Raspberry Pi 5/RetroPie / Marquee)

This script was created by theEpicjosh and was created for pre-bought arcade cabinets.

Due to copyright reasons, we did not ship you with a RetroPie image as the firmware is and should be free.

We are not affiliated with RetroPie (or any of the software included) and neither are we affiliated with Adafruit or Pixelcade, which is what we use the marquee images for.

This installer script assumes you have followed ALL directions in the GitHub file:
theEpicjosh/ab-hub75-rpi-marquee/README.md"

OPTIONS=(1 "Credits"
         2 "INSTALL")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
	1) credits ; menu ;;
	2) installer ; menu ;;
esac
}

function credits() {
	dialog --clear --title "CREDITS" \
	--msgbox \
\
	"
	Pixelcade: GitHub repo 'alkine/pixelcade'" \
\
	10 75
clear
}

function installer() {

	ITITLE="Installing..."
	IDESC="Installing drivers..."
	IHEIGHT=10
	IWIDTH=50
{
	sleep 1
 
	cd ~/.emulationstation || exit 1
	git clone https://github.com/alkine/pixelcade.git || exit 1
	mv pixelcade marquee-images || exit 1
	cd marquee-images/system || exit 1
	cp default-gamecube.png default-gc.png || exit 1
	cd ~/.emulationstation || exit 1
	mv ~/ab-hub75-rpi-marquee/marquee-scripts scripts || exit 1
	cd ~ || exit 1

    	} | while IFS= read -r line; do
		progress=$(echo "$line" | awk '{print $1}')
		text=$(echo "$line" | cut -d' ' -f2-)
		echo "$progress"
		echo "XXX"
		echo "$text"
		echo "XXX"
		sleep 0.1
	done | dialog --title "$ITITLE" --gauge "Starting installation..." $IHEIGHT $IWIDTH 0

    	dialog --clear --title "Complete!" --msgbox "The AB-HUB75-RPi-Marquee drivers have been installed!" $IHEIGHT $IWIDTH
	dialog --clear --title "Reboot?" --yesno \
		"You need to reboot your machine before you enable the drivers. \
		\
		Would you like to do this now?" \
	$IHEIGHT $IWIDTH
	dia_st=$?

if [ "$dia_st" -eq 0 ]; then sudo reboot
	fi
}

menu ;
