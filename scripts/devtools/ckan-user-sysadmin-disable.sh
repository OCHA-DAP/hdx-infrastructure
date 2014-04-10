#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

ckan_base_dir="/usr/lib/ckan/default"
ini_file="/etc/ckan/default/production.ini"
curr_dir=$(pwd)

username=""
is_sysadmin=1

function activate {
	cd $ckan_base_dir
	. bin/activate
	cd src/ckan
}

function get_user_data {
	read -p "Username? " username
}

function check_user_status {
	user_string=$(paster user $username -c $ini_file);
	user_exists=$(echo $user_string | grep -c "<User id=");
	user_is_sysadmin=$(echo $user_string | grep -c "sysadmin=True");
	if [ $user_exists -eq 0 ]; then
		echo "user does not exists. exiting...";
		exit 1;
	fi
	if [ $user_is_sysadmin -eq 0 ]; then
		is_sysadmin=0;
	fi
}

function promote_user {
	if [ $is_sysadmin -eq 0 ]; then
		echo "user is not sysadmin. exiting...";
	fi
	paster sysadmin remove $username -c $ini_file
	check_user_status;
	if [ $is_sysadmin -ne 0 ]; then
		echo "i could not disable sysadmin status on that user. exiting..."
		exit 2;
	fi
	echo "sysadmin disabled for "$username".";
}

activate;
get_user_data;
check_user_status;
promote_user;

if [ $? -ne 0 ]; then
	echo "Command failed.";
	exit 3;
fi

echo "Success!";
cd $curr_dir;
