#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

ckan_base_dir="/opt/ckan"
ini_file="/etc/ckan/prod.ini"
curr_dir=$(pwd)

function activate {
	cd $ckan_base_dir
	. bin/activate
	cd src/ckan
}

function list_sysadmins {
	paster sysadmin list -c $ini_file
}

activate;
list_sysadmins;
deactivate;
cd $curr_dir;

if [ $? -ne 0 ]; then
	echo "Command failed.";
	exit 3;
fi

echo "Success!";
