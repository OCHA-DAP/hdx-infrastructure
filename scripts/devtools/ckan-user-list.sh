#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

# includes the config file to define YOUR specific parameters
# (ckan and cps location, branches etc)
. $(which devtoolconfig.sh)

function list_users {
	paster user list -c $ckan_ini_file 2> /dev/null
	if [ $? -ne 0 ]; then
		echo "create user failed.";
		exit 2;
	fi
}

function pretty_list_users {
	user_list=$(paster user -c $ckan_ini_file | grep -E "^name=");
	for user in $(echo $user_list | sed -e 's/^User name=//; s/ display=.*//'); do
		pretty_list_user_details $user;
	done
}

function pretty_list_user_details {
	user_string=$(paster user $1 -c $ckan_ini_file | grep -E "^<User ")
	user_username=$(echo $user_string | sed -e 's/.* name=//; s/ openid=.*//');
	user_fullname=$(echo $user_string | sed -e 's/.* fullname=//; s/ email=.*//');
	user_email=$(echo $user_string | sed -e 's/.* email=//; s/ apikey=.*//');
	echo "$user_username,user_email,user_fullname"
}

activate;
if [ $1 -eq "-p" ]; then
	pretty_list_users;
else
	list_users;
fi
deactivate;
cd $curr_dir;

if [ $? -ne 0 ]; then
	echo "Command failed.";
	exit 3;
fi

echo "Success!";
