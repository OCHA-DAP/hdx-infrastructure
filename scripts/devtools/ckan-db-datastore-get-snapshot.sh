#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

# includes the config file to define YOUR specific parameters
# (ckan and cps location, branches etc)
. $(which devtoolconfig.sh)

ckan_db_backup="NON-EXISTENT-BACKUP"

function get_last_backup_name {
	echo -en "Getting the last backup name: "
 	ckan_db_backup=$(rsync -e "ssh -o PasswordAuthentication=no" --list-only $ckan_backup_user@$ckan_backup_server:$ckan_backup_dir/$ckan_backup_datastore_prefix* | tail -n 1 | awk '{ print $5 }')
	if [ $? -ne 0 ]; then
		echo -en "failed.\n";
		exit 1;
	fi
	echo -en "$ckan_db_backup\n"
}

function get_backup {
	mkdir -p $ckan_tmp_dir
	echo -en "Getting the last backup of datastore... "
	rsync -av --progress -e "ssh -o PasswordAuthentication=no" $ckan_backup_user@$ckan_backup_server:$ckan_backup_dir/$ckan_db_backup $ckan_tmp_dir/
	if [ $? -ne 0 ]; then
		echo -en "failed. \n";
		exit 2;
	fi
}

# main
get_last_backup_name;
get_backup;

if [[ $_ != $0 ]]; then
	echo "Script completed."
	echo "The backup file is: $ckan_tmp_dir/$ckan_db_backup."
	echo "Please do not forget to remove the file after you got it."
	echo "Thank you."
fi
cd $curr_dir;
