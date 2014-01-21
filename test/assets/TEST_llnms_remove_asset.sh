#!/bin/sh
#
#   File:    llnms_remove_asset.sh
#   Author:  Marvin Smith
#   Date:    12/25/2013
#
#   Purpose:  Test the llnms-remove-asset script.
#


#  Make sure LLNMS has been installed
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi

#  Import llnms configuration
. $LLNMS_HOME/config/llnms-config

# Initialize ANSI
. test/unit_test/unit_test_utilities.sh
 

#------------------------------------------------#
#-     Helper function for creating assets      -#
#-        for testing use only.                 -#
#------------------------------------------------#
TMP_llnms_remove_asset_create_assets(){

    #  Create 3 temporary assets
    llnms-create-asset  -host 'temp-asset1' -ip4 '192.168.0.1' -d 'hello world'
    llnms-create-asset  -host 'temp-asset2' -ip4 '10.2.10.1'   -d 'sample file'
    llnms-create-asset  -host 'temp-asset3' -ip4 '172.16.0.1'  -d 'final test file'

}


#--------------------------------------------------------#
#-      Helper function for testing if certain assets   -#
#-         still exist or were deleted.                 -#
#-                                                      -#
#-      $1 - temp-asset1 state, 0 - deleted, 1 - exists -#
#-      $2 - temp-asset2 state, 0 - deleted, 1 - exists -#
#-      $3 - temp-asset3 state, 0 - deleted, 1 - exists -#
#--------------------------------------------------------#
TMP_llnms_remove_asset_test_assets(){

    #  If temp-asset1 exists
    if [ -e "$LLNMS_HOME/assets/temp-asset1.llnms-asset.xml" ]; then 
        if [ $1 = '0' ]; then
            echo "Asset 'temp-asset1' exists where it should not.  File: `basename $0`, Line: $LINENO" > /var/tmp/cause.txt
            echo '1'
            return
        fi
    #  If temp-asset1 does not exist
    else 
        if [ $1 = '1' ]; then
            echo " Asset 'temp-asset1' does not exists when it should.  File: `basename $0`, Line $LINENO" > /var/tmp/cause.txt
            echo '1'
            return
        fi
    fi
    
    #  If temp-asset2 exists
    if [ -e "$LLNMS_HOME/assets/temp-asset2.llnms-asset.xml" ]; then 
        if [ $2 = '0' ]; then
            echo "Asset 'temp-asset2' exists where it should not.  File: `basename $0`, Line: $LINENO" > /var/tmp/cause.txt
            echo '1'
            return
        fi
    #  If temp-asset2 does not exist
    else 
        if [ $2 = '1' ]; then
            echo " Asset 'temp-asset2' does not exists when it should.  File: `basename $0`, Line $LINENO" > /var/tmp/cause.txt
            echo '1'
            return
        fi
    fi
    
    #  If temp-asset3 exists
    if [ -e "$LLNMS_HOME/assets/temp-asset3.llnms-asset.xml" ]; then 
        if [ $3 = '0' ]; then
            echo "Asset 'temp-asset3' exists where it should not.  File: `basename $0`, Line: $LINENO" > /var/tmp/cause.txt
            echo '1'
            return
        fi
    #  If temp-asset3 does not exist
    else 
        if [ $3 = '1' ]; then
            echo " Asset 'temp-asset3' does not exists when it should.  File: `basename $0`, Line $LINENO" > /var/tmp/cause.txt
            echo '1'
            return
        fi
    fi

    echo "0"
}


#------------------------------------------------#
#-     TEST_llnms_remove_asset_01               -#
#-                                              -#
#-     Test the remove asset script from the    -#
#-     llnms-remove-asset script.               -#
#------------------------------------------------#
TEST_llnms_remove_asset_01(){
    
    #  Make sure removals happen regardless
    rm -r "$LLNMS_HOME/assets/*.llnms-asset.xml" 2> /dev/null
    
    #  Create temp assets
    TMP_llnms_remove_asset_create_assets
    
    #  Remove the temp-asset1 asset by hostname
    llnms-remove-asset -host 'temp-asset1'
    
    #  Test asset existence
    RESULT="`TMP_llnms_remove_asset_test_assets 0 1 1`"
    if [ "$RESULT" = '1' ]; then echo '1'; return; fi
   
    #  Remove the temp-asset3 by address
    llnms-remove-asset -ip4 '172.16.0.1'
    
    #  Test asset existence
    RESULT="`TMP_llnms_remove_asset_test_assets 0 1 0`"
    if [ "$RESULT" = '1' ]; then echo '1'; return; fi
    
    #  Make sure everything has been removed anyhow
    rm -r "$LLNMS_HOME/assets/*.llnms-asset.xml" 2> /dev/null

    #  Return with successful operation
    echo '0'

}


