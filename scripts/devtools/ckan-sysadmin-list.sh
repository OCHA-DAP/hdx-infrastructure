#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

# includes the config file to define YOUR specific parameters
# (ckan and cps location, branches etc)
. $(which devtoolconfig.sh)

function list_sysadmins {
	paster sysadmin list -c $ckan_ini_file
}

function pretty_list_sysadmins {
	user_list=$(paster sysadmin list -c $ckan_ini_file | grep -E "^User name=" | sed -e 's/^User name=//; s/ id=.*//');
	for user in $user_list; do
		pretty_list_user_details $user;
	done
}

function pretty_list_user_details {
	user_string=$(paster user $1 -c $ckan_ini_file | grep -E "^<User ")
	user_username=$(echo $user_string | sed -e 's/.* name=//; s/ openid=.*//');
	user_fullname=$(echo $user_string | sed -e 's/.* fullname=//; s/ email=.*//');
	user_email=$(echo $user_string | sed -e 's/.* email=//; s/ apikey=.*//');
	echo "$user_username,$user_email,$user_fullname"
}

activate;
if [ $# -eq 1 ]; then
	if [ "$1" == "-p" ]; then
		pretty_list_sysadmins;
	else
		echo "use -p to display the pretty list :)";
		exit 1;
	fi
else
	list_sysadmins;
fi
deactivate;
cd $curr_dir;

if [ $? -ne 0 ]; then
	echo "Command failed.";
	exit 3;
fi

echo "Success!";
