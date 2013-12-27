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
    if [ ! -e "$LLNMS_HOME/config/llnms-config.sh" ]; then
        echo "error:  The LLNMS configuration file does not exist at $LLNMS_HOME/config/llnms-config.sh"
        exit 1
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


#  Import LLNMS-specific options
. $LLNMS_HOME/config/llnms-config.sh

#  run asset unit tests
./test/assets/run_tests.sh

$ECHO ''

#  run networking unit tests
./test/networks/run_tests.sh

$ECHO ''

#  run scanning unit tests
./test/scanning/run_tests.sh


