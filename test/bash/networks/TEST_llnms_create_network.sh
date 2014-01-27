#!/bin/sh
#
#   File:    TEST_llnms_create_network.sh
#   Author:  Marvin Smith
#   Date:    12/30/2013
#
#   Purpose:  This contains all tests related to the llnms-create-network script.
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
#-   TEST_llnms_create_network_01    -#
#-                                   -#
#-   Test the created file output    -#
#-   from llnms-create-network.      -#
#-------------------------------------#
TEST_llnms_create_network_01(){
    
    #  Create unit test log entry
    echo "" >> $LLNMS_UNIT_TEST_LOG
    echo "" >> $LLNMS_UNIT_TEST_LOG
    echo '-------------------------------------------------------------------------------' >> $LLNMS_UNIT_TEST_LOG
    echo "Starting llnms-create-network unit test at $(date)" >> $LLNMS_UNIT_TEST_LOG
    echo '-------------------------------------------------------------------------------' >> $LLNMS_UNIT_TEST_LOG
    echo "" >> $LLNMS_UNIT_TEST_LOG

    #  Delete all existing networks
    echo "-> Purging all existing llnms networks." >> $LLNMS_UNIT_TEST_LOG
    rm $LLNMS_HOME/networks/*.llnms-network.xml 2> /dev/null

    #  Network files
    NETWORK1="$LLNMS_HOME/networks/home-network.llnms-network.xml"
    NETWORK2="$LLNMS_HOME/networks/google-dns.llnms-network.xml"
    echo "-> Defining Network Files" >> $LLNMS_UNIT_TEST_LOG
    echo "   -> NETWORK1=$NETWORK1" >> $LLNMS_UNIT_TEST_LOG
    echo "   -> NETWORK2=$NETWORK1" >> $LLNMS_UNIT_TEST_LOG

    #  Create range network
    echo "" >> $LLNMS_UNIT_TEST_LOG
    echo "-> Creating first RANGE network" >> $LLNMS_UNIT_TEST_LOG
    echo "   llnms-create-network -n \"HOME NETWORK\" -net \"RANGE:192.168.0.1:192.168.0.254\" -o $LLNMS_HOME/networks/home-network.llnms-network.xml" >> $LLNMS_UNIT_TEST_LOG
    llnms-create-network -n "HOME NETWORK" -net "RANGE:192.168.0.1:192.168.0.254" -o $NETWORK1 >> $LLNMS_UNIT_TEST_LOG
    echo "" >> $LLNMS_UNIT_TEST_LOG

    #  Make sure the network exists
    if [ ! -e $NETWORK1 ]; then
        echo '1'
        echo "error: llnms-create-network did not successfully create network file at ${NETWORK1}.  File: TEST_llnms_create_network.sh, Line: $LINENO" > /var/tmp/cause.txt
        return
    fi
    
    #  Create single network
    echo "" >> $LLNMS_UNIT_TEST_LOG
    echo "-> Create first SINGLE network" >> $LLNMS_UNIT_TEST_LOG
    echo "   llnms-create-network -n \"Google DNS\" -net \"SINGLE:8.8.8.8\" -o $NETWORK2" >> $LLNMS_UNIT_TEST_LOG
    llnms-create-network -n "Google DNS" -net "SINGLE:8.8.8.8" -o $NETWORK2 >> $LLNMS_UNIT_TEST_LOG
    echo "" >> $LLNMS_UNIT_TEST_LOG

    #  Make sure the network exists
    if [ ! -e $NETWORK2 ]; then
        echo '1'
        echo "error: llnms-create-network did not successfully create the network file at ${NETWORK2}. File: TEST_llnms_create_network.sh, Line: $LINENO" > /var/tmp/cause.txt
        return
    fi

    echo '0'
}


