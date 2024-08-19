#!/usr/pkg/bin/python3.10

#
# Time-stamp: <2023/08/03 14:04:26 (CST) daisuke>
#

# importing argparse module
import argparse

# importing sys module
import sys

# importing pathlib module
import pathlib

# importing qrcode module
import qrcode
import qrcode.image.styledpil
import qrcode.image.styles.moduledrawers.pil

# constructing parser object
descr  = 'QR code generator'
parser = argparse.ArgumentParser (description=descr)

# choices
choices_error_correction = ['L', 'M', 'Q', 'H']
choices_drawer = ['Square', 'GappedSquare', 'Circle', \
                  'Rounded', 'VerticalBars', 'HorizontalBars']

# adding arguments
parser.add_argument ('-b', '--background', default='white', \
                     help='background colour (default: white)')
parser.add_argument ('-c', '--correction', default='M', \
                     choices=choices_error_correction, \
                     help='error correction parameter (default M)')
parser.add_argument ('-d', '--drawer', default='Square', \
                     choices=choices_drawer, \
                     help='choice of drawer (default: Square)')
parser.add_argument ('-f', '--foreground', default='black', \
                     help='foreground colour (default: black)')
parser.add_argument ('-q', '--qrcodeversion', type=int, default=1, \
                     help='QR code version (default: 1)')
parser.add_argument ('-s', '--size', type=int, default=40, \
                     help='box size (default: 40)')
parser.add_argument ('-o', '--output', default='qrcode.png', \
                     help='output file name (default: qrcode.png)')
parser.add_argument ('-w', '--border', type=int, default=4, \
                     help='width of border (default: 4)')
parser.add_argument ('string', nargs=1, default=None, \
                     help='string to convert into QR code (default: None)')

# command-line argument analysis
args = parser.parse_args ()

# input parameters
bg_colour        = args.background
error_correction = args.correction
drawer           = args.drawer
fg_colour        = args.foreground
qrcode_version   = args.qrcodeversion
size             = args.size
file_output      = args.output
border           = args.border
string           = args.string[0]

# making pathlib object for output file
path_output = pathlib.Path (file_output)

# if output file already exists, then stop script
if (path_output.exists ()):
    # printing message
    print (f'ERROR: output file "{file_output}" exists!')
    # stopping script
    sys.exit (0)

# error correction parameter
if (error_correction == 'L'):
    error_correction_parameter = qrcode.constants.ERROR_CORRECT_L
elif (error_correction == 'M'):
    error_correction_parameter = qrcode.constants.ERROR_CORRECT_M
elif (error_correction == 'Q'):
    error_correction_parameter = qrcode.constants.ERROR_CORRECT_Q
elif (error_correction == 'H'):
    error_correction_parameter = qrcode.constants.ERROR_CORRECT_H
else:
    # printing message
    print (f'ERROR: something is wrong with error correction parameter!')
    # stopping script
    sys.exit (0)

# drawer
if (drawer == 'Square'):
    module_drawer \
        = qrcode.image.styles.moduledrawers.pil.SquareModuleDrawer ()
elif (drawer == 'GappedSquare'):
    module_drawer \
        = qrcode.image.styles.moduledrawers.pil.GappedSquareModuleDrawer ()
elif (drawer == 'Circle'):
    module_drawer \
        = qrcode.image.styles.moduledrawers.pil.CircleModuleDrawer ()
elif (drawer == 'Rounded'):
    module_drawer \
        = qrcode.image.styles.moduledrawers.pil.RoundedModuleDrawer ()
elif (drawer == 'VerticalBars'):
    module_drawer \
        = qrcode.image.styles.moduledrawers.pil.VerticalBarsModuleDrawer ()
elif (drawer == 'HorizontalBars'):
    module_drawer \
        = qrcode.image.styles.moduledrawers.pil.HorizontalBarsModuleDrawer ()
else:
    # printing message
    print (f'ERROR: something is wrong with choice of drawer!')
    # stopping script
    sys.exit (0)

# constructing "QRCode" object
qr = qrcode.QRCode (
    version=qrcode_version,
    error_correction=error_correction_parameter,
    box_size=size,
    border=border,
    )

# string to be converted into QR code
qr.add_data (string)

# style
style = qrcode.image.styledpil.StyledPilImage

# generating QR code
img = qr.make_image (fill_color=fg_colour, back_color=bg_colour, \
                     image_factory=style, module_drawer=module_drawer)

# saving QR code image into a file
img.save (file_output)
