#!/bin/bash

if [ $(id -u) -ne 0 ]; then
    echo "You need to be root to run me.";
    exit 1;
fi

# includes the config file to define YOUR specific parameters
# (ckan and cps location, branches etc)
. $(which devtoolconfig.sh)

cps_db_backup="NON-EXISTENT-BACKUP"

function get_last_backup_name {
    echo -en "Getting the last backup name: "
    cps_db_backup=$(rsync -e "ssh -o PasswordAuthentication=no -o IdentitiesOnly=yes" --list-only $cps_backup_user@$cps_backup_server:$cps_backup_dir/$cps_backup_prefix* | tail -n 1 | awk '{ print $5 }')
    if [ $? -ne 0 ]; then
        echo -en "failed.\n";
        exit 1;
    fi
    echo -en "$cps_db_backup\n"
}

function get_backup {
    mkdir -p $cps_tmp_dir
    echo -en "Getting the last backup... "
    rsync -av --progress -e "ssh -o PasswordAuthentication=no -o IdentitiesOnly=yes" $cps_backup_user@$cps_backup_server:$cps_backup_dir/$cps_db_backup $cps_tmp_dir/
    if [ $? -ne 0 ]; then
        echo -en "failed. \n";
        exit 2;
    fi
}

# main
get_last_backup_name;
get_backup;

if [[ $_ != $0 ]]; then
    echo "Script completed."
    echo "The backup file is: $cps_tmp_dir/$cps_db_backup."
    echo "Please do not forget to remove the file after you got it."
    echo "Thank you."
fi
cd $curr_dir;
