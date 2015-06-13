#!/bin/bash
#
#   File:    llnms-register-network-scanner.sh
#   Author:  Marvin Smith
#   Date:    6/10/2015
#
#   Purpose:  This will add scanners to network definitions.
#
#   Returns:
#      0 - Scanner successfully registered to network.
#      2 - Scanner is already registered to network.
#      Otherwise, error



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
    echo '        -n, --network [network name]  : Specify network to apply'
    echo '                                        scanner to. (Mandatory)'
    echo '        -s, --scanner [scanner id]    : Specify scanner to add.'
    echo '                                        (Mandatory)'
    echo ''
    echo '        -p, --parameter [key] [value] : Set an argument to the scanner.'
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


#-------------------------------------#
#-   Add a scanner to the network    -#
#-                                   -#
#-   $1 - Network path to update.    -#
#-   $2 - Scanner path to register.  -#
#-------------------------------------#
llnms_add_registered_scanner_to_network(){

    # set some helper variables
    NETWORK_PATH=$1
    SCANNER_PATH=$2

    #  Get the current number of registered scanners
    SCANNER_CNT=`$LLNMS_HOME/bin/llnms-print-network-info  -f $NETWORK_PATH -sc | sed '/^\s*$/d' | wc -l | sed 's/ *//g'`

    #  Make sure network exists
    if [ ! -e $NETWORK_PATH ]; then
        return
    fi

    #  Make sure scanner exists
    if [ ! -e $SCANNER_PATH ]; then
        return
    fi

    #  Make sure the network has the scanners xml element
    SCANNERS_OUTPUT=`xmlstarlet el $NETWORK_PATH | grep scanners`
    if [ "$SCANNERS_OUTPUT" = '' ]; then
        xmlstarlet ed -L --subnode "/llnms-network" --type elem -n 'scanners' -v '' $NETWORK_PATH
    fi

    # Add the scanner
    xmlstarlet ed -L --subnode "/llnms-network/scanners" --type elem -n 'scanner' -v '' $NETWORK_PATH

    # Add the id
    xmlstarlet ed -L --subnode "/llnms-network/scanners/scanner[`expr $SCANNER_CNT + 1`]" --type elem -n 'id' -v "`llnms-print-scanner-info  -f $SCANNER_PATH --id`" $NETWORK_PATH

    #  Add the arguments
    NUM_ARGS=`$LLNMS_HOME/bin/llnms-print-scanner-info  -f $SCANNER_PATH -num`
    for ((x=1; x<=$NUM_ARGS; x++)); do
        
        #  Get the name of the scanner argument
        SCANNER_ARG_NAME=`$LLNMS_HOME/bin/llnms-print-scanner-info  -f $SCANNER_PATH -arg-name $x`
        SCANNER_ARG_TYPE=`$LLNMS_HOME/bin/llnms-print-scanner-info  -f $SCANNER_PATH -arg-type $x`
        SCANNER_ARG_VALUE=`$LLNMS_HOME/bin/llnms-print-scanner-info -f $SCANNER_PATH -arg-val $x`
        SCANNER_ARG_DEFAULT=`$LLNMS_HOME/bin/llnms-print-scanner-info  -f $SCANNER_PATH -arg-def $x`
        
        #  If the parameter is of type ASSET_ELEMENT, then take the value and query is
        ARG_VALUE=''
        if [ "$SCANNER_ARG_TYPE" = 'ASSET_ELEMENT' ]; then
            ARG_VALUE=''
            #=`$LLNMS_HOME/bin/llnms-print-network-info  -f $NETWORK_PATH "--${SCANNER_ARG_VALUE}"`
        elif [ "$SCANNER_ARG_TYPE" = 'ASSET_SCANNER_FLAG' ]; then
            ARG_VALUE=$SCANNER_ARG_DEFAULT
        else
            error "Unknown argument type of $SCANNER_ARG_TYPE." "$LINENO" "`basename $0`"
            exit 1
        fi

        #  Insert the argument into the file
        xmlstarlet ed -L --subnode "/llnms-network/scanners/scanner[`expr $SCANNER_CNT + 1`]" --type elem -n 'argument' -v '' $NETWORK_PATH
        xmlstarlet ed -L --subnode "/llnms-network/scanners/scanner[`expr $SCANNER_CNT + 1`]/argument[$x]" --type attr -n 'name'     -v "$SCANNER_ARG_NAME" $NETWORK_PATH
        xmlstarlet ed -L --subnode "/llnms-network/scanners/scanner[`expr $SCANNER_CNT + 1`]/argument[$x]" --type attr -n 'value'    -v "$ARG_VALUE"        $NETWORK_PATH
        
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


#  Flags
NETWORK_FLAG=0
NETWORK_VALUE=''

SCANNER_FLAG=0
SCANNER_VALUE=''

#  The network file associated with the desired network
NETWORK_PATH=''

#  The scanner file associated with the desired scanner
SCANNER_PATH=''


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
        
        # Set the scanner flag
        '-s' | '--scanner' )
            SCANNER_FLAG=1
            ;;

        # Set the network flag
        '-n' | '--network' )
            NETWORK_FLAG=1
            ;;

        #  Print error message or process flags
        *)
            #  get the network value
            if [ $NETWORK_FLAG -eq 1 ]; then
                NETWORK_VALUE=$OPTION
                NETWORK_FLAG=0

            #  get the scanner value
            elif [ $SCANNER_FLAG -eq 1 ]; then
                SCANNER_VALUE=$OPTION
                SCANNER_FLAG=0
            
            #  otherwise, throw an error
            else
                error "Unknown option $OPTION"
                usage
                exit 1
            fi
            ;;


    esac
