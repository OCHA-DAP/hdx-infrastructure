#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

# includes the config file to define YOUR specific parameters
# (ckan and cps location, branches etc)
. $(which devtoolconfig.sh)

username=""
is_sysadmin=1

function get_user_data {
	read -p "Username? " username
}

function check_user_status {
	user_string=$(paster user $username -c $ckan_ini_file);
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

function demote_user {
	if [ $is_sysadmin -eq 0 ]; then
		echo "user is not sysadmin. exiting...";
	fi
	paster sysadmin remove $username -c $ckan_ini_file
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
demote_user;
deactivate;
cd $curr_dir;

if [ $? -ne 0 ]; then
	echo "Command failed.";
	exit 3;
fi

echo "Success!";
