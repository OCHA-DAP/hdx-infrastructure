#!/bin/bash

if [ $(id -u) -ne 0 ]; then
	echo "You need to be root to run me.";
	exit 1;
fi

invoke-rc.d supervisor restart > /dev/null

if [ $? -ne 0 ]; then
	echo "Command failed.";
	exit 2;
fi

echo "Success!"
