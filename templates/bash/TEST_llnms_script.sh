#!/bin/sh
#
#   File:    TEST_llnms_register_scanner.sh
#   Author:  Marvin Smith
#   Date:    12/25/2013
#
#   Purpose:  This contains all tests related to the llnms-register-scanner script.
#


#  Make sure LLNMS has been installed
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi

#  Import llnms configuration
. $LLNMS_HOME/config/llnms-config.sh

# Initialize ANSI
. test/unit_test/unit_test_utilities.sh


#-------------------------------------#
#-   TEST_llnms_register_scanner_01  -#
#-                                   -#
#-   Test the created file output    -#
#-   from llnms-register_scanner.    -#
#-------------------------------------#
TEST_llnms_register_scanner_01(){

    echo '1'
    echo "Not Implemented Yet.  File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt
}


