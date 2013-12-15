#!/bin/sh
#
#   File:    llnms-register-asset-scanner.sh
#   Author:  Marvin Smith
#   Date:    12/14/2013
#
#   Purpose:  This will add scanners to assets.


#----------------------------------------#
#-       Print Usage Instructions       -#
#----------------------------------------#
usage(){

    echo "$0 [options]"
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
}


#-------------------------------------#
#             Error Function          #
#-------------------------------------#
error(){
    echo "error: $1"
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
source $LLNMS_HOME/config/llnms-info.sh

#  Import scanning utilities
source $LLNMS_HOME/bin/llnms_scanning_utilities.sh

#  Import asset utilities
source $LLNMS_HOME/bin/llnms-asset-utilities.sh


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
SCANNER_PATHS=$(llnms_list_registered_scanner_paths)
SCANNER_EXISTS=0
for SCANNER_FILE in $SCANNER_PATHS; do
    
    # compare id
    if [ "$SCANNER_VALUE" = "$(llnms_print_registered_scanner_id $SCANNER_FILE)" ]; then
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
ASSET_PATHS=$(ls $LLNMS_HOME/assets/*.llnms-asset.xml 2> /dev/null)
ASSET_EXISTS=0
for ASSET_FILE in $ASSET_PATHS; do
    
    # compare hostname
    if [ "$ASSET_VALUE" = "$(llnms_get_asset_hostname $ASSET_FILE)" ]; then
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
REG_SCANNERS=$(llnms_list_asset_registered_scanners $ASSET_PATH)
for REG_SCANNER in $REG_SCANNERS; do

    #  compare the scanner ids
    if [ "$REG_SCANNER" = "$SCANNER_VALUE" ]; then
        error "scanner $SCANNER_VALUE is already registered with the asset."
        exit 1
    fi

done


#-----------------------------------------------------------#
#-      Add the scanner to the asset manifest document     -#
#-----------------------------------------------------------#
llnms_add_registered_scanner_to_asset $ASSET_PATH $SCANNER_PATH

