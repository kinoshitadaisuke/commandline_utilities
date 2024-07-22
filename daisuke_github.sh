#!/bin/sh

#
# Time-stamp: <2024/07/22 20:30:14 (UT+8) daisuke>
#

###########################################################################
#
# Daisuke's small utilities
#
#  daisuke_github.sh
#
#   utility to add / delete files for GitHub repository
#
#   author: Kinoshita Daisuke
#
#   version 1.0: 22/Jul/2024
#
###########################################################################

###########################################################################

#
# parameters
#

# locations of commands
date='/bin/date'
expr='/bin/expr'
git='/usr/pkg/bin/git'

# action (add or delete)
action='add'

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
    echo "Utility to commit files to GitHub repository"
    echo ""
    echo " (c) Kinoshita Daisuke, 2024"
    echo ""
    echo "USAGE:"
    echo ""
    echo "  $0 [options] files"
    echo ""
    echo "OPTIONS:"
    echo ""
    echo "  -a : action (\"add\" or \"delete\", default: add)"
    echo "  -d : location of date command (default: /bin/date)"
    echo "  -e : location of expr command (default: /bin/expr)"
    echo "  -g : location of git command (default: /usr/pkg/bin/git)"
    echo "  -h : printing help message"
    echo "  -v : verbosity level (default: 0)"
    echo ""
}

###########################################################################

###########################################################################

#
# command-line argument analysis
#

# command-line argument analysis
while getopts "a:d:e:g:hv" args
do
    case "$args" in
	a)
	    # -a option: action
	    action=$OPTARG
	    ;;
	d)
	    # -d option: location of date command
	    date=$OPTARG
	    ;;
        e)
            # -e option: location of expr command
            expr=$OPTARG
            ;;
        g)
            # -g option: location of git command
            git=$OPTARG
            ;;
        h)
            # -h option: printing help message
            print_help_message
            exit 1
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
    echo "ERROR: at least one positional argument has to be given!"
    echo "ERROR:"
    exit 1
fi

# value of "action" must be either "add" or "delete"
if [ $action != 'add' ] && [ $action != 'delete' ]
then
    echo "ERROR:"
    echo "ERROR: value of \"action\" must be either \"add\" or \"delete\"!"
    echo "ERROR:"
    exit 1
fi

###########################################################################

###########################################################################

#
# committing files to GitHub repository
#

for file_commit in $@
do
    # printing status
    if [ $verbosity -gt 0 ]
    then
	echo "#"
	echo "# now, processing file \"${file_commit}\"..."
	echo "#"
    fi

    if [ -e $file_commit ]
    then
	#
	# adding or deleting file
	#
	
	# command to be executed
	if [ $action = 'add' ]
	then
	    # command to be executed
	    command_git_1="$git add $file_commit"
	elif [ $action = 'delete' ]
	then
	    # command to be executed
	    command_git_1="$git rm $file_commit"
	fi

	# executing command
	echo "$command_git_1"
	$command_git_1

	#
	# committing file
	#

	# comment for committing
	current_date=`$date +"%e/%b/%Y"`
	if [ $action = 'add' ]
	then
	    comment="adding $file_commit on $current_date"
	elif [ $action = 'delete' ]
	then
	    comment="deleting $file_commit on $current_date"
	fi

	# command to be executed
	command_git_2="$git commit -m \"$comment\""
	# executing command
	echo "$command_git_2"
	$command_git_2

	#
	# pushing file
	#

	# command to be executed
	command_git_3="$git push"
	# executing command
	echo "$command_git_3"
	$command_git_3

	# printing executed commands
	if [ $verbosity -gt 0 ]
	then
	    echo "#"
	    echo "# executed commands"
	    echo "#"
	    echo "#  $command_git_1"
	    echo "#  $command_git_2"
	    echo "#  $command_git_3"
	    echo "#"
	fi
    else
	echo "# WARNING:"
	echo "# WARNING: file \"$file_commit\" does not exist!"
	echo "# WARNING:"
    fi
    
    # printing status
    if [ $verbosity -gt 0 ]
    then
	echo "#"
	echo "# finished processing file \"${file_commit}\"!"
	echo "#"
    fi
done
