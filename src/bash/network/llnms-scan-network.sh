#!/bin/bash
#
#    File:     llnms-scan-network.sh
#    Author:   Marvin Smith
#    Date:     6/10/2015
#
#    Purpose:  Scan network for assets.
#

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
#          Usage Instructions         #
#-------------------------------------#
usage(){
    echo "`basename $0` [options]"
    echo ''
    echo '   options:'
    echo '      -h, --help    :  Print Usage Instructions'
    echo '      -v, --version :  Print Program Version Information'
    echo ''
    echo '      --verbose     :  Print program output to stdout (DEFAULT)'
    echo '      --quiet       :  Do not print program output to stdout'
    echo ''
    echo '      -n <network>     : Specify network name.'
    echo '      -s <scanner-id>  : Run a specific scanner on network.'
    echo ''
    echo '      -l | --list   :  Print results in list format.'
    echo ''

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


#-------------------------#
#-        Run Scan       -#
#-------------------------#
Run_Scan(){
    
    #  Grab address
    ADDRESS=$TEST_ADDRESS
    
    #  get the argument-list for the scanner
    ARGC=`llnms-print-network-info -f $NETWORK_PATH -sac $SCANNER_VALUE`
    ARGLIST=''

    for ((x=1; x<=$ARGC; x++ )); do
        
        #  Get the arg value
        ARGFLG=`llnms-print-network-info -f $NETWORK_PATH -san $SCANNER_VALUE $x`
        ARGVAL=`llnms-print-network-info -f $NETWORK_PATH -sav $SCANNER_VALUE $x`

        #  Check if the argument is the ip4-address
        if [ "$ARGFLG" = 'ip4-address' ]; then
            ARGVAL=$ADDRESS
        fi

        ARGLIST="$ARGLIST --$ARGFLG $ARGVAL"
    done
    
    #  merge all variables into a single command
    COMMAND_RUN="$SCANNER_BASE_PATH/$SCANNER_CMD $ARGLIST"
    
    #  Running command
    CMD_OUTPUT=`$COMMAND_RUN`
    RESULT="$?"
    
    #  Log Output
    echo $CMD_OUTPUT &> $LLNMS_HOME/log/llnms-scan-asset.log
    
    if [ "$VERBOSE_FLAG" = '1' ]; then
        echo "Running: $COMMAND_RUN"
        echo "$CMD_OUTPUT"
    else
        if [ "$RESULT" = '0' ]; then
            printf '%s PASSED\n' $TEST_ADDRESS
        else
            printf '%s FAILED\n' $TEST_ADDRESS
        fi
    fi
}


#---------------------------------#
#         Main Functions          #
#---------------------------------#

#  Source llnms home
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi


#  Import the version info
. $LLNMS_HOME/config/llnms-info

#  output state
OUTPUT_STATE='VERBOSE'

NETWORK_FLAG=0
SCANNER_FLAG=0

NETWORK_VALUE=''
SCANNER_VALUE=''

MAX_PROCESSES=4

FORMAT='list'

#  parse command-line options
for OPTION in "$@"; do

    case $OPTION in

        #  Print Usage Instructions
        "-h" | "--help" )
            usage
            exit 1
            ;;
        
        #  Print Version Information
        "-v" | "--version" )
            version
            exit 1
            ;;

        #  Print output to stdout
        '--verbose' )
            OUTPUT_STATE='VERBOSE'
            ;;

        #  Do not print output to stdout
        '--quiet' )
            OUTPUT_STATE='QUIET'
            ;;

        #  Get the network name
        '-n' | '--network')
            NETWORK_FLAG=1
            SCANNER_FLAG=0
            ;;

        #  Get the scanner name
        '-s' | '--scanner')
            SCANNER_FLAG=1
            NETWORK_FLAG=0
            ;;

        #  Handle misc arguments
        *)
            #  Check if network name set
            if [ "$NETWORK_FLAG" = '1' ]; then
                NETWORK_FLAG=0
                NETWORK_VALUE=$OPTION
            
            #  Check if scanner name set
            elif [ "$SCANNER_FLAG" = '1' ]; then
                SCANNER_FLAG=0
                SCANNER_VALUE=$OPTION

            #  Print Error
            else
                error "Unknown option $OPTION"
            fi
            ;;

    esac
