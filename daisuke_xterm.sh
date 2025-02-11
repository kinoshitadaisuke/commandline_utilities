#!/bin/sh

#
# Time-stamp: <2025/02/11 18:44:55 (UT+8) daisuke>
#

#
# NetBSD utils
#
# wrapper program for xterm
#
# author: Kinoshita Daisuke
#
# version 1.0: 05/Feb/2025
# version 1.1: 09/Feb/2025
#

#
# commands
#
expr="/bin/expr"
hostname="/bin/hostname"
xterm="/usr/X11R7/bin/xterm"

#
# default options
#
opt_xterm="-sb -sl 2000 -fg black -bg AntiqueWhite -title "xterm_on_`$hostname -s`" -fn 10x20"
opt_xterm_font="-fn 10x20"

#
# initial values
#
verbosity=0

#
# function to print usage message
#
print_usage () {
    # printing message
    echo "daisuke_xterm.sh"
    echo ""
    echo " Author: Kinoshita Daisuke (c) 2025"
    echo ""
    echo " Usage:"
    echo "  -h : print usage"
    echo "  -f : font to be used (7x14, 8x16, 10x20, 12x24, default: 10x20)"
    echo "  -x : choice of xterm (native or pkgsrc, default: native)"
    echo "  -v : verbose mode (default: 0)"
    echo ""
    echo " Examples:"
    echo "  printing help"
    echo "   % daisuke_xterm.sh -h"
    echo ""
}

#
# command-line argument analysis
#
while getopts "f:hx:v" args
do
    case "$args" in
	f)
	    # choice of fonts (7x14, 8x16, 10x20, 12x24)
	    case "$OPTARG" in
		7x14)
		    opt_xterm_font="-fn 7x14"
		    ;;
		8x16)
		    opt_xterm_font="-fn 8x16"
		    ;;
		10x20)
		    opt_xterm_font="-fn 10x20"
		    ;;
		12x24)
		    opt_xterm_font="-fn 12x24"
		    ;;
		*)
		# printing error message
		echo "ERROR:"
		echo "ERROR: choice of font: \"7x14\" or \"8x16\" or \"10x20\" or \"12x24\""
		echo "ERROR:"
		# exit
		exit 1
		;;
	    esac
	    ;;
        h)
            # printing usage
            print_usage
            # exit
            exit 1
            ;;
	x)
	    # choice of xterm command ("native" or "pkgsrc")
	    case "$OPTARG" in
		native)
		    # native xterm
		    xterm="/usr/X11R7/bin/xterm"
		    ;;
		pkgsrc)
		    # modular x11 xterm from pkgsrc
		    xterm="/usr/pkg/bin/xterm"
		    ;;
		*)
		    # printing error message
		    echo "ERROR:"
		    echo "ERROR: choice of xterm: \"native\" or \"pkgsrc\""
		    echo "ERROR:"
		    ;;
	    esac
	    ;;
	v)
	    # verbosity level
	    verbosity=`$expr $verbosity + 1`
            ;;
        \?)
            # printing usage
            print_usage
            # exit
            exit 1
    esac
done
shift $((OPTIND - 1))

#
# existence check of commands
#
list_commands="$expr $hostname $xterm"
for command in $list_commands
do
    if [ ! -e $command ]
    then
        # printing message
	echo "ERROR:"
        echo "ERROR: command '$command' does not exist!"
        echo "ERROR: install command '$command'!"
	echo "ERROR:"
        # exit
        exit 1
    fi
done

#
# hostname
#
name=`$hostname -s`

#
# background colour
#
case "$name" in
    mitaka|nb00)
	opt_xterm_colour="-bg wheat"
	;;
    nb01)
	opt_xterm_colour="-bg MistyRose"
	;;
    nb02)
	opt_xterm_colour="-bg cornsilk"
	;;
    nb03)
	opt_xterm_colour="-bg honeydew"
	;;
    nb04)
	opt_xterm_colour="-bg PeachPuff"
	;;
    kichijoji)
	opt_xterm_colour="-bg azure"
	;;
    taoyuan)
	opt_xterm_colour="-bg MintCream"
	;;
    s3b)
	opt_xterm_colour="-bg seashell"
	;;
    asagaya)
	opt_xterm_colour="-bg LemonChiffon"
	;;
    *)
	opt_xterm_colour="-bg bisque"
	;;
esac
	
#
# colours
#
# light brown
#  bisque
#  wheat
#  PapayaWhip
#  NavajoWhite
#  PeachPuff
#
# light yellow
#  LemonChiffon
#  LightYellow
#  cornsilk
#
# light pink
#  seashell
#  LavenderBlush
#  MistyRose
#
# light blue/purple
#  MintCream
#  AliceBlue
#  azure
#  lavender
#
# light green
#  honeydew
#  honeydew2
#  DarkSeaGreen1
#  DarkSeaGreen2
#
# default
#  AntiqueWhite

#
# execution of xterm command
#
command_xterm="$xterm $opt_xterm $opt_xterm_font $opt_xterm_colour"
if [ $verbosity -gt 0 ]
then
    echo "#"
    echo "# command = $command_xterm"
    echo "#"
fi
exec $command_xterm
