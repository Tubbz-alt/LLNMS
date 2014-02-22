#!/bin/sh
#
#   File:    llnms-remove-asset.sh
#   Author:  Marvin Smith
#   Date:    12/25/2013
#
#   Purpose:  Removes an LLNMS asset if it exists
#

#----------------------------------------#
#-       Print Usage Instructions       -#
#----------------------------------------#
usage(){

    echo "`basename $0` [options]"
    echo ''
    echo '    options:'
    echo '        -h, --help        :  Print usage instructions'
    echo '        -v, --version     :  Print version information'
    echo '        -i, --interactive :  Give warnings before removal.'
    echo ''
    echo '        Search Options:  (Search using one or more options.)'
    echo '        -host, --hostname [hostname]  : Search for asset by hostname'
    echo '        -ip4, --ip4-address [address] : Search for asset by ip4 address'
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
        echo "warning: $1"

    #  If the user only gives the line number
    elif [ $# -eq 2 ]; then
        echo "warning: $1  Line: $2,  File: `basename $0`"

    #  If the user gives the line number and file
    else
        echo "warning: $1  Line: $2, File: $3"
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
        echo "error: $1"

    #  If the user only gives the line number
    elif [ $# -eq 2 ]; then
        echo "error: $1  Line: $2,  File: `basename $0`"

    #  If the user gives the line number and file
    else
        echo "error: $1  Line: $2, File: $3"
    fi
}


#-------------------------------------#
#           Version Function          #
#-------------------------------------#
version(){

    echo "`basename $0` Information"
    echo ''
    echo "   LLNMS Version ${LLNMS_MAJOR}.${LLNMS_MINOR}.${LLNMS_SUBMINOR}"

}

 
#------------------------------------------------------------#
#-        Delete the file given the interactive state       -#
#-             and the file to delete.                      -#
#-                                                          -#
#-      $1 - Interactive Mode State: 0 - Off, 1 - On        -#
#-      $2 - File to delete                                 -#
#-      $3 - Matched Pattern                                -#
#------------------------------------------------------------#
discard_file(){

    INTERACTIVE_FLAG="$1"
    ASSET_FILE="$2"
    REMOVE_FILE=0
    
    #  If interactive mode is set, then print the warning
    if [ "$INTERACTIVE_FLAG" = '1' ]; then
        
        echo "File $ASSET_FILE found which matches the pattern..."
        echo "   $3"
        echo "Do you wish to delete the file? (y/n - default): \c"
        read ANS
        
        #  If the user wants to delete the file, then set the flag
        if [ "$ANS" = 'y' -o "$ANS" = 'Y' ]; then
            echo ''
            echo 'Removing File'
            REMOVE_FILE=1

        else
            echo 'Skipping file'
        fi
        echo ''
    
    #  Otherwise, if the user is not in interactive mode, then just delete the file
    else
        REMOVE_FILE=1
    fi
    
    if [ "$REMOVE_FILE" = "1" ]; then
        rm $ASSET_FILE
    fi

}


#---------------------------------#
#-         Main Function         -#
#---------------------------------#

#  Source llnms home
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi


#  Import the version info
. $LLNMS_HOME/config/llnms-info

#   Search flags and values
SEARCH_HOSTNAME=''
HOSTNAME_FLAG=0

SEARCH_IP4ADDRESS=''
IP4ADDRESS_FLAG=0

INTERACTIVE_FLAG=0


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

        #  Search by hostname
        '-host' | '--hostname' )
            HOSTNAME_FLAG=1
            ;;
        
        #  Search by ip4 address
        '-ip4' | '--ip4-address' )
            IP4ADDRESS_FLAG=1
            ;;

        #  Interactive flag
        '-i' | '--interactive' )
            INTERACTIVE_FLAG=1
            ;;

        #  Process flag values or print error message
        *)
            
            #  If the user wants to search by hostname
            if [ $HOSTNAME_FLAG -eq 1 ]; then
                HOSTNAME_FLAG=0
                SEARCH_HOSTNAME=$OPTION

            #  If the user wants to search by ip4 address
            elif [ $IP4ADDRESS_FLAG -eq 1 ]; then
                IP4ADDRESS_FLAG=0
                SEARCH_IP4ADDRESS=$OPTION

            #  Print an error for an unknown option
            else
                error "Unknown option $OPTION"
                usage
                exit 1
            fi

            ;;


    esac
done


#-------------------------------------------------------------------#
#-     Make sure there is something to search for an asset by      -#
#-------------------------------------------------------------------#
if [ "$SEARCH_HOSTNAME" == '' -a "$SEARCH_IP4ADDRESS" == '' ]; then
    error "In order to remove asset, you must provide either hostname or ip4 address."
    exit 1
fi
 

#--------------------------------------#
#-      Get a list of assets          -#
#--------------------------------------#

#  Flag which tells us if anything was found
ASSET_MATCH_FOUND=0

ASSET_FILES="`ls $LLNMS_HOME/assets/*.llnms-asset.xml 2> /dev/null`"
for ASSET_FILE in $ASSET_FILES; do
    
    #  If we are searching using hostname, then grab the hostname
    if [ ! "$SEARCH_HOSTNAME" = '' ]; then
        TEMP_HOSTNAME="`$LLNMS_HOME/bin/llnms-print-asset-info -f $ASSET_FILE -host`"
       
        #  If the hostname of the file and our search hostname match, then remove the file
        if [ "$TEMP_HOSTNAME" = "$SEARCH_HOSTNAME" ]; then
            discard_file $INTERACTIVE_FLAG $ASSET_FILE "hostname: $SEARCH_HOSTNAME"
            ASSET_MATCH_FOUND=1
        fi
    fi

    #  If the pattern matches additional criterion and has been deleted, go no futher
    SKIP_ASSET=0
    if [ ! -e "$ASSET_FILE" ]; then
        SKIP_ASSET=1
    fi

    #  If we are searching using IP4 Address, then grab the address
    if [ "$SKIP_ASSET" = 0 -a ! "$SEARCH_IP4ADDRESS" = "" ]; then
        TEMP_IP4ADDRESS="`$LLNMS_HOME/bin/llnms-print-asset-info -f $ASSET_FILE -ip4`"
        
        #  If the address of the file and our search address match, then remove the file
        if [ "$TEMP_IP4ADDRESS" = "$SEARCH_IP4ADDRESS" ]; then
            discard_file $INTERACTIVE_FLAG $ASSET_FILE "ip4-address: $SEARCH_IP4ADDRESS"
            ASSET_MATCH_FOUND=1
        fi
    
    fi

done

#  If no match was found, inform the user
if [ "$ASSET_MATCH_FOUND" = "0" ]; then
    error 'No match was found with the input search criteria' "$LINENO"
    exit 1
fi