done

#---------------------------------#
#-     Check required inputs     -#
#---------------------------------#
if [ "$NETWORK_VALUE" = '' ]; then
    error "No network value specified."
    usage
    exit 1
fi
if [ "$SCANNER_VALUE" = '' ]; then
    error "No scanner value specified."
    usage
    exit 1
fi

#----------------------------------------#
#-     Make sure the network exists     -#
#----------------------------------------#
if [ ! "`llnms-list-networks --name-only | grep $NETWORK_VALUE`" = "$NETWORK_VALUE" ]; then
    error "No network found matching $NETWORK_VALUE"
    exit 1
fi
NETWORK_PATH=`llnms-list-networks -l | grep $NETWORK_VALUE | awk '{print $4;}'`
if [ ! -f "$NETWORK_PATH" ]; then
    error "No LLNMS network file found matching $NETWORK_VALUE"
    exit 1
fi



#--------------------------------------------#
#-       Make sure the scanner exists       -#
#--------------------------------------------#
SCANNER_RESULT=`llnms-list-networks | awk '{ print $1;}' | grep "$NETWORK_VALUE"`
if [ "$SCANNER_RESULT" = '' ]; then 
    echo 'error: Unable to find the specified network.'
    exit 1
fi

#  Grab the scanner path
SCANNER_PATH=`get_scanner_path_from_id $SCANNER_VALUE`

 #  Get the command we have to run
SCANNER_CMD=`llnms-print-scanner-info -f $SCANNER_PATH -c`
 
SCANNER_BASE_PATH=`llnms-print-scanner-info -f $SCANNER_PATH -b`
 
#  Get the number of arguments to query
NUMARGS=`llnms-print-scanner-info -f $SCANNER_PATH -num`


#---------------------------------------------#
#-       Iterate over the address range      -#
#---------------------------------------------#

#  Get the address range
ADDR_BEG=`$LLNMS_HOME/bin/llnms-print-network-info -f $NETWORK_PATH -s`
ADDR_END=`$LLNMS_HOME/bin/llnms-print-network-info -f $NETWORK_PATH -e`


#  Split the addresses into 4 parts
ADDR_BEG_1=`echo $ADDR_BEG | cut -d '.' -f 1`
ADDR_BEG_2=`echo $ADDR_BEG | cut -d '.' -f 2`
ADDR_BEG_3=`echo $ADDR_BEG | cut -d '.' -f 3`
ADDR_BEG_4=`echo $ADDR_BEG | cut -d '.' -f 4`

ADDR_END_1=`echo $ADDR_END | cut -d '.' -f 1`
ADDR_END_2=`echo $ADDR_END | cut -d '.' -f 2`
ADDR_END_3=`echo $ADDR_END | cut -d '.' -f 3`
ADDR_END_4=`echo $ADDR_END | cut -d '.' -f 4`


#  Iterate over each address range        
for (( a=$ADDR_BEG_1; a<=$ADDR_END_1; a++ )); do
for (( b=$ADDR_BEG_2; b<=$ADDR_END_2; b++ )); do
for (( c=$ADDR_BEG_3; c<=$ADDR_END_3; c++ )); do
for (( d=$ADDR_BEG_4; d<=$ADDR_END_4; d++ )); do
    
    #  create address
    TEST_ADDRESS="${a}.${b}.${c}.${d}"
        
        
    #  Run scan on address
    Run_Scan $TEST_ADDRESS
    
done
done
done
done

#  Wait for all jobs to finish
wait

