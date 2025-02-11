#!/usr/pkg/bin/python3.12

#
# Time-stamp: <2025/02/11 14:04:01 (UT+8) daisuke>
#

# importing sys module
import sys

# location of command "convert"
command_convert = '/usr/pkg/bin/convert'
command_magick = '/usr/pkg/bin/magick'

# cropping region
region = '1546x2024+1094+0'

# processing each file
for file_png in sys.argv:
    # if not PNG file, then skip
    # if not a file with file name starting with "Newton", then skip
    if not ( (file_png[:6] == 'Newton') and (file_png[-3:] == 'png') ):
        print (f"# Skipping '{file_png}'...")
        continue

    # TIFF file name
    file_tiff = file_png[:-4] + 'c.tif'

    # cropped PNG file name
    file_png2 = file_png[:-4] + 'c.png'

    # command to crop PNG file and create a TIFF file
    command_crop = f"{command_magick} -crop {region} {file_png} {file_tiff}"

    # printing commands
    print (f"# {file_png} ==> {file_tiff}")
    print (f"echo {command_crop}")
    print (f"{command_crop}")

    # command to convert TIFF file into PNG file
    command_tif2png = f"{command_magick} {file_tiff} {file_png2}"

    # printing commands
    print (f"# {file_tiff} ==> {file_png2}")
    print (f"echo {command_tif2png}")
    print (f"{command_tif2png}")
