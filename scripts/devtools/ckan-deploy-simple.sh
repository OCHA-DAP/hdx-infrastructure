#!/bin/bash


if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

# includes the config file to define YOUR specific parameters
# (ckan and cps location, branches etc)
. $(which devtoolconfig.sh)

ckan-stop.sh
cd $ckan_src_dir
git pull origin $ckan_branch
ckan-start.sh
cd $curr_dir
echo "done.:P"
