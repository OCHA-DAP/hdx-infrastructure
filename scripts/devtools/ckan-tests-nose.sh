#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

# includes the config file to define YOUR specific parameters
# (ckan and cps location, branches etc)
. $(which devtoolconfig.sh)

function run_tests {
	nosetests -ckan --with-xunit --xunit-file=ckanext-metadata_fields/ckanext/metadata_fields/tests/nose_results.xml --nologcapture --with-pylons=ckanext-metadata_fields/test.ini.sample ckanext-metadata_fields/ckanext/metadata_fields
	nosetests -ckan --with-xunit --xunit-file=ckanext-hdx_theme/ckanext/hdx_theme/tests/nose_results.xml --nologcapture   --with-pylons=ckanext-hdx_theme/test.ini.sample ckanext-hdx_theme/ckanext/hdx_theme
}

activate;
run_tests;
deactivate;

if [ $? -ne 0 ]; then
	echo "Command failed.";
	exit 3;
fi

echo "Success!";
cd $curr_dir;
