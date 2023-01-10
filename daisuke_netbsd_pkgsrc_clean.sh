#!/bin/sh

#
# Time-stamp: <2023/01/10 22:57:47 (CST) daisuke>
#

#
# Daisuke's command-line tools
#
#  cleaning NetBSD's pkgsrc directory tree
#
#  author: Kinoshita Daisuke
#
#  version 1.0: 29/May/2022
#  version 2.0: 10/Jan/2023
#
#  usage:
#
#   % daisuke_netbsd_pkgsrc_clean.sh -d /usr/pkgsrc
#

# command's name
command=daisuke_netbsd_pkgsrc_clean.sh

#
# default varlues
#

# verbosity level
verbosity=0

# list of work directories
list_workdir=""

# number of work directories
n_dir=0

#
# files and directories
#

# location of pkgsrc tree
dir_pkgsrc=/usr/pkgsrc

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
    expr=/bin/expr
    make=/usr/bin/make
elif [ $system = "FreeBSD" ]
then
    expr=/bin/expr
    make=/usr/bin/make
elif [ $system = "Linux" ]
then
    expr=/usr/bin/expr
    make=/usr/bin/make
fi

#
# functions
#

# usage message
print_usage () {
    # printing usage message
    echo "netbsd_pkgsrc_clean.sh"
    echo ""
    echo " Author: Kinoshita Daisuke (c) 2022,2023"
    echo ""
    echo " Usage:"
    echo "  -d : location of pkgsrc system (default: /usr/pkgsrc)"
    echo "  -h : print usage"
    echo "  -v : verbose mode (default: 0)"
    echo ""
    echo " Examples:"
    echo "  cleaning work directories under /usr/pkgsrc"
    echo "   % netbsd_pkgsrc_clean.sh"
    echo "  cleaning work directories under /data/pkgsrc"
    echo "   % netbsd_pkgsrc_clean.sh -d /data/pkgsrc"
    echo ""
}

#
# command-line argument analysis
#
while getopts "d:hv" args
do
    case "$args" in
	d)
	    # location of pkgsrc system
	    dir_pkgsrc=$OPTARG
	    ;;
        h)
            # printing usage
            print_usage
            # exit
            exit 1
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

# if pkgsrc directory tree does not exist, then exit
if [ ! -e $dir_pkgsrc ]
then
    # printing message
    echo "ERROR:"
    echo "ERROR: pkgsrc system not found under $dir_pkgsrc"
    echo "ERROR:"
    # exit
    exit 1
fi

# priting message
if [ $verbosity -gt 0 ]
then
    echo "# now, finding work directories to be cleaned..."
fi

# finding work directories to be cleaned
for dir_work in $dir_pkgsrc/*/*/work*
do
    # appending work directory to the list
    list_workdir="$list_workdir $dir_work"
    # counting number of work directories
    n_dir=`$expr $n_dir + 1`
done

# priting message
if [ $verbosity -gt 0 ]
then
    echo "# finished finding work directories to be cleaned!"
fi

# priting message
if [ $verbosity -gt 0 ]
then
    echo "# list of work directories to be cleaned:"
    for dir_work in $list_workdir
    do
	echo "#  $dir_work"
    done
    echo "# number of work directories to be cleaned = $n_dir"
fi

# cleaning work directories
for dir_work in $list_workdir
do
    if [ -e $dir_work ]
    then
        dir_package=${dir_work%/*}
        cd $dir_package
        $make clean
    fi
done

# priting message
if [ $verbosity -gt 0 ]
then
    echo "# finished cleaning $n_dir work directories!"
fi
