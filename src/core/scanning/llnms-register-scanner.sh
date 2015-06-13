#!/bin/bash
#
#   File:    llnms-register-scanner.sh
#   Author:  Marvin Smith
#   Date:    12/13/2013
#
#   Purpose:  Registers a scanner to the LLNMS Scanner List
#
#   Outputs:  
#     0 - Success
#     2 - Scanner already registered

#---------------------------------------#
#-          Usage Instructions         -#
#---------------------------------------#
usage(){

    echo "`basename $0` [options]"
    echo ''
    echo '    options:'
    echo '        -h, --help    : Print usage instructions'
    echo '        -v, --version : Print version information'
    echo '' 
    echo '        -s, --scanner [llnms-scanner.xml file] : Set the scanner filename (Mandatory)'
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

    echo "`basename $0` Information"
    echo ''
    echo "   LLNMS Version ${LLNMS_MAJOR}.${LLNMS_MINOR}.${LLNMS_SUBMINOR}"

}


#------------------------------------------------------------#
#-     Add a scanner to the registered scanners xml file    -#
#-                                                          -#
#-     $1 - Path to add                                     -#
#------------------------------------------------------------#
llnms_add_scanner_to_registered_list(){
    XMLFILE="$LLNMS_HOME/run/llnms-registered-scanners.xml"
    xmlstarlet ed -L --subnode "/llnms-registered-scanners" --type elem -n 'llnms-scanner' -v $1 $XMLFILE
}


#-------------------------------------#
#-           Main Function           -#
#-------------------------------------#

#  Source llnms home
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi

#  Import the version info
. $LLNMS_HOME/config/llnms-info


#  Scanner flags
SCANNER_FLAG=0
SCANNER_FILE=''

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
        
        #  Set the scanner flag
        '-s' | '--scanner' )
            SCANNER_FLAG=1
            ;;

        #  Otherwise there is an error or we are pulling values
        *)

            #  Set the scanner filename
            if [ $SCANNER_FLAG -eq 1 ]; then
                SCANNER_FLAG=0
                SCANNER_FILE=$OPTION

            #  Otherwise, there is an error
            else
                error "unknown option $OPTION"
                exit 1
            fi

            ;;
        
    esac
done


#-----------------------------------------------#
#-      Make sure the scanner file exists      -#
#-----------------------------------------------#
if [ ! -e "$SCANNER_FILE" ]; then
    error "Scanner file at $SCANNER_FILE does not exist"
    exit 1
fi


#-------------------------------------------------------------#
#-     Make sure the scanner has not already been added      -#
#-------------------------------------------------------------#
SCANNER_PATHS=`$LLNMS_HOME/bin/llnms-list-scanners -l -f`
for SCANNER in $SCANNER_PATHS; do
    if [ "$SCANNER" = "$SCANNER_FILE" ]; then
        echo 'Scanner has already been registered. Skipping registration.'
        exit 2;
    fi
done


#--------------------------------------------------------------------#
#-  If the registered scanner list does not exist, then create it   -#
#--------------------------------------------------------------------#
if [ ! -e "$LLNMS_HOME/run/llnms-registered-scanners.xml" ]; then
    llnms_create_registered_scanners_file
fi


#---------------------------------------------------------------------#
#-     If it is not already registered, then add it to the list      -#
#---------------------------------------------------------------------#
llnms_add_scanner_to_registered_list $SCANNER_FILE

#  Output success
exit 0

