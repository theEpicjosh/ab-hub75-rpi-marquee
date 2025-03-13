# AB-HUB75-RPi-Marquee
Retropie Marquee for the Adafruit Bonnet and the 128x32 HUB75 displays

# DISCLAIMER
There are no files in this repository. You may follow the rest of the directions and setup the Python scripts yourself using the [Pixelcade Image Repository](https://github.com/alinke/pixelcade). However, with the installer expected to come, it should install all of the scripts required for the marquee display for you, but that is for later.

# What is this?
This is the repository for configuring your Adafruit Bonnet controller to the Raspberry Pi / Retropie along with the HUB75 displays.

# Wiring
*You may skip the portion, all the way to __Software__, if you have bought an arcade cabinet from us.*

With your
* Raspberry Pi 5, (from the official Raspberry Pi website)
* Adafruit Bonnet Controller, (from the official Adafruit website)
* 2 x 64*32 HUB 75 Displays, (from AliExpress) with display and power cords included
  * it helps to bolt them together first, (the long way, so that you get ONE giant 128*32 display).
* and a Power Supply capable of transmitting 16 amps, (from any computer store),

you should wire as follows:

1. Place the Adafruit Bonnet Controller on top of the GPIO pins. You may use a GPIO extender if that makes it easier (or if you have a case). It is also a good idea to add a custom heatsink so that the controller doesn't touch any of the major components.
2. Take a display cable and attach one end on one HUB75 display and the other on the other HUB75 display.
3. Take another display cable and attach one end to the Adafruit Bonnet controller and the other end to the HUB75 display. *Make sure that it is right side up with the labels facing the legible side.*
4. Take the power cable included with the HUB75 and attach each end of the pair to each display and attach the single end to your power supply. (It may not be obvious how you connect the single end to your power supply. You may have to shop one together.)

# Software
If you have bought an arcade from us, you already understand that we are not allowed to ship a firmware image included with your package.
However, we have links that are *required* for you to follow in order to get your RetroPie install working!

Before we continue, it is important to know how to "SSH" into your Raspberry Pi which will allow you to use the Pi 5 terminal remotely using your computer.
To do this, 
* Follow the "*Raspberry Pi 5 Setup*" section in Step 1,
* Connect your Pi to and HDMI monitor/TV,
* Open the "Terminal" app and type in, either in Command Prompt, Powershell, or just Terminal, `ssh 192.168.[rest of your ip] -l pi`
* The default password is `raspberry`. If you want increased security, change your password using `passwd pi` and type in a new password.

1. Because this is a Raspberry Pi 5 and this is relatively new hardware at the time of writing this, there is no installer for the Adafruit Bonnet drivers for the Pi 5, it is required to manually install the software yourself. To do so, follow [this guide](https://learn.adafruit.com/rgb-matrix-panels-with-raspberry-pi-5/raspberry-pi-5-setup) (just the page is good enough). For convenience, the environment is also called `blinka_venv`. Make sure you name it this *exactly*.

2. For the same reason and because the RetroPie repositories for pre-made images has not been updated since 2022, it is also required to manually install the software yourself. To do so, follow [this guide](https://retropie.org.uk/docs/Manual-Installation/).

3. Make sure you install the GitHub CLI (`gh`) interface by running "`curl -sS https://webi.sh/gh | sh`".

4. After, type "`gh repo clone theEpicjosh/ab-hub75-rpi-marquee`" and type "`sudo ./install-abmarquee.sh`" (if that doesn't work, type `sudo chmod 755 ./install-abmarquee` and type the previous command again.)
5. Follow installer directions.
