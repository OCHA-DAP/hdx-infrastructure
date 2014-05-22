#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

ckan_base_dir="/opt/ckan"
ini_file="/etc/ckan/prod.ini"
curr_dir=$(pwd)

username=""
user_details=""
function activate {
	cd $ckan_base_dir
	. bin/activate
	cd src/ckan
}

function get_user_data {
	read -p "Username? " username
}

function check_if_user_exists {
	user_string=$(paster user $username -c $ini_file)
	user_exists=$(echo $user_string | grep -c "<User id=")
	if [ $user_exists -eq 0 ]; then
		echo "user does not exist. exiting...";
		exit 1;
	fi
	user_details=$user_string;
}

function list_user_details {
	echo $user_details;
}

activate;
get_user_data;
check_if_user_exists;
list_user_details;

if [ $? -ne 0 ]; then
	echo "Command failed.";
	exit 3;
fi

echo "Success!";
cd $curr_dir;
