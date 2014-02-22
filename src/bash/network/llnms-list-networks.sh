#!/bin/bash
#
#    File:    llnms-list-networks.bash
#    Author:  Marvin Smith
#    Date:    12/8/2013
#
#    Purpose:  List networks registered in LLNMS
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
#          Usage Instructions         #
#-------------------------------------#
usage(){
    echo "$0: [options]"
    echo ''
    echo '   options:'
    echo '      -h, --help    :  Print Usage Instructions'
    echo '      -v, --version :  Print Program Version Information'
    echo ''
    echo '      Formatting'
    echo '         -l, --list    :  Print in a List format'
    echo '         -p, --pretty  :  Print in a human-readable format (DEFAULT)'
    echo '         -x, --xml     :  Print in a XML format'
    echo ''
    echo '      --name-only      :  Print only network names'
    echo '      --file-only      :  Print only filenames'
}



#-------------------------------------#
#           Main Function            -#
#-------------------------------------#

#  Source llnms home
if [ "$LLNMS_HOME" == "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi


#  Import the version info
. $LLNMS_HOME/config/llnms-info


#  Set the output format
OUTPUT_FORMAT="LIST"
NAME_ONLY=0
FILE_ONLY=0

#  parse command-line options
for OPTION in $@; do

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

        #  Set format to pretty
        "-p" | "--pretty" )
            OUTPUT_FORMAT="PRETTY"
            ;;
        
        #  Set format to list
        '-l' | '--list' )
            OUTPUT_FORMAT='LIST'
            ;;

        #  Set format to xml
        "-x" | "--xml" )
            OUTPUT_FORMAT="XML"
            ;;
        
        #  Print only names
        '--name-only' )
            NAME_ONLY=1
            ;;

        #  Print only files
        '--file-only' )
            FILE_ONLY=1
            ;;

        #  Print Error
        *)
            error "Unknown option $OPTION"
            ;;

    esac
done


#  Start printing xml info if output type is xml
if [ "$OUTPUT_FORMAT" == "XML" ]; then
    OUTPUT="<llnms-list-network-output>\n"
fi


#   Iterate through each network file, printing information about each file
NETWORK_FILES=`ls $LLNMS_HOME/networks/*.llnms-network.xml 2> /dev/null`
for NETWORK_FILE in $NETWORK_FILES; do

   
    #  Print the filename
    if [ "$FILE_ONLY" = '1' ]; then
        printf "$NETWORK_FILE"
    fi

    #  Print the name
    NETWORK_NAME="`$LLNMS_HOME/bin/llnms-print-network-info -n  -f $NETWORK_FILE`"
    if [ "$OUTPUT_FORMAT" = 'LIST' -a "$NAME_ONLY" = '1' ]; then
        printf "$NETWORK_NAME"

    elif [ "$OUTPUT_FORMAT" = 'LIST' -a "$FILE_ONLY" = '0' -a "$NAME_ONLY" = '0' ]; then
        printf "$NETWORK_NAME, "
    fi

    #  Print the address start
    ADDRESS_START="`$LLNMS_HOME/bin/llnms-print-network-info -s -f $NETWORK_FILE`"
    if [ "$OUTPUT_FORMAT" = 'LIST' -a "$FILE_ONLY" = '0' -a "$NAME_ONLY" = '0' ]; then
        printf "$ADDRESS_START,  "
    fi

    #  Print the address end
    ADDRESS_END="`$LLNMS_HOME/bin/llnms-print-network-info -e -f $NETWORK_FILE`"
    if [ "$OUTPUT_FORMAT" = 'LIST' -a "$FILE_ONLY" = '0' -a "$NAME_ONLY" = '0' ]; then
        printf "$ADDRESS_END"
    fi

    #  Print a new line
    printf "\n"

done


