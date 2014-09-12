#!/bin/bash

cd /opt/drills/cacheUpdate
. get_resources_list.sh
./staticStoreUpdate.py cps_resources /opt/www/static/cps/hdx/api/exporter/ force
