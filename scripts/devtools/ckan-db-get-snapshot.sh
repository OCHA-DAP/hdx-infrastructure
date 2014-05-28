#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

# includes the config file to define YOUR specific parameters
# (ckan and cps location, branches etc)
. $(which devtoolconfig.sh)

ckan_db_backup="NON-EXISTENT-BACKUP"
rsync_ssh_options='-e "ssh -o PasswordAuthentication=no"'
#function get_backup_list {
#	rsync --list-only $ckan_backup_user@$ckan_backup_server:$ckan_backup_dir/ | tail -n 5
#}

function get_last_backup_name {
	ckan_db_backup=$(rsync $rsync_ssh_options --list-only $ckan_backup_user@$ckan_backup_server:$ckan_backup_dir/ | tail -n 1 | awk '{ print $5 }')
	if [ $? -ne 0 ]; then
		echo "get last backup name failed.";
		exit 1;
	fi
}

function get_backup {
	mkdir -p $ckan_tmp_dir
	rsync -av $ckan_backup_user@$ckan_backup_server:$ckan_backup_dir/$ckan_db_backup $ckan_tmp_dir/
	if [ $? -ne 0 ]; then
		echo "get last backup name failed.";
		exit 2;
	fi
}

function drop_db {
	# drop db
	paster db clean -c $ckan_ini_file > /dev/null
	if [ $? -ne 0 ]; then
		echo "drop database failed.";
		exit 3;
	fi
}

function recreate_db_from_backup {
	# recreate the empty db
	psql -U $ckan_sql_user $ckan_sql_db -f $ckan_tmp_dir/$ckan_db_backup > /dev/null
	if [ $? -ne 0 ]; then
		echo "create database failed.";
		exit 4;
	fi
}

# main
ckan-stop.sh;
get_last_backup_name;
get_backup;
activate;
drop_db;
recreate_db_from_backup;
deactivate;
ckan-start.sh;
ckan-reindex.sh;
rm -rf $ckan_tmp_dir;
echo "Script completed."
cd $curr_dir;
