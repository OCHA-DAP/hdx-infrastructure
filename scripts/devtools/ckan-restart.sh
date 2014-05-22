#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

ckan_app_name="ckan"

supervisorctl restart $ckan_app_name
