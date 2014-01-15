#!/bin/sh
#
#   File:    TEST_llnms_create_asset.sh
#   Author:  Marvin Smith
#   Date:    12/25/2013
#
#   Purpose:  This contains all tests related to the llnms-create-asset script.
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
#-   TEST_llnms_create_asset_01      -#
#-                                   -#
#-   Test the created file output    -#
#-   from llnms-create-asset         -#
#-------------------------------------#
TEST_llnms_create_asset_01(){
    
    #  Remove all existing assets
    rm -r $LLNMS_HOME/assets/*.llnms-asset.xml 2> /dev/null

    #  Create an asset using the create asset command
    llnms-create-asset.sh  -host 'temp-asset' -ip4 '192.168.0.1' -d 'hello world'

    #  make sure the file was properly created
    if [ ! -e '/var/tmp/llnms/assets/temp-asset.llnms-asset.xml' ]; then
        $ECHO "temp-asset.llnms-asset.xml does not exist after creation.  Line: $LINENO, File: $0." > /var/tmp/cause.txt
        echo "1"
        return
    fi
    
    #  make sure that the file validates properly
    xmlstarlet val -q '/var/tmp/llnms/assets/temp-asset.llnms-asset.xml'
    if [ $? -ne 0 ]; then
        $ECHO "temp-asset.llnms-asset.xml does not validate as proper xml.  Line: $LINENO, File: $0." > /var/tmp/cause.txt
        echo '1'
        return
    fi

    #  check the name
    if [ ! "$(xmlstarlet sel -t -m '//llnms-asset' -v 'hostname' -n '/var/tmp/llnms/assets/temp-asset.llnms-asset.xml')" = 'temp-asset' ]; then
        echo '1'
        $ECHO "hostname is not equal to temp-asset, at Line $LINENO, File: $0." > /var/tmp/cause.txt
        return
    fi

    #  check the ip address
    if [ ! "$(xmlstarlet sel -t -m '//llnms-asset' -v 'ip4-address' -n '/var/tmp/llnms/assets/temp-asset.llnms-asset.xml')" = '192.168.0.1' ]; then
        echo "ip4-address is not equal to 192.168.0.1, at Line $LINENO, File: $0." > /var/tmp/cause.txt
        echo '1'
        return 
    fi

    #  Delete the file
    if [ -e "/var/tmp/llnms/assets/temp-asset.llnms-asset.xml" ]; then
        rm '/var/tmp/llnms/assets/temp-asset.llnms-asset.xml'
    else    
        echo "Temporary asset does not exist. Line: $LINENO, File: $0." > /var/tmp/cause.txt
        echo '1'
        return
    fi

    echo '0'
}


