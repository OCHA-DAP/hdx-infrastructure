#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

echo "Do you wish to clean ckan db? All data in ckan db will be REMOVED permanently!"
select yn in "Yes" "No"; do
    case $yn in
        [Yy]* ) echo "Ok. Moving on..."; break;;
        [Nn]* ) echo "Ok. Exiting..."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# includes the config file to define YOUR specific parameters
# (ckan and cps location, branches etc)
. $(which devtoolconfig.sh)

function drop_db {
	# drop db
	paster db clean -c $ckan_ini_file > /dev/null
	if [ $? -ne 0 ]; then
		echo "drop database failed.";
		exit 2;
	fi
}

function recreate_db {
	# recreate the empty db
	paster db init -c $ckan_ini_file > /dev/null
	if [ $? -ne 0 ]; then
		echo "create database failed.";
		exit 3;
	fi
}

# main
ckan-stop.sh;
activate;
drop_db;
recreate_db;
deactivate;
ckan-start.sh;
ckan-reindex.sh;
echo "Script completed."
cd $curr_dir;
