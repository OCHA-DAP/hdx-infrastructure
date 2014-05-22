#!/bin/bash

BASEDIR="/opt/ckan"
SRCDIR=$BASEDIR"/src/ckan"
BRANCH="prod"
CURPWD=$(pwd)

ckan-stop.sh
cd $SRCDIR
git pull origin $BRANCH
ckan-start.sh

echo "done.:P"
