#!/bin/bash
# Simple script to update the dhcp-static files from git

# CONFIGURE THIS TO YOUR GIT DIRECTORY
GIT_REPO=/home/dhcpstatic/dhcp-static

# CONFIGURE THIS TO THE USER TO RUN THE GIT COMMANDS AS
USER=dhcpstatic

cd $GIT_REPO

su -c "git pull" $USER

if ! cmp $GIT_REPO/static.conf /etc/dhcp/static.conf >/dev/null 2>&1 ;
then
    cp $GIT_REPO/static.conf /etc/dhcp/static.conf

    /usr/sbin/service isc-dhcp-server restart
fi

ps -C "dhcpd" 2>&1>/dev/null
if [[ $? -ne 0 ]]
then
    /usr/sbin/service isc-dhcp-server restart
fi
