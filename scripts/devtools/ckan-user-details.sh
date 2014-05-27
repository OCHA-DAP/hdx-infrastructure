#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

# includes the config file to define YOUR specific parameters
# (ckan and cps location, branches etc)
. $(which devtoolconfig.sh)

username=""
user_details=""

function get_user_data {
	read -p "Username? " username
}

function check_if_user_exists {
	user_string=$(paster user $username -c $ckan_ini_file)
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
deactivate;
cd $curr_dir;

if [ $? -ne 0 ]; then
	echo "Command failed.";
	exit 3;
fi

echo "Success!";
