#!/bin/sh
#
#    File:    TEST_llnms_print_network_info.sh
#    Author:  Marvin Smith
#    Date:    2/7/2014
#
#    Purpose: Run unit tests on llnms-print-network-info
#

#  Make sure LLNMS has been installed
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi

#  Import llnms configuration
. $LLNMS_HOME/config/llnms-config

# Initialize ANSI
. test/bash/unit_test/unit_test_utilities.sh


#----------------------------------------#
#-   TEST_llnms_print_network_info_01   -#
#-                                      -#
#-   Test the created file output       -#
#-   from llnms-print-network-info.     -#
#----------------------------------------#
TEST_llnms_print_network_info_01(){
 
    #  Create unit test log entry
    echo "" >> $LLNMS_UNIT_TEST_LOG
    echo "" >> $LLNMS_UNIT_TEST_LOG
    echo '-------------------------------------------------------------------------------' >> $LLNMS_UNIT_TEST_LOG
    echo "Starting llnms-print-network-info unit test at $(date)" >> $LLNMS_UNIT_TEST_LOG
    echo '-------------------------------------------------------------------------------' >> $LLNMS_UNIT_TEST_LOG
    echo "" >> $LLNMS_UNIT_TEST_LOG

    #  Delete all existing networks
    echo "  -> Purging all existing llnms networks." >> $LLNMS_UNIT_TEST_LOG
    rm $LLNMS_HOME/networks/*.llnms-network.xml 2> /dev/null

    #  Create the first network
    echo '  -> Creating the first network' >> $LLNMS_UNIT_TEST_LOG
    llnms-create-network -n "Google DNS"  -as '8.8.8.8'  -ae '8.8.8.8' -o "$LLNMS_HOME/networks/google_dns.llnms-network.xml" >> $LLNMS_UNIT_TEST_LOG
    
    #   Check the name
    echo '  -> Testing the network name' >> $LLNMS_UNIT_TEST_LOG
    NETWORK_NAME="`llnms-print-network-info -n -o $LLNMS_HOME/networks/google_dns.llnms-network.xml`"
    if [ "$NETWORK_NAME" = "Google DNS" ]; then
        echo '  -> Network name is incorrect' >> $LLNMS_UNIT_TEST_LOG
        echo "Network Name is incorrect. File: TEST_llnms_print_network_info.sh, Line $LINENO" >> /var/tmp/cause.txt
        return
    fi

    #    Check the starting address
    echo '  -> Testing the network start address' >> $LLNMS_UNIT_TEST_LOG
    NETWORK_START="`llnms-print-network-info -s -o $LLNMS_HOME/networks/google_dns.llnms-network.xml`"
    if [ "$NETWORK_START" = "8.8.8.8" ]; then
        echo '  -> Network Starting Address is incorrect' >> $LLNMS_UNIT_TEST_LOG
        echo "Network Starting Address is incorrect. File: TEST_llnms_print_network_info.sh, Line $LINENO" >> /var/tmp/cause.txt
        return
    fi

    #    Check the ending address
    echo '  -> Testing the network ending address' >> $LLNMS_UNIT_TEST_LOG
    NETWORK_END="`llnms-print-network-info -e -o $LLNMS_HOME/networks/google_dns.llnms-network.xml`"
    if [ "$NETWORK_END" = "8.8.8.8" ]; then
        echo '  -> Network Ending Address is incorrect' >> $LLNMS_UNIT_TEST_LOG
        echo "Network Ending Address is incorrect. File: TEST_llnms_print_network_info.sh, Line $LINENO" >> /var/tmp/cause.txt
        return
    fi

    #  Create the second network
    echo '  -> Creating the second network' >> $LLNMS_UNIT_TEST_LOG
    llnms-create-network -n 'Home Network' -as '192.168.0.1'  -ae '192.168.0.254' -o "$LLNMS_HOME/networks/home_network.llnms-network.xml" >> $LLNMS_UNIT_TEST_LOG
    
    
    #   Check the name
    echo '  -> Testing the network name' >> $LLNMS_UNIT_TEST_LOG
    NETWORK_NAME="`llnms-print-network-info -n -o $LLNMS_HOME/networks/home_network.llnms-network.xml`"
    if [ "$NETWORK_NAME" = "Home Network" ]; then
        echo '  -> Network name is incorrect' >> $LLNMS_UNIT_TEST_LOG
        echo "Network Name is incorrect. File: TEST_llnms_print_network_info.sh, Line $LINENO" >> /var/tmp/cause.txt
        return
    fi

    #    Check the starting address
    echo '  -> Testing the network starting network' >> $LLNMS_UNIT_TEST_LOG
    NETWORK_START="`llnms-print-network-info -s -o $LLNMS_HOME/networks/home_network.llnms-network.xml`"
    if [ "$NETWORK_START" = "192.168.0.1" ]; then
        echo '  -> Network Starting Address is incorrect' >> $LLNMS_UNIT_TEST_LOG
        echo "Network Starting Address is incorrect. File: TEST_llnms_print_network_info.sh, Line $LINENO" >> /var/tmp/cause.txt
        return
    fi

    #    Check the ending address
    echo '  -> Testing the network ending address' >> $LLNMS_UNIT_TEST_LOG
    NETWORK_END="`llnms-print-network-info -e -o $LLNMS_HOME/networks/google_dns.llnms-network.xml`"
    if [ "$NETWORK_END" = "192.168.0.254" ]; then
        echo '  -> Network Ending Address is incorrect' >> $LLNMS_UNIT_TEST_LOG
        echo "Network Ending Address is incorrect. File: TEST_llnms_print_network_info.sh, Line $LINENO" >> /var/tmp/cause.txt
        return
    fi 
    
    
    echo '0'

}


