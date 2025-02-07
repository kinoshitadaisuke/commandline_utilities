#!/bin/sh

#
# Time-stamp: <2025/02/07 12:11:46 (UT+8) daisuke>
#

###########################################################################
#
# Daisuke's small utilities
#
#  daisuke_lualatex.sh
#
#   utility to execute LuaLaTeX to generate PDF file from LaTeX source file
#
#   author: Kinoshita Daisuke
#
#   version 1.0: 21/Jul/2024
#   version 1.1: 07/Feb/2025
#
###########################################################################

###########################################################################

#
# optional arguments
#

#
# -e : location of "expr" command (default: /bin/expr)
# -h : printing help message
# -l : location of "lualatex" command (default: /usr/pkg/bin/lualatex)
# -s : turning on -shell-escape option (default: 0)
# -v : verbosity level (default: 0)
#

#
# positional arguments
#

#
#  LaTeX source file
#

#
# usage
#
#  executing LuaLaTeX
#   % lualatex.sh foo.tex
#
#  executing LuaLaTeX with -shell-escape option
#   % lualatex.sh -s foo.tex
#

###########################################################################

###########################################################################

#
# default values of parameters
#

# expr command
expr='/bin/expr'

# lualatex command
lualatex='/usr/pkg/bin/lualatex'

# shell escape flag
shell_escape=0

# verbosity level
verbosity=0

###########################################################################

###########################################################################

#
# functions
#

# function to print help message
print_help_message () {
    echo "$0"
    echo ""
    echo "Utility to execute LuaLaTeX to make PDF file from LaTeX source file"
    echo ""
    echo " (c) Kinoshita Daisuke, 2024"
    echo ""
    echo "USAGE:"
    echo ""
    echo "  $0 [options] file"
    echo ""
    echo "OPTIONAL ARGUMENTS:"
    echo ""
    echo "  -e : location of \"expr\" command (default: /bin/expr)"
    echo "  -h : printing help message"
    echo "  -l : location of \"lualatex\" command (default: /usr/pkg/bin/lualatex)"
    echo "  -s : shell escape flag (default: 0)"
    echo "  -v : verbosity level (default: 0)"
    echo ""
    echo "POSITIONAL ARGUMENTS"
    echo ""
    echo "  LaTeX source file"
    echo ""
}

# function to check existence of directory
check_existence () {
    if [ ! -e $file_latex ]
    then
        echo "ERROR:"
        echo "ERROR: file \"$file_latex\" does not exist!"
        echo "ERROR:"
        exit 1
    fi
}

# function to execute LuaLaTeX
execute_lualatex () {
    # command
    if [ $shell_escape -gt 0 ]
    then
	command_lualatex="$lualatex -shell-escape $file_latex"
    else
	command_lualatex="$lualatex $file_latex"
    fi

    # printing status
    if [ $verbosity -gt 0 ]
    then
	echo "#"
	echo "# now, executing LuaLaTeX command"
	echo "#"
	echo "#  command: $command_lualatex"
	echo "#"
    fi

    # executing command
    $command_lualatex
    
    # printing status
    if [ $verbosity -gt 0 ]
    then
	echo "#"
	echo "# finished executing LuaLaTeX command"
	echo "#"
	echo "#  command: $command_lualatex"
	echo "#"
    fi
}

# function to print input parameters
print_parameters () {
    echo "#"
    echo "# input parameters"
    echo "#"
    echo "#  Commands"
    echo "#   expr command     : $expr"
    echo "#   lualatex command : $lualatex"
    echo "#"
    echo "#  Options"
    echo "#   -shell-escape    : $shell_escape"
    echo "#"
    echo "#  Verbosity level"
    echo "#   verbosity level : $verbosity"
    echo "#"
    echo "#  LaTeX source file"
    echo "#   file            : $file_latex"
    echo "#"
}

###########################################################################

###########################################################################

#
# command-line argument analysis
#

# command-line argument analysis
while getopts "e:hl:sv" args
do
    case "$args" in
        e)
            # -e option: location of expr command
            expr=$OPTARG
            ;;
        h)
            # -h option: printing help message
            print_help_message
            exit 1
            ;;
        l)
            # -l option: location of lualatex command
            lualatex=$OPTARG
            ;;
        s)
            # -s option: shell escape flag
            shell_escape=`$expr $shell_escape + 1`
            ;;
        v)
            # -v option: verbosity level
            verbosity=`$expr $verbosity + 1`
            ;;
        \?)
            print_help_message
            exit 1
    esac
done
shift $((OPTIND - 1))

# if length of the first positional argument is zero, then stop
if [ -z $1 ]
then
    echo "ERROR:"
    echo "ERROR: one positional argument has to be given!"
    echo "ERROR:  \"fetch\" or \"update\" or \"clean\""
    echo "ERROR:"
    exit 1
fi

# if length of the second positional argument is non-zero, then stop
if [ ! -z $2 ]
then
    echo "ERROR:"
    echo "ERROR: number of positional arguments must be one!"
    echo "ERROR:"
    exit 1
fi

# positional argument
file_latex=$1

###########################################################################

# existence check
check_existence

# printing parameters
if [ $verbosity -gt 0 ]
then
    print_parameters
fi

# executing LuaLaTeX command twice
execute_lualatex
execute_lualatex

# printing parameters
if [ $verbosity -gt 0 ]
then
    print_parameters
fi

###########################################################################
