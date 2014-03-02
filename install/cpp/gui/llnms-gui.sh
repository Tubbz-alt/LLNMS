#!/bin/sh
#    File:    llnms-gui.sh
#    Author:  Marvin Smith
#    Date:    3/1/2014
#
#    Purpose: Start script for the LLNMS GUI
#

#  Find out where the executable is
BASE_PATH=`dirname $0`

#  Go to the directory
cd ${BASE_PATH}

./bin/llnms-gui.out $@

