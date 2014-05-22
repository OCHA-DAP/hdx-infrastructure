#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

ckan_base_dir="/opt/ckan"
ini_file="/etc/ckan/prod.ini"
curr_dir=$(pwd)

function activate {
	cd $ckan_base_dir
	. bin/activate
	cd src/ckan
}

function reindex {
	# drop db
	paster search-index rebuild -c $ini_file > /dev/null
}

# main
activate;
reindex;
echo "Done."
cd $curr_dir;

