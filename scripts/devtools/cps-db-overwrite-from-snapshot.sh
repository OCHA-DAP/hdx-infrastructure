#!/bin/bash

if [ $(id -u) -ne 0 ]; then
        echo "You need to be root to run me.";
        exit 1;
fi

# includes the config file to define YOUR specific parameters
# (ckan and cps location, branches etc)
. $(which devtoolconfig.sh)

. $(which cps-db-get-snapshot.sh)

function drop_db {
        echo -en "Droping db $cps_sql_db... "
        # drop db
        sudo -u postgres dropdb $cps_sql_db > /dev/null
        # create an empty one
        sudo -u postgres createdb -O $cps_sql_user $cps_sql_db -E utf-8 > /dev/null
        if [ $? -ne 0 ]; then
                echo -en "failed.\n";
                exit 3;
        fi
}

function recreate_db_from_backup {
        # recreate the empty db
        echo "Decompressing archive file..."
        gunzip -f $cps_tmp_dir/$cps_db_backup > /dev/null
        echo "Restoring db from the prod backup. Only errors will be shown."
        uncompressed_file=$(echo $cps_db_backup | sed -e 's/.gz$//')
        psql -U $cps_sql_user $cps_sql_db -f $cps_tmp_dir/$uncompressed_file > /dev/null
        if [ $? -ne 0 ]; then
                echo "create database failed.";
                exit 4;
        fi
}

# main
# get_last_backup_name;
# get_backup; # from 
cps-stop.sh;
activate;
drop_db;
recreate_db_from_backup;
deactivate;
cps-start.sh;
rm -rf $cps_tmp_dir;
echo "Script completed."
cd $curr_dir;
