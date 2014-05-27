#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

# includes the config file to define YOUR specific parameters
# (ckan and cps location, branches etc)
. $(which devtoolconfig.sh)

username=""
password=""
email=""

function get_user_data {
	read -p "Username? " username
	read -p "Passowrd? " password
	read -p "Email?    " email
}

function check_if_user_exists {
	user_string=$(paster user $username -c $ckan_ini_file)
	user_exists=$(echo $user_string | grep -c "<User id=")
	if [ $user_exists -eq 1 ]; then
		echo "user already exists. exiting...";
		exit 1;
	fi
}

function create_user {
	paster user add $username email=$email password="'"$password"'" -c $ckan_ini_file 2> /dev/null
	if [ $? -ne 0 ]; then
		echo "create user failed.";
		exit 2;
	fi
}

activate;
get_user_data;
check_if_user_exists;
create_user;
deactivate;
cd $curr_dir;

if [ $? -ne 0 ]; then
	echo "Command failed.";
	exit 3;
fi

echo "Success!";
