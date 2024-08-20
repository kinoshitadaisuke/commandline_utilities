#!/bin/sh

#
# Time-stamp: <2024/08/16 13:38:42 (UT+8) daisuke>
#

###########################################################################
#
# Daisuke's small utilities
#
#  daisuke_benchmark_ubench_cpu.sh
#
#   utility to measure CPU performance
#
#   author: Kinoshita Daisuke
#
#   version 1.0: 16/Aug/2024
#
###########################################################################

###########################################################################

#
# parameters
#

# locations of commands
date='/bin/date'
expr='/bin/expr'
hostname='/bin/hostname'
grep='/usr/bin/grep'
tail='/usr/bin/tail'
uname='/usr/bin/uname'
perl='/usr/pkg/bin/perl'
ubench='/usr/pkg/bin/ubench'

# number of executions of command
n=1

# doing multiple CPU performance measurement?
m=0

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
    echo "Utility to measure CPU performance using Unix Benchmark Utility"
    echo ""
    echo " (c) Kinoshita Daisuke, 2024"
    echo ""
    echo "USAGE:"
    echo ""
    echo "  $0 [options] files"
    echo ""
    echo "OPTIONS:"
    echo ""
    echo "  -m : carrying out multiple CPU score measurements (default: 0)"
    echo "  -n : number of executions of ubench command (default: 10)"
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
while getopts "n:hv" args
do
    case "$args" in
        m)
            # -m option: multiple
            m=`$expr $m + 1`
            ;;
        n)
            # -n option: action
	    n=$OPTARG
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

###########################################################################

###########################################################################

#
# measurement of single CPU core performance
#

yyyymmdd=`$date`
host=`$hostname`
arch=`$uname -mprs`

# printing header
echo "#"
echo "# Unix Benchmark Utility (ubench) results"
echo "#"
echo "#  date:         $yyyymmdd"
echo "#  host name:    $host"
echo "#  architecture: $arch"
echo "#"

# temporary files to store results of benchmark
file_single_raw="/tmp/ubench_single_raw_$$.txt"
file_single_average="/tmp/ubench_single_average_$$.txt"
file_multiple_raw="/tmp/ubench_multiple_raw_$$.txt"
file_multiple_average="/tmp/ubench_multiple_average_$$.txt"

# taking data for single CPU core performance
i=0
while [ $i -lt $n ]
do
    if [ $i = 0 ]
    then
	$ubench -cs > $file_single_raw
    else
	$ubench -cs >> $file_single_raw
    fi
    i=`$expr $i + 1`
done

# calculating average score for single CPU core performance
$grep 'Ubench Single CPU' $file_single_raw | $perl -ne 'chop; (@list)=split; $total+=$list[3]; $i++; printf ("%12d %d\n", $total, $i);' > $file_single_average
$tail -1 $file_single_average | $perl -ne 'chop; ($total, $n)=split; $average=$total / $n; printf ("Ubench single CPU:   %8d\n", $average);'

if [ $m -gt 0 ]
then
    # taking data for multiple CPU core performance
    i=0
    while [ $i -lt $n ]
    do
	if [ $i = 0 ]
	then
	    $ubench -c > $file_multiple_raw
	else
	    $ubench -c >> $file_multiple_raw
	fi
	i=`$expr $i + 1`
    done
    
    # calculating average score for multiple CPU core performance
    $grep 'Ubench CPU' $file_multiple_raw | $perl -ne 'chop; (@list)=split; $total+=$list[2]; $i++; printf ("%12d %d\n", $total, $i);' > $file_multiple_average
    $tail -1 $file_multiple_average | $perl -ne 'chop; ($total, $n)=split; $average=$total / $n; printf ("Ubench multiple CPU: %8d\n", $average);'
fi
    
