#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

echo "Do you wish to clean cps db? All data in cps db will be REMOVED permanently!"
select yn in "Yes" "No"; do
    case $yn in
        [Yy]* ) echo "Ok. Moving on..."; break;;
        [Nn]* ) echo "Ok. Exiting..."; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

cps_db="hdx"
cps_user="hdxuser"
tmp_dir="/var/tmp/cps-clean-db"
curr_dir=$(pwd)


function drop_db {
	# drop db
	sudo -u postgres dropdb $hdx > /dev/null
	if [ $? -ne 0 ]; then
		echo "drop database failed.";
		exit 2;
	fi
}


function recreate_db {
	# recreate the empty db
	sudo -u postgres createdb -O ckan_default ckan_default -E utf-8
	if [ $? -ne 0 ]; then
		echo "create empty database failed.";
		exit 3;
	fi
}

function clone_repo {
	# clone DAP-System repo
	mkdir -p $tmp_dir
	git clone -q https://github.com/OCHA-DAP/DAP-System.git $tmp_dir

	if [ $? -ne 0 ]; then
		echo "git clone failed.";
		exit 4;
	fi
	cp -a $tmp_dir/DAP-System/HDX-System/resources/db $tmp_dir/
	rm -rf $tmp_dir/DAP-System
}

function make_db_layout {
	res_dir=$tmp_dir/db
	cd $tmp_dir/
	# will run inserts manually. looping through file names in bash is dangerous :)
	for file in 2_schema.ddl 2a_views.sql 3_countries.sql 5_configs.sql 6_metadata.sql; do
		psql -U $cps_user -d $cps_db -f $res_dir/$file > /dev/null
		if [ $? -ne 0 ]; then
			echo "File " . $file . " insertion failed. Exiting.";
			exit 5;
		fi
	done
}

# main
drop_db
recreate_db
clone_repo
make_db_layout
echo "Script completed. Make sure you start cps now (you did stoppped it before running this script, didn't you?"

