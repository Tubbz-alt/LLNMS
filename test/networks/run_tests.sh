#!/bin/sh
#
#   File:    run_tests.sh
#   Author:  Marvin Smith
#   Date:    12/13/2013
#
#   Purpose:  Run unit tests for the network module
#



#-----------------------------------#
#-          Main Function          -#
#-----------------------------------#

#  Make sure LLNMS has been installed
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi

#  Import llnms configuration
. $LLNMS_HOME/config/llnms-config.sh

# Initialize ANSI
. test/unit_test/unit_test_utilities.sh




#------------------------------------------#
#-           Print our header             -#
#------------------------------------------#
print_module_header "Networking"


#------------------------------------------#
#-           Print our footer             -#
#------------------------------------------#
print_module_footer "Networking"


