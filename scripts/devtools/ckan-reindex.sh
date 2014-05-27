#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

# includes the config file to define YOUR specific parameters
# (ckan and cps location, branches etc)
. $(which devtoolconfig.sh)

function reindex {
	# drop db
	paster search-index rebuild -c $ckan_ini_file > /dev/null
}

# main
activate;
reindex;
deactivate;
echo "Done."
cd $curr_dir;