done


#-----------------------------#
#-    Dependency Checking    -#
#-----------------------------#
#  make sure network and scanner values are not blank
if [ "$NETWORK_VALUE" = '' ]; then
    error "Network flag (-n, --network) was not called or called incorrectly."
    usage
    exit 1
fi

if [ "$SCANNER_VALUE" = '' ]; then
    error "Scanner flag (-s, --scanner) was not called or called incorrectly."
    usage
    exit 1
fi


#----------------------------#
#-      Error Checking      -#
#----------------------------#
#  Make sure the scanner exists
SCANNER_PATHS=`$LLNMS_HOME/bin/llnms-list-scanners -f -l`
SCANNER_EXISTS=0
for SCANNER_FILE in $SCANNER_PATHS; do
    
    # compare id
    if [ "$SCANNER_VALUE" =  "`$LLNMS_HOME/bin/llnms-print-scanner-info -f $SCANNER_FILE -i`" ]; then
        SCANNER_EXISTS=1
        SCANNER_PATH=$SCANNER_FILE
        break;
    fi
done
if [ $SCANNER_EXISTS -eq 0 ]; then
    error "scanner \"$SCANNER_VALUE\" is not a registered scanner"
    usage
    exit 1
fi


#  Make sure the network exist
if [ ! "`llnms-list-networks --name-only | grep $NETWORK_VALUE`" = "$NETWORK_VALUE" ]; then
    error "No network found matching $NETWORK_VALUE"
fi
NETWORK_PATH=`llnms-list-networks -l | grep $NETWORK_VALUE | awk '{print $4;}'`
if [ ! -f "$NETWORK_PATH" ]; then
    error "No LLNMS network file found matching $NETWORK_VALUE"
fi


#-------------------------------------------------------------------------#
#-     Make sure the scanner is not already registered with the network  -#
#-------------------------------------------------------------------------#
# get a list of registered scanners for the network
REG_SCANNERS=`$LLNMS_HOME/bin/llnms-print-network-info  -f $NETWORK_PATH -sc`
for REG_SCANNER in $REG_SCANNERS; do

    #  compare the scanner ids
    if [ "$REG_SCANNER" = "$SCANNER_VALUE" ]; then
        error "scanner $SCANNER_VALUE is already registered with the network."
        exit 2
    fi
done


#-------------------------------------------------------------#
#-      Add the scanner to the network manifest document     -#
#-------------------------------------------------------------#
llnms_add_registered_scanner_to_network $NETWORK_PATH $SCANNER_PATH

