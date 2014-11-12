#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

# includes the config file to define YOUR specific parameters
# (ckan and cps location, branches etc)
. $(which devtoolconfig.sh)

. $(which ckan-db-datastore-get-snapshot.sh)

function drop_db {
	echo -en "Droping all tables from $ckan_sql_db... "
	# drop db
	sudo -u postgres dropdb $ckan_sql_db_datastore > /dev/null
	if [ $? -ne 0 ]; then
		echo -en "failed.\n";
		exit 3;
	fi
}

function recreate_db_from_backup {
	# recreate the empty db
	echo "Restoring db from the prod backup. Only errors will be shown."
	sudo -u postgres createdb -O $ckan_sql_user $ckan_sql_db_datastore -E utf-8
	gunzip $ckan_tmp_dir/$ckan_db_backup
	ckan_db_backup=$(echo $ckan_db_backup | sed -e 's/\.gz$//')
	psql -U $ckan_sql_user $ckan_sql_db_datastore -f $ckan_tmp_dir/$ckan_db_backup > /dev/null
	if [ $? -ne 0 ]; then
		echo "create datastore database failed.";
		exit 4;
	fi
}

# main
# get_last_backup_name;
# get_backup; # from 
ckan-stop.sh;
activate;
drop_db;
recreate_db_from_backup;
deactivate;
ckan-start.sh;
ckan-reindex.sh;
rm -rf $ckan_tmp_dir;
echo "Script completed."
cd $curr_dir;
