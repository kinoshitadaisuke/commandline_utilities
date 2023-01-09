#!/bin/sh

#
# Time-stamp: <2023/01/09 20:55:34 (CST) daisuke>
#

#
# Daisuke's command-line tools
#
#  copying files if larger in size
#
#  author: Kinoshita Daisuke
#
#  version 1.0: 09/Jan/2023
#
#  usage:
#
#   % daisuke_copy_if_larger.sh /some/where/in/the/disk/*
#

#
# important parameters
#

# command's name
command=daisuke_copy_if_larger.sh

# verbosity level
verbosity=0

# destination directory
dir_destination=.

# list of files actually copied
list_copied=""

# system architecture
if [ -e /bin/uname ]
then
    system=`/bin/uname -s`
elif [ -e /usr/bin/uname ]
then
    system=`/usr/bin/uname -s`
else
    echo "Cannot find the command 'uname'!"
    echo "Exiting..."
    exit 1
fi

#
# commands
#

if [ $system = "NetBSD" ]
then
    cp=/bin/cp
    expr=/bin/expr
    stat=/usr/bin/stat
elif [ $system = "Linux" ]
then
    cp=/usr/bin/cp
    expr=/usr/bin/expr
    stat=/usr/bin/stat
fi

# list of commands to be used
list_commands="$cp $expr $stat"

#
# functions
#

# function to print usage instruction
print_usage () {
    # printing usage instruction
    echo "$command"
    echo ""
    echo " Author: Kinoshita Daisuke (c) 2023"
    echo ""
    echo " Usage:"
    echo "  % $command -d destination /some/where/in/the/disk/*"
    echo ""
    echo " Options:"
    echo "  -d : destination directory (default: currently working directory)"
    echo "  -v : verbosity level (default: 0)"
    echo ""
    echo " Examples:"
    echo "  copying files /aaa/bbb/ccc/*.sh to currently working directory"
    echo "   % $command /aaa/bbb/ccc.*.sh"
    echo "  copying files /aaa/bbb/ccc/*.c to /xxx/yyy/zzz"
    echo "   % $command -d /xxx/yyy/zzz /aaa/bbb/ccc.*.c"
    echo ""
}

#
# command-line argument analysis
#
while getopts "d:hv" args
do
    case "$args" in
        d)
            # location of destination directory
            dir_destination=$OPTARG
            ;;
        h)
            # printing usage
            print_usage
            # exit
            exit 0
            ;;
        v)
            # verbosity level
            verbosity=`$expr $verbosity + 1`
            ;;
        \?)
            # printing usage
            print_usage
            # exit
            exit 0
    esac
done
shift $((OPTIND - 1))

# list of files to be copied
list_files=$@

#
# printing parameters if verbosity level is greater than 0
#
if [ $verbosity -gt 0 ]
then
    echo "#"
    echo "# Options:"
    echo "#  -d = $dir_destination"
    echo "#  -v = $verbosity"
    echo "#"
    echo "# Commands:"
    for command_name in $list_commands
    do
	echo "#  $command_name"
    done
    echo "#"
    echo "# Files to be copied:"
    for file in $list_files
    do
	echo "#  $file"
    done
    echo "#"
fi

#
# copying files
#
for path_source in $list_files
do
    # directory name and file name of source file
    dir_source=${path_source%/*}
    file_source=${path_source##*/}

    # directory name and file name of destination file
    file_destination=$file_source
    path_destination="${dir_destination}/${file_destination}"

    # priting message
    echo "Now, processing the file '${path_source}'..."
    
    # printing message if verbosity level is greater than 0
    if [ $verbosity -gt 0 ]
    then
	echo " source full path      = ${path_source}"
	echo " source directory      = ${dir_source}"
	echo " source file name      = ${file_source}"
	echo " destination full path = ${path_destination}"
	echo " destination directory = ${dir_destination}"
	echo " destination file name = ${file_destination}"
    fi

    # finding file size of source file
    if [ -e $path_source ] && [ -f $path_source ]
    then
	if [ $system = 'NetBSD' ]
	then
	    size_source=`$stat -f %z $path_source`
	elif [ $system = 'Linux' ]
	then
	    size_source=`$stat -c %s $path_source`
	fi
    else
	size_source=0
    fi

    # finding file size of destination file
    if [ -e $path_destination ] && [ -f $path_destination ]
    then
	if [ $system = 'NetBSD' ]
	then
	    size_destination=`$stat -f %z $path_destination`
	elif [ $system = 'Linux' ]
	then
	    size_destination=`$stat -c %s $path_destination`
	fi
    else
	size_destination=0
    fi

    # priting file sizes of source file and destination file
    if [ $verbosity -gt 0 ]
    then
	echo " source file size      = ${size_source} byte"
	echo " destination file size = ${size_destination} byte"
    fi

    # copying file
    if [ -e $path_destination ] && [ $size_destination -ge $size_source ]
    then
	echo " file '${path_source}' is not copied!"
    else
	echo " file '${path_source}' is being copied!"
	echo " copying file '${path_source}' to '${dir_destination}'..."
	echo "  ${path_source} ==> ${path_destination}"
	$cp -pf $path_source $path_destination
	list_copied="$list_copied $path_destination"
	echo " finished copying file '${path_source}' to '${dir_destination}'!"
    fi
done

# printing a list of copied files
if [ $verbosity -gt 0 ]
then
    echo "#"
    echo "# summary:"
    echo "#"
    echo "#  list of copied files:"
    for file in $list_copied
    do
	echo "#   $file"
    done
    echo "#"
fi
