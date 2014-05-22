#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

ckan_base_dir="/opt/ckan"
ini_file="/etc/ckan/prod.ini"
curr_dir=$(pwd)

username=""
password=""
email=""

function activate {
	cd $ckan_base_dir
	. bin/activate
	cd src/ckan
}

function list_users {
	paster user list -c $ini_file 2> /dev/null
	if [ $? -ne 0 ]; then
		echo "create user failed.";
		exit 2;
	fi
}

activate;
list_users;

if [ $? -ne 0 ]; then
	echo "Command failed.";
	exit 3;
fi

echo "Success!";
cd $curr_dir;
