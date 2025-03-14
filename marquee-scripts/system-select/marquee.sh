killall /home/pi/venvs/blinka_venv/bin/python
sudo rm ~/.emulationstation/scripts/python/start.py

echo "import glob
import time

import adafruit_blinka_raspberry_pi5_piomatter as piomatter
import numpy as np
import PIL.Image as Image

width = 128
height = 32

# Use glob to find the first matching file
gif_file_pattern = \"/home/pi/.emulationstation/marquee_images/console/default-${1}.png\"
matching_files = glob.glob(gif_file_pattern)

if not matching_files:
	gif_file_pattern = \"/home/pi/.emulationstation/marquee_images/system/${1}.png\"
	matching_files = glob.glob(gif_file_pattern)

elif not matching_files:
	print(\"No matching GIF found in path \" + gif_file_pattern + \"!\")

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
            time.sleep(0.1)" >> ~/.emulationstation/scripts/python/start.py

/home/pi/venvs/blinka_venv/bin/python /home/pi/.emulationstation/scripts/python/start.py &
