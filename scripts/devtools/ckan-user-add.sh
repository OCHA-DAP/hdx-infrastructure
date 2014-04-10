#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

ckan_base_dir="/usr/lib/ckan/default"
ini_file="/etc/ckan/default/production.ini"
curr_dir=$(pwd)

username=""
password=""
email=""

function activate {
	cd $ckan_base_dir
	. bin/activate
	cd src/ckan
}

function get_user_data {
	read -p "Username? " username
	read -p "Passowrd? " password
	read -p "Email?    " email
}

function check_if_user_exists {
	user_string=$(paster user $username -c $ini_file)
	user_exists=$(echo $user_string | grep -c "<User id=")
	if [ $user_exists -eq 1 ]; then
		echo "user already exists. exiting...";
		exit 1;
	fi
}

function create_user {
	paster user add $username email=$email password="'"$password"'" -c $ini_file 2> /dev/null
	if [ $? -ne 0 ]; then
		echo "create user failed.";
		exit 2;
	fi
}

activate;
get_user_data;
check_if_user_exists;
create_user;

if [ $? -ne 0 ]; then
	echo "Command failed.";
	exit 3;
fi

echo "Success!";
cd $curr_dir;
