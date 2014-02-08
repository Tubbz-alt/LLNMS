#!/bin/sh
#
#   File:    TEST_llnms_list_networks.sh
#   Author:  Marvin Smith
#   Date:    1/20/2014
#
#   Purpose:  This contains all tests related to the llnms-list-networks script.
#


#  Make sure LLNMS has been installed
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi

#  Import llnms configuration
. $LLNMS_HOME/config/llnms-config

# Initialize ANSI
. test/bash/unit_test/unit_test_utilities.sh


#-------------------------------------#
#-   TEST_llnms_list_networks_01     -#
#-                                   -#
#-   Test the created file output    -#
#-   from llnms-list-networks.       -#
#-------------------------------------#
TEST_llnms_list_networks_01(){
    
    #  Create unit test log entry
    echo "" >> $LLNMS_UNIT_TEST_LOG
    echo "" >> $LLNMS_UNIT_TEST_LOG
    echo '-------------------------------------------------------------------------------' >> $LLNMS_UNIT_TEST_LOG
    echo "Starting llnms-list-networks unit test at $(date)" >> $LLNMS_UNIT_TEST_LOG
    echo '-------------------------------------------------------------------------------' >> $LLNMS_UNIT_TEST_LOG
    echo "" >> $LLNMS_UNIT_TEST_LOG

    
    #  Remove all existing network files
    echo '  -> Removing existing networks.' >> $LLNMS_UNIT_TEST_LOG
    rm -rf $LLNMS_HOME/networks/*.llnms-network.xml 2> /dev/null


    #  Create a few demo network files
    echo '  -> Building the first network file' >> $LLNMS_UNIT_TEST_LOG
    llnms-create-network -n "Google DNS" -as '8.8.8.8' -ae '8.8.8.8'

    
    #  Create the second demo network file
    echo '  -> Building the second network file' >> $LLNMS_UNIT_TEST_LOG
    llnms-create-network -n "Home Network" -as '192.168.0.1' -ae '192.168.0.254'
    
    #  Running LLNMS List Networks
    echo '  -> Running llnms-list-networks'
    NETWORK_LIST="`llnms-list-networks`"
    for NETWORK in $NETWORK_LIST; do
        case $NETWORK in
            
            #  Throw an error as there is a failure
            *)
                echo "Network file exists which shouldn't. File: TEST_llnms_list_networks.sh, Line: $LINENO" >> /var/tmp/cause.txt
                return 1
                ;;
        esac
    done

    echo '1'
    echo "Not Implemented Yet.  File: TEST_llnms_list_networks.sh, Line: $LINENO." > /var/tmp/cause.txt

}


