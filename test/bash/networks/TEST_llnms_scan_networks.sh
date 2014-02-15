#!/bin/sh
#
#    File:    TEST_llnms_scan_networks.sh
#    Author:  Marvin Smith
#    Date:    2/7/2014
#
#    Purpose:  Perform unit tests on the LLNMS Scan Networks module
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
#-   TEST_llnms_scan_networks_01        -#
#-                                      -#
#-   Test the created file output       -#
#-   from llnms-scan-networks.          -#
#----------------------------------------#
TEST_llnms_scan_networks_01(){
 
    echo '1'
    echo 'Not Implemented Yet' > /var/tmp/cause.txt


}


