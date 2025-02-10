#!/bin/sh

#
# Time-stamp: <2025/02/10 14:49:40 (UT+8) daisuke>
#

# location of "vncserver" command
vncserver="/usr/pkg/bin/vncserver"

# option
opt_vncserver="-geometry 2560x1440"

# execution of "vncserver" command
command_vncserver="${vncserver} ${opt_vncserver}"
echo "#"
echo "# ${command_vncserver}"
echo "#"
${command_vncserver}
