#!/bin/sh


#  Find out where the executable is
BASE_PATH=`dirname $0`

#  Set the LLNMS Home
export LLNMS_ICON_HOME="$BASE_PATH/icons"


#  Go to the directory
cd ${BASE_PATH}

pwd
./bin/LLNMS-Viewer.out $@

