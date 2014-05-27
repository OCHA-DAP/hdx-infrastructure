#!/bin/bash

# includes the config file to define YOUR specific parameters
# (ckan and cps location, branches etc)
. $(which devtoolconfig.sh)

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
    cp -a $webapp_dir/hdx.war $BASEDIR/hdx.$TIMESTAMP.war
    if [ -d $webapp_dir/hdx ]; then
        rm -rf $webapp_dir/hdx
    fi
    if [ -f $webapp_dir/hdx.war ]; then
        rm -f $webapp_dir/hdx.war
    fi
    cp -a $SRCDIR/target/hdx.war $webapp_dir/
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

cd  $curr_dir
ENDTIME=$(date +%H:%M:%S)
echo -en "\nstarted at:\t"$STARTTIME
echo -en "\nfinished at:\t"$ENDTIME"\n\n"
echo "done.:P"
