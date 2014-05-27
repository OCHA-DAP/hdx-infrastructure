#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

ckan_base_dir="/opt/ckan"
ini_file="/etc/ckan/prod.ini"
curr_dir=$(pwd)

username=""
password=""
email=""

function activate {
	cd $ckan_base_dir
	. bin/activate
	cd src/ckan
}

function run_tests {
	nosetests -ckan --no-skip --nologcapture   --with-pylons=ckanext-hdx_theme/test.ini.sample ckanext-hdx_theme/ckanext/hdx_theme/tests/ui
	nosetests -ckan --no-skip --nologcapture --with-pylons=ckanext-metadata_fields/test.ini.sample ckanext-metadata_fields/ckanext/metadata_fields
}

ckan-simple-deploy.sh
activate;
run_tests;

if [ $? -ne 0 ]; then
	echo "Command failed.";
	exit 3;
fi

echo "Success!";
cd $curr_dir;
