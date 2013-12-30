#!/bin/sh
#
#   File:    llnms-register-asset-scanner.sh
#   Author:  Marvin Smith
#   Date:    12/14/2013
#
#   Purpose:  This will add scanners to assets.
#
#   Returns:
#      0 - Scanner successfully registered to asset.
#      2 - Scanner is already registered to asset.



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
    echo '        -a, --asset [asset hostname]  : Specify asset to apply'
    echo '                                        scanner to. (Mandatory)'
    echo '        -s, --scanner [scanner id]    : Specify scanner to add.'
    echo '                                        (Mandatory)'
    echo ''
    #echo '        -p, --parameter [key] [value] : Set an argument to the scanner.'
    #echo ''
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
#-   Add a scanner to the asset      -#
#-                                   -#
#-   $1 - Asset path to update.      -#
#-   $2 - Scanner path to register.  -#
#-------------------------------------#
llnms_add_registered_scanner_to_asset(){

    # set some helper variables
    ASSET_PATH=$1
    SCANNER_PATH=$2

    #  Get the current number of registered scanners
    SCANNER_CNT=`llnms-print-asset-info.sh -f $ASSET_PATH -s | sed '/^\s*$/d' | wc -l | sed 's/ *//g'`
    
    #  Make sure asset exists
    if [ ! -e $ASSET_PATH ]; then
        return
    fi

    #  Make sure scanner exists
    if [ ! -e $SCANNER_PATH ]; then
        return
    fi

    #  Make sure the asset has the scanners xml element
    SCANNERS_OUTPUT=`xmlstarlet el $ASSET_PATH | grep scanners`
    if [ "$SCANNERS_OUTPUT" == '' ]; then
        xmlstarlet ed -L --subnode "/llnms-asset" --type elem -n 'scanners' -v '' $ASSET_PATH
    fi

    # Add the scanner
    xmlstarlet ed -L --subnode "/llnms-asset/scanners" --type elem -n 'scanner' -v '' $ASSET_PATH

    # Add the id
    xmlstarlet ed -L --subnode "/llnms-asset/scanners/scanner[`expr $SCANNER_CNT + 1`]" --type elem -n 'id' -v "`llnms-print-scanner-info.sh -f $SCANNER_PATH --id`" $ASSET_PATH

    #  Add the arguments
    NUM_ARGS=`llnms-print-scanner-info.sh -f $SCANNER_PATH -num`
    for ((x=1; x<=$NUM_ARGS; x++)); do
        
        #  Get the name of the scanner argument
        SCANNER_ARG_NAME=`llnms-print-scanner-info.sh -f $SCANNER_PATH -arg-name $x`
        SCANNER_ARG_TYPE=`llnms-print-scanner-info.sh -f $SCANNER_PATH -arg-type $x`
        SCANNER_ARG_VALUE=`llnms-print-scanner-info.sh -f $SCANNER_PATH -arg-val $x`
        SCANNER_ARG_DEFAULT=`llnms-print-scanner-info.sh -f $SCANNER_PATH -arg-def $x`
        
        #  If the parameter is of type ASSET_ELEMENT, then take the value and query is
        ARG_VALUE=''
        if [ "$SCANNER_ARG_TYPE" = 'ASSET_ELEMENT' ]; then
            ARG_VALUE=`llnms-print-asset-info.sh -f $ASSET_PATH "--${SCANNER_ARG_VALUE}"`
        elif [ "$SCANNER_ARG_TYPE" = 'ASSET_SCANNER_FLAG' ]; then
            ARG_VALUE=$SCANNER_ARG_DEFAULT
        else
            error "Unknown argument type of $SCANNER_ARG_TYPE." "$LINENO" "`basename $0`"
            exit 1
        fi

        #  Insert the argument into the file
        xmlstarlet ed -L --subnode "/llnms-asset/scanners/scanner[`expr $SCANNER_CNT + 1`]" --type elem -n 'argument' -v '' $ASSET_PATH
        xmlstarlet ed -L --subnode "/llnms-asset/scanners/scanner[`expr $SCANNER_CNT + 1`]/argument[$x]" --type attr -n 'name'     -v "$SCANNER_ARG_NAME" $ASSET_PATH
        xmlstarlet ed -L --subnode "/llnms-asset/scanners/scanner[`expr $SCANNER_CNT + 1`]/argument[$x]" --type attr -n 'value'    -v "$ARG_VALUE"        $ASSET_PATH
        
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
. $LLNMS_HOME/config/llnms-info.sh

#  Import configuration info
. $LLNMS_HOME/config/llnms-config.sh

#  Flags
ASSET_FLAG=0
ASSET_VALUE=''

SCANNER_FLAG=0
SCANNER_VALUE=''

#  The asset file associated with the desired asset
ASSET_PATH=''

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

        # Set the asset flag
        '-a' | '--asset' )
            ASSET_FLAG=1
            ;;

        #  Print error message or process flags
        *)
            #  get the asset value
            if [ $ASSET_FLAG -eq 1 ]; then
                ASSET_VALUE=$OPTION
                ASSET_FLAG=0

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
#  make sure asset and scanner values are not blank
if [ "$ASSET_VALUE" == '' ]; then
    error "Asset flag (-a, --asset) was not called or called incorrectly."
    usage
    exit 1
fi

if [ "$SCANNER_VALUE" == '' ]; then
    error "Scanner flag (-s, --scanner) was not called or called incorrectly."
    usage
    exit 1
fi


#----------------------------#
#-      Error Checking      -#
#----------------------------#
#  Make sure the scanner exists
SCANNER_PATHS=`llnms-list-scanners.sh -f -l`
SCANNER_EXISTS=0
for SCANNER_FILE in $SCANNER_PATHS; do
    
    # compare id
    if [ "$SCANNER_VALUE" =  "`llnms-print-scanner-info.sh -f $SCANNER_FILE -i`" ]; then
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


#  Make sure the asset exists
ASSET_PATHS=`llnms-list-assets.sh -path -l`
ASSET_EXISTS=0
for ASSET_FILE in $ASSET_PATHS; do
   
    # compare hostname
    if [ "$ASSET_VALUE" = "`llnms-print-asset-info.sh -f $ASSET_FILE -host`" ]; then
        ASSET_EXISTS=1
        ASSET_PATH=$ASSET_FILE
        break;
    fi
done
if [ $ASSET_EXISTS -eq 0 ]; then
    error "Asset \"$ASSET_VALUE\" is not a known asset."
    usage
    exit 1
fi


#------------------------------------------------------------------------#
#-     Make sure the scanner is not already registered with the asset   -#
#------------------------------------------------------------------------#
# get a list of registered scanners for the asset
REG_SCANNERS=`llnms-print-asset-info.sh -f $ASSET_PATH -s`
for REG_SCANNER in $REG_SCANNERS; do

    #  compare the scanner ids
    if [ "$REG_SCANNER" = "$SCANNER_VALUE" ]; then
        error "scanner $SCANNER_VALUE is already registered with the asset."
        exit 2
    fi
done


#-----------------------------------------------------------#
#-      Add the scanner to the asset manifest document     -#
#-----------------------------------------------------------#

llnms_add_registered_scanner_to_asset $ASSET_PATH $SCANNER_PATH

