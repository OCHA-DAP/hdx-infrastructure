#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

cps_location="/opt/www/tomcat";

sudo -u tomcat $cps_location/tomcat/control.sh restart > /dev/null

if [ $? -ne 0 ]; then
	echo "Command failed.";
	exit 2;
fi

echo "Success!"
