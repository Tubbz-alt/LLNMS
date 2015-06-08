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
    echo '        -h, --help    :  Print usage instructions.'
    echo '        -v, --version :  Print version information.'
    echo '        -V, --verbose :  Print with verbose output.'
    echo ''
    echo '        -a, --asset [asset hostname] : Asset hostname to run scans against.'
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


#------------------------------------------#
#-    Given an id, get the scanner path   -#
#------------------------------------------#
get_scanner_path_from_id(){

    #  Get a list of scanners
    SCANNER_LIST=`llnms-list-scanners -f -l`

    for SCANNER in $SCANNER_LIST; do
        if [ "`llnms-print-scanner-info -f $SCANNER -i`" = "$1" ]; then
            echo $SCANNER
            return
        fi
    done

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

#  Import asset utilities
. $LLNMS_HOME/config/llnms-config


#  Asset name and path
ASSET_HOSTNAME=''
ASSET_PATH=''
ASSET_FLAG=0

VERBOSE_FLAG=0


#   Parse Command-Line Options
for OPTION in "$@"; do

    case $OPTION in

        #  Print usage instructions
        '-h' | '--help' )
            usage
            exit 1
            ;;

        #  Print verbose output
        '-V' | '--verbose' )
            VERBOSE_FLAG=1
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


#-----------------------------------------------#
#-   If no asset specified, then throw error   -#
#-----------------------------------------------#
if [ "$ASSET_HOSTNAME" = '' ]; then
    error  "No asset specified."  "$LINENO" 
    usage
    exit 1
fi

#-------------------------------------#
#-    Make sure the asset exists     -#
#-------------------------------------#
# get a list of assets
ASSET_LIST=`llnms-list-assets -l -path`

for ASSET_FILE in $ASSET_LIST; do
    #  check the hostname.  if they match, then retrieve the asset filename
    if [ "`llnms-print-asset-info -f $ASSET_FILE -host`" = "$ASSET_HOSTNAME" ]; then
        ASSET_PATH=$ASSET_FILE
    fi
done

#  if the asset path is blank, then the asset was not found.
if [ "$ASSET_PATH" = '' ]; then
    error "Asset with hostname ($ASSET_HOSTNAME) does not exist." "$LINENO"
    usage
    exit 1
fi


#-----------------------------------------------------#
#-       Get the list of scanners and run each       -#
#-----------------------------------------------------#

#   - get a list of registered scanners
ASSET_SCANNERS=`llnms-print-asset-info  -f $ASSET_PATH -s`
for ASSET_SCANNER in $ASSET_SCANNERS; do
    
    #  get the file pathname for the scanner
    SCANNER_PATH=`get_scanner_path_from_id $ASSET_SCANNER`
    
    #  Get the command we have to run
    SCANNER_CMD=`llnms-print-scanner-info -f $SCANNER_PATH -c`
    SCANNER_BASE_PATH=`llnms-print-scanner-info -f $SCANNER_PATH -b`

    #  Get the number of arguments to query
    NUMARGS=`llnms-print-scanner-info -f $SCANNER_PATH -num`

    #  get the argument-list for the scanner
    ARGC=`llnms-print-asset-info -f $ASSET_PATH -sac $ASSET_SCANNER`
    ARGLIST=''
    for ((x=1; x<=$ARGC; x++ )); do
        
        #  Get the arg value
        ARGFLG=`llnms-print-asset-info -f $ASSET_PATH -san $ASSET_SCANNER $x`
        ARGVAL=`llnms-print-asset-info -f $ASSET_PATH -sav $ASSET_SCANNER $x`

        ARGLIST="$ARGLIST --$ARGFLG $ARGVAL"
    done
    
    #  merge all variables into a single command
    COMMAND_RUN="$SCANNER_BASE_PATH/$SCANNER_CMD $ARGLIST"
    
    #  Running command
    echo "Running $COMMAND_RUN"
    $COMMAND_RUN &> $LLNMS_HOME/log/llnms-scan-asset.log
    
    #  Grab the output
    RESULT="$?"
    

done

