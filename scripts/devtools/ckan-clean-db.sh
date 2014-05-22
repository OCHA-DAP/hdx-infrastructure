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


ckan_base_dir="/opt/ckan"
ini_file="/etc/ckan/prod.ini"
curr_dir=$(pwd)

function activate {
	cd $ckan_base_dir
	. bin/activate
	cd src/ckan
}

function drop_db {
	# drop db
	paster db clean -c $ini_file > /dev/null
	if [ $? -ne 0 ]; then
		echo "drop database failed.";
		exit 2;
	fi
}

function recreate_db {
	# recreate the empty db
	paster db init -c $ini_file > /dev/null
	if [ $? -ne 0 ]; then
		echo "create database failed.";
		exit 3;
	fi
}

# main
activate;
drop_db
recreate_db
echo "Script completed. Make sure you start ckan now (you did stoppped it before running this script, didn't you?)"
cd $curr_dir;

