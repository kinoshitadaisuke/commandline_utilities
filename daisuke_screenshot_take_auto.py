#!/usr/pkg/bin/python3.12

#
# Time-stamp: <2024/08/27 11:47:20 (UT+8) daisuke>
#

#
# History
#
#    prototype on 26/Feb/2022
#    version 1.0 on 28/Feb/2022
#    version 2.0 on 08/Apr/2023 (use of xwd --> import of ImageMagick)
#    version 3.0 on 26/Aug/2024
#

# importing argparse module
import argparse

# importing sys module
import sys

# importing time module
import time

# importing subprocess module
import subprocess

# importing pathlib module
import pathlib

# importing regular expression module
import re

# constructing a parser object
desc   = 'taking screenshots and moving to next page automatically'
parser = argparse.ArgumentParser (description=desc)

# adding arguments
choices_format = ['bmp', 'eps', 'gif', 'jpg', 'png', \
                  'pdf', 'ppm', 'ps', 'tiff', 'wmf']
choices_direction = ['vertical', 'horizontal']
parser.add_argument ('-b', '--book', default='book', \
                     help='book name (default: book)')
parser.add_argument ('-f', '--format', choices=choices_format, default='png', \
                     help='image format (default: png)')
parser.add_argument ('-i', '--initial', type=int, default=10, \
                     help='initial sleep time before screenshots (default: 10)')
parser.add_argument ('-n', '--number', type=int, default=150, \
                     help='number of pages (default: 150)')
parser.add_argument ('-s', '--sleep', type=int, default=8, \
                     help='sleep time between screenshots (default: 8 sec)')
parser.add_argument ('-c', '--convert', default='/usr/pkg/bin/convert', \
                     help='location of convert (default: /usr/pkg/bin/convert)')
parser.add_argument ('-t', '--xdotool', default='/usr/pkg/bin/xdotool', \
                     help='location of xdotool (default: /usr/pkg/bin/xdotool)')
parser.add_argument ('-p', '--xdpyinfo', default='/usr/X11R7/bin/xdpyinfo', \
                     help='location of xdpyinfo (default: /usr/X11R7/bin/xdpyinfo)')
parser.add_argument ('-w', '--xwd', default='/usr/X11R7/bin/xwd', \
                     help='location of xwd (default: /usr/X11R7/bin/xwd)')
parser.add_argument ('-m', '--kimport', default='/usr/pkg/bin/import', \
                     help='location of import (default: /usr/pkg/bin/import)')
parser.add_argument ('-x', '--offsetx', type=int, default=3640, \
                     help='location of the mouse from edge (default: 3640)')
parser.add_argument ('-y', '--offsety', type=int, default=1130, \
                     help='location of the mouse from bottom (default: 1130)')
parser.add_argument ('-d', '--direction', choices=choices_direction, \
                     default='vertical', \
                     help='writing direction (default: vertical)')

# parsing argument
args = parser.parse_args ()

# parameters
book_name         = args.book
image_format      = args.format
number_pages      = args.number
sleep_initial     = args.initial
sleep_interval    = args.sleep
command_convert   = args.convert
command_xdotool   = args.xdotool
command_xdpyinfo  = args.xdpyinfo
command_xwd       = args.xwd
command_import    = args.kimport
offset_x          = args.offsetx
offset_y          = args.offsety
writing_direction = args.direction

# check of existence of commands
#list_command = [command_convert, command_xdotool, command_xdpyinfo, \
#                command_xwd, command_import]
list_command = [command_convert, command_import, \
                command_xdotool, command_xdpyinfo]
for command in list_command:
    path_command = pathlib.Path (command)
    if not (path_command.exists ()):
        print (f'The command "{command}" does not exists!')
        print (f'Install the command "{command}"!')
        print (f'Exitting...')
        sys.exit ()

# size of the screen
output_xdpyinfo = subprocess.run (command_xdpyinfo, shell=True, \
                                  capture_output=True)
output_xdpyinfo_str = output_xdpyinfo.stdout.decode ('utf8')
pattern_dimensions = re.compile ('dimensions:\s+(\d+)x(\d+)\s+pixels')
match_dimensions = re.search (pattern_dimensions, output_xdpyinfo_str)
if (match_dimensions):
    x_size = int (match_dimensions.group (1))
    y_size = int (match_dimensions.group (2))
else:
    print (f'Something is wrong with the command "{command_xdpyinfo}"!')
    sys.exit ()

# mouse cursor position
if (writing_direction == 'vertical'):
    mousepos_x = offset_x
    mousepos_y = y_size - offset_y
elif (writing_direction == 'horizontal'):
    mousepos_x = x_size - offset_x
    mousepos_y = y_size - offset_y
    
# printing status
print (f'Taking screenshots')
print (f'  Waiting {sleep_initial} sec before taking screenshots...')

# initial sleep before starting screenshots
time.sleep (sleep_initial)

# printing status
print (f'  Now, starting to take screenshots!')

for i in range (number_pages):
    # file names
    file_base   = f'{book_name}_{i:06d}'
    file_png    = f'{file_base}.png'
    file_output = f'{file_base}.{image_format}'

    # printing status
    print (f'  Taking page {i+1}...')
    print (f'    now, taking a screenshot...')
    
    # taking a screenshot using 'xwd' command
    #command_screenshot = "%s -root -out %s" % (command_xwd, file_xwd)
    #subprocess.run (command_screenshot, shell=True)

    # taking a screenshot using 'import' command
    command_screenshot = f'{command_import} -window root {file_png}'
    subprocess.run (command_screenshot, shell=True)

    # printing status
    print (f'    file "{file_png}" is created!')

    if (image_format != 'png'):
        # printing status
        print (f'    converting image to {image_format} format...')
    
        # converting file format
        command_conversion = f'{command_convert} {file_png} {file_output}'
        subprocess.run (command_conversion, shell=True)
        
        # printing status
        print (f'    file "{file_output}" is created!')
        print (f'    deleting the file "{file_png}"...')

        # removing xwd file
        #path_xwd = pathlib.Path (file_xwd)
        #path_xwd.unlink (missing_ok=True)

        # removing png file
        path_png = pathlib.Path (file_png)
        path_png.unlink (missing_ok=True)

        # printing status
        #print (f'    finished deleting the file "{file_xwd}"!')
        print (f'    finished deleting the file "{file_png}"!')

    # printing status
    print (f'    simulating a mouse click...')

    # simulating a mouse move
    command_mousemove = f'{command_xdotool} mousemove {mousepos_x} {mousepos_y}'
    subprocess.run (command_mousemove, shell=True)
    
    # simulating a mouse click to move to next page
    command_mouseclick = f'{command_xdotool} click 1'
    subprocess.run (command_mouseclick, shell=True)

    # printing status
    print (f'    finished simulating a mouse click!')
    print (f'    sleeping for {sleep_interval} sec...')
    
    # sleeping between screenshots
    time.sleep (sleep_interval)
        
    # printing status
    print (f'    finished sleeping for {sleep_interval} sec!')
    print (f'  Finished taking page {i+1:06d}')

# printing status
print (f'Finished taking screenshots for all the pages!')
