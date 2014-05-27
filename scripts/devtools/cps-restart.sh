#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

# includes the config file to define YOUR specific parameters
# (ckan and cps location, branches etc)
. $(which devtoolconfig.sh)

sudo -u tomcat $cps_dir/tomcat/control.sh restart > /dev/null

if [ $? -ne 0 ]; then
	echo "Command failed.";
	exit 2;
fi

echo "Success!"
