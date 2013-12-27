#!/bin/sh
#
#   File:    llnms-scan-asset.sh
#   Author:  Marvin Smith
#   Date:    12/13/2013
#
#   Purpose: Runs the scanners on the specified asset.
#

#----------------------------------------#
#-       Print Usage Instructions       -#
#----------------------------------------#
usage(){

    echo "`basename $0` [options]"
    echo ''
    echo '    options:'
    echo '        -h, --help    :  Print usage instructions'
    echo '        -v, --version :  Print version information'
    echo ''
    echo '        -a, --asset [asset hostname] : Asset to run with'
    echo ''
}


#-------------------------------------#
#-         Warning Function          -#
#-                                   -#
#-   $1 -  Error Message             -#
#-   $2 -  Line Number (Optional).   -#
#-   $3 -  File Name (Optional).     -$
#-------------------------------------#
warning(){

    #  If the user only gives the warning message
    if [ $# -eq 1 ]; then
        echo "warning: $1."

    #  If the user only gives the line number
    elif [ $# -eq 2 ]; then
        echo "warning: $1.  Line: $2,  File: `basename $0`"

    #  If the user gives the line number and file
    else
        echo "warning: $1.  Line: $2, File: $3"
    fi
}

#-------------------------------------#
#-            Error Function         -#
#-                                   -#
#-   $1 -  Error Message             -#
#-   $2 -  Line Number (Optional).   -#
#-   $3 -  File Name (Optional).     -$
#-------------------------------------#
error(){

    #  If the user only gives the error message
    if [ $# -eq 1 ]; then
        echo "error: $1."

    #  If the user only gives the line number
    elif [ $# -eq 2 ]; then
        echo "error: $1.  Line: $2,  File: `basename $0`"

    #  If the user gives the line number and file
    else
        echo "error: $1.  Line: $2, File: $3"
    fi
}



#-------------------------------------#
#           Version Function          #
#-------------------------------------#
version(){

    echo "$0 Information"
    echo ''
    echo "   LLNMS Version ${LLNMS_MAJOR}.${LLNMS_MINOR}.${LLNMS_SUBMINOR}"

}


#---------------------------------#
#-         Main Function         -#
#---------------------------------#

#  Source llnms home
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi


#  Import the version info
. $LLNMS_HOME/config/llnms-info.sh

#  Import asset utilities
. $LLNMS_HOME/config/llnms-config.sh


#  Asset name and path
ASSET_HOSTNAME=''
ASSET_PATH=''
ASSET_FLAG=0


#   Parse Command-Line Options
for OPTION in "$@"; do

    case $OPTION in

        #  Print usage instructions
        '-h' | '--help' )
            usage
            exit 1
            ;;


        #  Print version information
        '-v' | '--version' )
            version
            exit 1
            ;;
        
        #  Set the asset flag
        '-a' | '--asset' )
            ASSET_FLAG=1
            ;;

        #  Process flag values or print error message
        *)
            
            #  Grab the asset hostname
            if [ $ASSET_FLAG -eq 1 ]; then
                ASSET_FLAG=0
                ASSET_HOSTNAME=$OPTION

            # otherwise, throw the error for an unknown option
            else
                error "Unknown option $OPTION" "$LINENO"
                usage
                exit 1
            fi
            ;;


    esac
done


#-------------------------------------#
#-    Make sure the asset exists     -#
#-------------------------------------#
# get a list of assets
ASSET_LIST=$(ls $LLNMS_HOME/assets/*.llnms-asset.xml 2> /dev/null)
for ASSET_FILE in $ASSET_LIST; do
    
    #  check the hostname.  if they match, then retrieve the asset filename
    if [ "$(llnms_get_asset_hostname $ASSET_FILE)" = "$ASSET_HOSTNAME" ]; then
        ASSET_PATH=$ASSET_FILE
    fi

done


#   - get a list of registered scanners
ASSET_SCANNERS=$(llnms_list_asset_registered_scanners $ASSET_PATH)
for ASSET_SCANNER in $ASSET_SCANNERS; do

    #  get the file pathname for the scanner
    SCANNER_PATH=$(llnms_get_scanner_path_from_id $ASSET_SCANNER)

    #  get the command to run for the scanner
    SCANNER_CMD=$(llnms_print_registered_scanner_command $SCANNER_PATH)

    #  get the argument-list for the scanner
    
    echo "SCANNER_CMD: $SCANNER_CMD"

done

