#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

# includes the config file to define YOUR specific parameters
# (ckan and cps location, branches etc)
. $(which devtoolconfig.sh)

function run_tests {
	nosetests -ckan --no-skip --nologcapture --with-pylons=ckanext-hdx_theme/test.ini.sample ckanext-hdx_theme/ckanext/hdx_theme/tests/ui
	nosetests -ckan --no-skip --nologcapture --with-pylons=ckanext-metadata_fields/test.ini.sample ckanext-metadata_fields/ckanext/metadata_fields
}

ckan-deploy-simple.sh
activate;
run_tests;
deactivate;

if [ $? -ne 0 ]; then
	echo "Command failed.";
	exit 3;
fi

echo "Success!";
cd $curr_dir;
