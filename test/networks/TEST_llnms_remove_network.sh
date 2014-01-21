#!/bin/sh
#
#   File:    TEST_llnms_remove_network.sh
#   Author:  Marvin Smith
#   Date:    1/20/2014
#
#   Purpose:  This contains all tests related to the llnms-remove-network script.
#


#  Make sure LLNMS has been installed
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi

#  Import llnms configuration
. $LLNMS_HOME/config/llnms-config

# Initialize ANSI
. test/unit_test/unit_test_utilities.sh


#-------------------------------------#
#-   TEST_llnms_remove_network_01    -#
#-                                   -#
#-   Test the created file output    -#
#-   from llnms-register_scanner.    -#
#-------------------------------------#
TEST_llnms_remove_network_01(){
    
    #  Create unit test log entry
    echo "" >> $LLNMS_UNIT_TEST_LOG
    echo "" >> $LLNMS_UNIT_TEST_LOG
    echo '-------------------------------------------------------------------------------' >> $LLNMS_UNIT_TEST_LOG
    echo "Starting llnms-remove-network unit test at $(date)" >> $LLNMS_UNIT_TEST_LOG
    echo '-------------------------------------------------------------------------------' >> $LLNMS_UNIT_TEST_LOG
    echo "" >> $LLNMS_UNIT_TEST_LOG


    echo '1'
    echo "Not Implemented Yet.  File: TEST_llnms_remove_network.sh, Line: $LINENO." > /var/tmp/cause.txt

}


