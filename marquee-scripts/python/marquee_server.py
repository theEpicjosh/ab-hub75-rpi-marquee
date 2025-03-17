import glob
import os
import time
import errno
import threading
import textwrap
from threading import Thread

import PIL
from PIL.ImageFile import ImageFile
from PIL import ImageDraw, ImageFont

import adafruit_blinka_raspberry_pi5_piomatter as piomatter
import numpy as np
import PIL.Image as Image

filename = '/tmp/marquee_pipe'
image: ImageFile | None = None
current_gif = None
frame_index: int = 0

image_lock = threading.Lock()

width = 128
height = 32

try:
    os.mkfifo(filename)
except OSError as oe:
    if oe.errno != errno.EEXIST:
        raise

canvas = Image.new('RGB', (width, height), (0, 0, 0))
geometry = piomatter.Geometry(width=width, height=height,
                              n_addr_lines=4, rotation=piomatter.Orientation.Normal)
framebuffer = np.asarray(canvas) + 0  # Make a mutable copy

matrix = piomatter.PioMatter(colorspace=piomatter.Colorspace.RGB888Packed,
                             pinout=piomatter.Pinout.AdafruitMatrixBonnet,
                             framebuffer=framebuffer,
                             geometry=geometry)

def change_name(name):
    global image
    global image_lock
    global frame_index
    global current_gif

    print(f"name: {name}")
    
    small_name = name.lower()

    # Use glob to find the first matching file
    gif_file_pattern = f"/home/pi/.emulationstation/marquee_images/*/{name}.png"
    matching_files = glob.glob(gif_file_pattern)

    if not matching_files:
        gif_file_pattern = f"/home/pi/.emulationstation/marquee_images/*/{name} (*.png"
        matching_files = glob.glob(gif_file_pattern)

    elif not matching_files:
        gif_file_pattern = f"/home/pi/.emulationstation/marquee_images/*/{small_name}.png"
        matching_files = glob.glob(gif_file_pattern)

    elif not matching_files:
        gif_file_pattern = f"/home/pi/.emulationstation/marquee_images/*/{name}*.png"
        matching_files = glob.glob(gif_file_pattern)

    elif not matching_files:
        gif_file_pattern = f"/home/pi/.emulationstation/marquee_images/*/*{name}.png"
        matching_files = glob.glob(gif_file_pattern)

    elif not matching_files:
        gif_file_pattern = f"/home/pi/.emulationstation/marquee_images/console/default-{name}.png"
        matching_files = glob.glob(gif_file_pattern)

    elif not matching_files:
        print(f'No matching GIF found for name "{name}" or "{small_name}"!')
#       gif_file_pattern = "/home/pi/.emulationstation/marquee_images/*/retropie.png"
        matching_files = glob.glob(gif_file_pattern)

    image_lock.acquire()

    frame_index = 0

    if len(matching_files) == 0:
        if image != None:
            image.close()
            image = None
        current_gif = None

        image = PIL.Image.new(mode="RGB", size=(width, height))
        image.n_frames = 1
        draw = ImageDraw.Draw(image)
        font = ImageFont.truetype("/home/pi/.emulationstation/marquee_images/fonts/PixTall.ttf",16)

        draw.text((width / 2, height / 2), name, anchor='mm', fill=(255,64,0), font=font)
        
        image_lock.release()
        return

    if current_gif == matching_files[0]:
        image_lock.release()
        return

    if image != None:
        image.close()

    current_gif = matching_files[0]
    image = Image.open(current_gif)

    image_lock.release()

def render():
    global frame_index
    global image
    global image_lock

    if image is not None and image.n_frames == 1 and frame_index == 1: return

    framebuffer[:] = np.zeros((height, width, 3))
    if image is not None:
        image_lock.acquire()

        image.seek(frame_index)
        canvas.paste(image, (0,0))
        framebuffer[:] = np.asarray(canvas)
        frame_index = (frame_index + 1) % image.n_frames

        image_lock.release()
    matrix.show()


def reader():
    global gif_name
    print("Running reader")
    with open(filename) as fifo:
        while True:
            data = fifo.read().strip()
            if (len(data) == 0): continue
            change_name(data)

thread = Thread(target=reader)
thread.start()

while True:
    render()
    time.sleep(0.1)
