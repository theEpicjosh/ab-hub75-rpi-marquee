#!/bin/bash

#sudo rm /home/pi/.emulationstation/scripts/game-select/log.txt
#echo "${1}, ${2}, ${3}, ${4}" >> /home/pi/.emulationstation/scripts/game-select/log.txt

# GEN SCRIPT

	new_name=${3}
	newer_name=${3}

	if [[ ${new_name} == *:* ]]; then
		newer_name=${new_name//:/ -};
	fi

	if [[ ${new_name} == Pokémon* ]]; then
		newer_name=${new_name//Pokémon/Pokemon -}
	fi

	if [[ "${new_name}" =~ [A-Z] ]]; then 
		small_name="${new_name,,}";
	fi

	if [[ "${3}" =~ ^The[[:space:]]+(.+) ]]; then
		newer_name="${BASH_REMATCH[1]}, The"
	fi

# END GEN SCRIPT

# Remove temp python script, as will be mentioned later.
sudo rm ~/.emulationstation/scripts/python/start.py
sudo rm ~/.emulationstation/scripts/game-select/name.txt

# Write python script with modified BASH-only variable to a new file.
echo "import glob
import time

import adafruit_blinka_raspberry_pi5_piomatter as piomatter
import numpy as np
import PIL.Image as Image

width = 128
height = 32

# Use glob to find the first matching file
gif_file_pattern = \"/home/pi/.emulationstation/marquee_images/*/${newer_name}.png\"
matching_files = glob.glob(gif_file_pattern)

if not matching_files:
	gif_file_pattern = \"/home/pi/.emulationstation/marquee_images/*/${newer_name} (*.png\"
	matching_files = glob.glob(gif_file_pattern)

elif not matching_files:
	gif_file_pattern = \"/home/pi/.emulationstation/marquee_images/*/${small_name}.png\"
	matching_files = glob.glob(gif_file_pattern)

#elif not matching_files:
#	gif_file_pattern = \"/home/pi/.emulationstation/marquee_images/*/${newer_name} *.png\"
#	matching_files = glob.glob(gif_file_pattern)

#elif not matching_files:
#        gif_file_pattern = \"/home/pi/.emulationstation/marquee_images/*/*${newer_name}*.png\"
#        matching_files = glob.glob(gif_file_pattern)

elif not matching_files:
    print(\"No matching GIF found in path \" + gif_file_pattern + \"!\")
#	gif_file_pattern = \"/home/pi/.emulationstation/marquee_images/*/retropie.png\"
#	matching_files = glob.glob(gif_file_pattern)
   #exit(1)  # Exit if no file is found

gif_file = matching_files[0]  # Use the first matching file

canvas = Image.new('RGB', (width, height), (0, 0, 0))
geometry = piomatter.Geometry(width=width, height=height,
                              n_addr_lines=4, rotation=piomatter.Orientation.Normal)
framebuffer = np.asarray(canvas) + 0  # Make a mutable copy
matrix = piomatter.PioMatter(colorspace=piomatter.Colorspace.RGB888Packed,
                             pinout=piomatter.Pinout.AdafruitMatrixBonnet,
                             framebuffer=framebuffer,
                             geometry=geometry)

with Image.open(gif_file) as img:
    print(f\"frames: {img.n_frames}\")
    while True:
        for i in range(img.n_frames):
            img.seek(i)
            canvas.paste(img, (0,0))
            framebuffer[:] = np.asarray(canvas)
            matrix.show()
            time.sleep(0.1)" >> ~/.emulationstation/scripts/python/start.py # Save python script, as mentioned earlier

echo ${newer_name} >> ~/.emulationstation/scripts/game-select/name.txt

# Run python script, displaying the image.
/home/pi/venvs/blinka_venv/bin/python /home/pi/.emulationstation/scripts/python/start.py &
