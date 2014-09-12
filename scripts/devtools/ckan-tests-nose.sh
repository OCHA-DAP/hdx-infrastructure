#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

# includes the config file to define YOUR specific parameters
# (ckan and cps location, branches etc)
. $(which devtoolconfig.sh)

function clean_test_dbs {
        sudo -u postgres dropdb ckan_test
        sudo -u postgres dropdb datastore_test
        sudo -u postgres createdb  -O ckantestuser ckan_test -E utf-8
        sudo -u postgres createdb  -O ckantestuser datastore_test -E utf-8
        paster datastore set-permissions postgres -c /opt/ckan/hdx-ckan/hdx-test-core.ini 
}

function run_tests {
    enabled_tests="hdx_theme hdx_org_group hdx_package" # hdx_users"
    for plugin in $enabled_tests; do
           nosetests -ckan --with-xunit --xunit-file=ckanext-$plugin/ckanext/$plugin/tests/nose_results.xml --nologcapture \
                --with-pylons=ckanext-$plugin/test.ini.sample ckanext-$plugin/ckanext/$plugin/tests
    done
    #nosetests -ckan --with-xunit --xunit-file=ckanext-hdx_theme/ckanext/hdx_theme/tests/nose_results.xml --nologcapture   --with-pylons=ckanext-hdx_theme/test.ini.sample ckanext-hdx_theme/ckanext/hdx_theme
    #nosetests -ckan --with-xunit --xunit-file=ckanext-hdx_org_group/ckanext/hdx_org_group/tests/nose_results.xml --nologcapture   --with-pylons=ckanext-hdx_org_group/test.ini.sample ckanext-hdx_org_group/ckanext/hdx_org_group
    #nosetests -ckan --with-xunit --xunit-file=ckanext-hdx_package/ckanext/hdx_package/tests/nose_results.xml --nologcapture   --with-pylons=ckanext-hdx_package/test.ini.sample ckanext-hdx_package/ckanext/hdx_package
}

activate;
echo "Recreating test databases..."
clean_test_dbs;
echo "Running tests..."
run_tests;
deactivate;

if [ $? -ne 0 ]; then
	echo "Command failed.";
	exit 3;
fi

echo "Success!";
cd $curr_dir;
