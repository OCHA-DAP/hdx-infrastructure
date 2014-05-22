#!/bin/bash

BASEDIR="/opt/deploy/sources"
REPODIR=$BASEDIR"/DAP-System"
SRCDIR=$REPODIR"/HDX-System"
REPOURL="https://github.com/OCHA-DAP/HDX-CKAN_Setup.git"
CURPWD=$(pwd)
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
WEBAPPDIR="/opt/www/tomcat/tomcat/webapps"

function repo_from_scratch {
    mkdir -p $BASEDIR
    cd $BASEDIR
    git clone $REPOURL
    cd $SRCDIR
}

function repo_pull {
    # cd $SRCDIR - already in here
    git pull origin master
}

function mvn_make {
    mvn clean
    mvn install -Dmaven.test.skip=true
}

function deploy_cps {
    cps-stop.sh
    backup old war file
    cp -a $WEBAPPDIR/hdx.war $BASEDIR/hdx.$TIMESTAMP.war
    if [ -d $WEBAPPDIR/hdx ]; then
        rm -rf $WEBAPPDIR/hdx
    fi
    if [ -f $WEBAPPDIR/hdx.war ]; then
        rm -f $WEBAPPDIR/hdx.war
    fi
    cp -a $SRCDIR/target/hdx.war $WEBAPPDIR/
    cps-start.sh
}

cd $SRCDIR > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "source tree does not exist... creating";
    repo_from_scratch;
else
    echo "found source folder... attempting pull"
    repo_pull
fi

STARTTIME=$(date +%H:%M:%S)
echo "start compiling in 5 seconds..."
sleep 5

mvn_make

echo "start deploying in 5 seconds..."
sleep 5

deploy_cps

cd  $CURPWD
ENDTIME=$(date +%H:%M:%S)
echo -en "\nstarted at:\t"$STARTTIME
echo -en "\nfinished at:\t"$ENDTIME"\n\n"
echo "done.:P"
