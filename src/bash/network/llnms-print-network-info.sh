#!/bin/sh
#
#    File:     llnms-print-network-info.sh
#    Author:   Marvin Smith
#    Date:     2/7/2014
#
#    Purpose:  Print network information
#

#----------------------------------------#
#-       Print Usage Instructions       -#
#----------------------------------------#
usage(){

    echo "`basename $0` [options]"
    echo ''
    echo '    options:'
    echo '        -h, --help         :  Print usage instructions'
    echo '        -v, --version      :  Print version information'
    echo ''
    echo '        -f, --file [file]  :  Select file to print' 
    echo ''
    echo '    Printing Information:'
    echo '        -a, --all     :  Print all information (Default)'
    echo '        -n, --name    :  Print network name'
    echo '        -s, --start   :  Print address start'
    echo '        -e, --end     :  Print address end'
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


#---------------------------------#
#-         Main Function         -#
#---------------------------------#

#  Source llnms home
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi


#  Import the version info
. $LLNMS_HOME/config/llnms-info

#  Import the configuration info
. $LLNMS_HOME/config/llnms-config

#   Set file
FILE_FLAG=0
FILE_VALUE=''

PRINT_ALL=1
PRINT_NAME=0
PRINT_ADDRESS_START=0
PRINT_ADDRESS_END=0


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
        
        #  Set file
        '-f' | '--file' )
            FILE_FLAG=1
            ;;

        #  Print everything
        '-a' | '--all' )
            PRINT_ALL=1
            ;;

        #  Print name only
        '-n' | '--name' )
            PRINT_ALL=0
            PRINT_NAME=1
            ;;

        #   Print address start
        '-s' | '--start' )
            PRINT_ALL=0
            PRINT_ADDRESS_START=1
            ;;

        #   Print address end
        '-e' | '--end' )
            PRINT_ALL=0
            PRINT_ADDRESS_END=1
            ;;

        #  Process flag values or print error message
        *)
            
            #   If the file flag has been set, grab the value
            if [ "$FILE_FLAG" = '1' ]; then
                FILE_VALUE=$OPTION
                FILE_FLAG=0

            #   Otherwise throw an error
            else
                error "Unknown option $OPTION"
                usage
                exit 1
            fi

            ;;


    esac
done

#-------------------------------------------------------#
#-      Make sure a network file has been selected.    -#
#-------------------------------------------------------#
if [ "$FILE_VALUE" = '' ]; then
    error "No network file selected." "$LINENO" "`basename $0`"
    usage
    exit 1
fi



#----------------------------------------------------------------#
#-      Make sure the network file has the proper extension.    -#
#----------------------------------------------------------------#
if [ "`echo $FILE_VALUE | sed -n '/.*\.llnms-network\.xml/ p'`" = '' ]; then
    warning "File ($FILE_VALUE) does not have the proper .llnms-network.xml extension." "$LINENO" "`basename $0`"
fi


#-------------------------------------------#
#-      Print the name if requested        -#
#-------------------------------------------#
if [ "$PRINT_ALL" = '1' -o "$PRINT_NAME" = '1' ]; then
    printf "`xmlstarlet sel -t -m '//llnms-network' -v 'name' -n $FILE_VALUE`"
fi


#------------------------------------------------#
#-         Print the Starting Address           -#
#------------------------------------------------#
if [ "$PRINT_ALL" = '1' ]; then
    printf ', '
fi
if [ "$PRINT_ALL" = '1' -o "$PRINT_ADDRESS_START" = '1' ]; then
    printf "`xmlstarlet sel -t -m '//llnms-network' -v 'address-start' -n $FILE_VALUE`"
fi


#------------------------------------------------#
#-          Print the ending address            -#
#------------------------------------------------#
if [ "$PRINT_ALL" = '1' ]; then
    printf ', '
fi
if [ "$PRINT_ALL" = '1' -o "$PRINT_ADDRESS_END"   = '1' ]; then
    printf "`xmlstarlet sel -t -m '//llnms-network' -v 'address-end' -n $FILE_VALUE`"
fi
printf "\n"

