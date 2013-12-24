#!/bin/bash


. test/unit_test/initializeANSI.sh


#  Make sure LLNMS has been installed
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi
. $LLNMS_HOME/config/llnms-config.sh

# $1 - Function
# $2 - Purpose
# $3 - Result
print_test_result(){

    if [ $3 -ne 0 ]; then
        if [ ! -e /var/tmp/cause.txt ]; then
            touch /var/tmp/cause.txt
        fi
    fi

    if [ $3 -eq 0 ]; then
        $ECHO "${greenf}| passed |${bluef} $1 - $2 ${reset}"
    else
        $ECHO "${redf}| failed |${bluef} $1 - $2 ${reset} - Cause: $(cat /var/tmp/cause.txt)"
    fi


}
