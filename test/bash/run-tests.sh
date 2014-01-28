#!/bin/sh
#
#  File:    run-tests.sh
#  Author:  Marvin Smith
#  Date:    12/13/2013
#
#  Purpose:  This is the primary interface for running unit tests.
#

#--------------------------------------------#
#-    Make sure LLNMS has been installed    -#
#--------------------------------------------#
check_installation(){

    #  Make sure the config file exists
    if [ ! -e "$LLNMS_HOME/config/llnms-config" ]; then
        echo "error:  The LLNMS configuration file does not exist at $LLNMS_HOME/config/llnms-config"
        exit 1
    fi
    
    #  Set the unit test log variable
    export LLNMS_UNIT_TEST_LOG="$LLNMS_HOME/log/llnms_unit_test.log"
    if [ -e "$LLNMS_UNIT_TEST_LOG" ]; then
        rm $LLNMS_UNIT_TEST_LOG
    fi
}


#-------------------------------#
#-        Main Function        -#
#-------------------------------#
#  Make sure LLNMS has been installed
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi

check_installation

if [ -e "/var/tmp/llnms-halt.txt" ]; then
    rm /var/tmp/llnms-halt.txt
fi


#  Import LLNMS-specific options
. $LLNMS_HOME/config/llnms-config

#  run asset unit tests
./test/assets/run_tests.sh
if [ -e "/var/tmp/llnms-halt.txt" ]; then
    echo 'llnms unit tests halted.'
    exit 1
fi
$ECHO ''

#  run networking unit tests
./test/networks/run_tests.sh
if [ -e "/var/tmp/llnms-halt.txt" ]; then
    echo 'llnms unit tests halted.'
    exit 1
fi

$ECHO ''

#  run scanning unit tests
./test/scanning/run_tests.sh
if [ -e "/var/tmp/llnms-halt.txt" ]; then
    echo 'llnms unit tests halted.'
    exit 1
fi


