#!/usr/pkg/bin/python3.12

#
# Time-stamp: <2024/08/29 21:01:00 (UT+8) daisuke>
#

# importing argparse module
import argparse

# importing pathlib module
import pathlib

# importing sys module
import sys

# default values
default_file_rgb    = '/usr/X11R7/lib/X11/rgb.txt'
default_file_output = 'x11_colours.html'

# constructing a parser object
descr  = 'making a X11 colour table'
parser = argparse.ArgumentParser (description=descr)

# adding arguments
parser.add_argument ('-i', '--file-rgb', default=default_file_rgb, \
                     help='location of file "rgb.txt" (default: /usr/X11R7/lib/X11/rgb.txt)')
parser.add_argument ('-o', '--file-output', default=default_file_output, \
                     help='output file (default: x11_colours.html)')

# parsing argument
args = parser.parse_args ()

# parameters
file_rgb    = args.file_rgb
file_output = args.file_output

# making pathlib objects
path_rgb    = pathlib.Path (file_rgb)
path_output = pathlib.Path (file_output)

# existence check of "rgb.txt"
if not (path_rgb.exists ()):
    # printing error message
    print (f'#')
    print (f'# ERROR: file "{file_rgb}" does not exist!')
    print (f'#')
    # stopping the script
    sys.exit (1)
    

# if not a regular file, then stop the script
if not (path_rgb.is_file ()):
    # printing error message
    print (f'#')
    print (f'# ERROR: file "{file_rgb}" is not a regular file!')
    print (f'#')
    # stopping the script
    sys.exit (1)

# if file_output already exists, then stop the script
if (path_output.exists ()):
    # printing error message
    print (f'#')
    print (f'# ERROR: file "{file_output}" exists!')
    print (f'#')
    # stopping the script
    sys.exit (1)

# header of HTML file
html_header = '''
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
html {
    font-size: 12px;
}
body {
    font-size: 1.5rem;
}
.blink {
    animation: blinking 1s ease-in-out infinite alternate;
}
@keyframes blinking {
    0% {opacity: 0.3;}
    100% {opacity: 1;}
}
img {
  max-width: 100%;
  display:   block;
}
.items {
  display:         flex;
  justify-content: space-between;
}
.strike {
  text-decoration: line-through;
}
pre {
  display:          inline-block;
  padding:          0.2em 1.0em;
  background-color: #d1f2eb;
  border:           solid 3px Black;
  border-radius:    10px;
}
table {
  display: inline-table;
  margin:  1em;
  border:  solid 5px;
}
table th {
  border: solid 2px;
}
table td {
  border: solid 1px;
}
</style>
<title>X11 Colours</title>
</head>
<body>
<h1>X11 Colours</h1>
<center>
<table border=1>
<tr>
 <th>Colour Name</th>
 <th>Colour Code (hex)</th>
 <th>R value</th>
 <th>G value</th>
 <th>B value</th>
 <th>Colour</th>
</tr>
'''

# footer of HTML file
html_footer = '''
</table>
</center>
<hr>
<address>HTML file created by Daisuke</address>
</body>
</html>
'''

# initialisation of dictionary for colours
dic_colours = {}

# opening file for writing
with open (file_output, 'w') as fh_out:
    # writing HTML header to output file
    fh_out.write (html_header)
    # opening file
    with open (file_rgb, 'r') as fh_in:
        # reading file line-by-line
        for line in fh_in:
            # removing line feed at the end of line
            line = line.strip ()
            # getting colour code and colour name
            (colour_code, colour_name) = line.split ('\t\t')
            # values of R, G, and B
            (r_str, g_str, b_str) = colour_code.split ()
            # converting string into integer
            try:
                r_int = int (r_str)
            except:
                print (f'#')
                print (f'# WARNING: unable to convert "{r_str}" into integer!')
                print (f'#')
                continue
            try:
                g_int = int (g_str)
            except:
                print (f'#')
                print (f'# WARNING: unable to convert "{g_str}" into integer!')
                print (f'#')
                continue
            try:
                b_int = int (b_str)
            except:
                print (f'#')
                print (f'# WARNING: unable to convert "{b_str}" into integer!')
                print (f'#')
                continue
            # converting decimal into hex
            r_hex = hex (r_int)[2:]
            g_hex = hex (g_int)[2:]
            b_hex = hex (b_int)[2:]
            if (len (r_hex) == 1):
                r_hex = f'0{r_hex:1s}'
            if (len (g_hex) == 1):
                g_hex = f'0{g_hex:1s}'
            if (len (b_hex) == 1):
                b_hex = f'0{b_hex:1s}'
            rgb_hex = f'#{r_hex:2s}{g_hex:2s}{b_hex:2s}'
            # adding data to dictionary
            dic_colours[colour_name] = {}
            dic_colours[colour_name]["hex"] = rgb_hex
            dic_colours[colour_name]["r"]   = r_int
            dic_colours[colour_name]["g"]   = g_int
            dic_colours[colour_name]["b"]   = b_int
    # processing each colour
    for key, value in sorted (dic_colours.items (), \
                              key=lambda x: x[1]["hex"], reverse=True):
        # printing data
        fh_out.write (f'<tr>\n')
        fh_out.write (f' <td align=left>{key}</td>\n')
        fh_out.write (f' <td align=right>{dic_colours[key]["hex"]}</td>\n')
        fh_out.write (f' <td align=right>{dic_colours[key]["r"]}</td>\n')
        fh_out.write (f' <td align=right>{dic_colours[key]["g"]}</td>\n')
        fh_out.write (f' <td align=right>{dic_colours[key]["b"]}</td>\n')
        fh_out.write (f' <td style="width:512px;background-color:{dic_colours[key]["hex"]};"></td>\n')
        fh_out.write (f'</tr>\n')
    # writing HTML footer to output file
    fh_out.write (html_footer)
