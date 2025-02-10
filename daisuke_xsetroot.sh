#!/bin/sh

#
# Time-stamp: <2025/02/10 23:33:33 (UT+8) daisuke>
#

#
# NetBSD utils
#
# wrapper program for xsetroot
#
# author: Kinoshita Daisuke
#
# version 1.0: 10/Feb/2025
#

#
# commands
#
expr="/bin/expr"
hostname="/bin/hostname"
xsetroot="/usr/X11R7/bin/xsetroot"

#
# default options
#
opt_xsetroot="-solid grey"

#
# initial values
#
verbosity=0

#
# function to print usage message
#
print_usage () {
    # printing message
    echo "daisuke_xsetroot.sh"
    echo ""
    echo " Author: Kinoshita Daisuke (c) 2025"
    echo ""
    echo " Usage:"
    echo "  -h : print usage"
    echo "  -x : choice of xsetroot (native or pkgsrc, default: native)"
    echo "  -v : verbose mode (default: 0)"
    echo ""
    echo " Examples:"
    echo "  printing help"
    echo "   % daisuke_xsetroot.sh -h"
    echo ""
}

#
# command-line argument analysis
#
while getopts "hx:v" args
do
    case "$args" in
        h)
            # printing usage
            print_usage
            # exit
            exit 1
            ;;
	x)
	    # choice of xsetroot command ("native" or "pkgsrc")
	    case "$OPTARG" in
		native)
		    # native xsetroot
		    xsetroot="/usr/X11R7/bin/xsetroot"
		    ;;
		pkgsrc)
		    # modular x11 xsetroot from pkgsrc
		    xsetroot="/usr/pkg/bin/xsetroot"
		    ;;
		*)
		    # printing error message
		    echo "ERROR:"
		    echo "ERROR: choice of xsetroot: \"native\" or \"pkgsrc\""
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
list_commands="$expr $hostname $xsetroot"
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
	opt_xsetroot="-solid teal"
	;;
    nb01)
	opt_xsetroot="-solid DarkSlateGrey"
	;;
    nb02)
	opt_xsetroot="-solid sienna4"
	;;
    nb03)
	opt_xsetroot="-solid LightSkyBlue4"
	;;
    nb04)
	opt_xsetroot="-solid DarkViolet"
	;;
    kichijoji)
	opt_xsetroot="-solid olive"
	;;
    taoyuan)
	opt_xsetroot="-solid DeepSkyBlue4"
	;;
    s3b)
	opt_xsetroot="-solid RosyBrown"
	;;
    asagaya)
	opt_xsetroot="-solid SkyBlue4"
	;;
    *)
	opt_xsetroot="-solid bisque"
	;;
esac
	
#
# colours for bg colour on xterm
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
# colours for xsetroot
#
# brown
#  RosyBrown
#  DarkGoldenrod
#  sienna
#  khaki4
#  gold4
#  goldenrod4
#  salmon4
#  sienna4
#  SaddleBrown
#  coral4
#
# purple
#  MediumOrchid3
#  DarkOrchid
#  DarkViolet
#
# green
#  olive
#  OliveDrab
#  DarkSeaGreen4
#  OliveDrab4
#  DarkOliveGreen
#  aquamarine4
#  teal
#
# blue
#  PaleTurquoise4
#  LightSkyBlue4
#  CadetBlue4
#  SkyBlue4
#  SteelBlue4
#  DeepSkyBlue4
#
# grey
#  DarkSlateGrey
#

#
# execution of xsetroot command
#
command_xsetroot="$xsetroot $opt_xsetroot"
if [ $verbosity -gt 0 ]
then
    echo "#"
    echo "# command = $command_xsetroot"
    echo "#"
fi
exec $command_xsetroot
