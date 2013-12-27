#!/bin/sh
#
#   File:    llnms-print-asset-info.sh
#   Author:  Marvin Smith
#   Date:    12/26/2013
#
#   Purpose:  Prints information about the specified asset.
#


#----------------------------------------#
#-       Print Usage Instructions       -#
#----------------------------------------#
usage(){

    echo "`basename $0` [options] -f <asset-path>"
    echo ''
    echo '    Purpose: Print information relating to a specific asset file.'
    echo ''
    echo '    Options:'
    echo '        -h, --help    :  Print usage instructions'
    echo '        -v, --version :  Print version information'
    echo '        -f, --file [ *.llnms-asset.xml File] : Select asset file.'
    echo ''
    echo '    Information (Select only any combination of the following.  Note that multiple selections will be space-deliminated.)'
    echo '        -a, --all             : Print everything (Default).'
    echo '        -host, --hostname     : Print the hostname'
    echo '        -ip4,  --ip4-address  : Print the IP4 Address.'
    echo '        -d, --description     : Print the description.'
    echo '        -s, --scanners        : Print registered scanners.'
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


#---------------------------------#
#-         Main Function         -#
#---------------------------------#

#  Source llnms home
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi


#  Import the version info
. $LLNMS_HOME/config/llnms-info.sh

#  Import the configuration info
. $LLNMS_HOME/config/llnms-config.sh

#  Important flags
FILE_FLAG=0
FILE_VALUE=''

EVERYTHING_FLAG=1
HOSTNAME_FLAG=0
IP4ADDRESS_FLAG=0
DESCRIPTION_FLAG=0
SCANNER_FLAG=0


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
        
        #  Set the filename flag
        '-f' | '--filename' )
            FILE_FLAG=1
            ;;

        #  Set the print Hostname flag
        '-host' | '--hostname' )     
            HOSTNAME_FLAG=1
            EVERYTHING_FLAG=0
            ;;

        #  Set the print ip4 address flag
        '-ip4' | '--ip4-address' )
            IP4ADDRESS_FLAG=1
            EVERYTHING_FLAG=0
            ;;

        #  Set the print description flag
        '-d' | '--description' )
            DESCRIPTION_FLAG=1
            EVERYTHING_FLAG=0
            ;;
        
        #  Set the print scanner flag
        '-s' | '--scanners' )
            SCANNER_FLAG=1
            EVERYTHING_FLAG=0
            ;;

        #  Set the print everything flag
        '-a' | '--all' )
            EVERYTHING_FLAG=1
            ;;

        #  Process flag values or print error message
        *)
            
            #  If we need to grab the filename flag
            if [ "$FILE_FLAG" = "1" ]; then
                FILE_FLAG=0
                FILE_VALUE=$OPTION

            #  Otherwise, print an error message for an unknown option
            else
                error "Unknown option $OPTION"
                usage
                exit 1
            fi

            ;;


    esac
done


#------------------------------------------------------#
#-      Make sure an asset file has been selected.    -#
#------------------------------------------------------#
if [ "$FILE_VALUE" = '' ]; then
    error "No asset file selected." "$LINENO" "`basename $0`"
    usage
    exit 1
fi



#--------------------------------------------------------------#
#-      Make sure the asset file has the proper extension.    -#
#--------------------------------------------------------------#
if [ "`echo $FILE_VALUE | sed -n '/.*\.llnms-asset\.xml/ p'`" = '' ]; then
    warning "File ($FILE_VALUE) does not have the proper .llnms-asset.xml extension." "$LINENO" "`basename $0`"
fi


#----------------------------------------------#
#-      Start print specific information      -#
#----------------------------------------------#
DATA_PRINTED=0

#  Hostname
if [ "$HOSTNAME_FLAG" = '1' -o "$EVERYTHING_FLAG" = '1' ]; then
    echo "`xmlstarlet sel -t -m '//llnms-asset' -v 'hostname' -n $FILE_VALUE`\c"
    DATA_PRINTED=1
fi

#  IP4 Address
if [ "$IP4ADDRESS_FLAG" = '1' -o "$EVERYTHING_FLAG" = '1' ]; then

    if [ "$DATA_PRINTED" = '1' ]; then
        echo " \c"
    fi

    echo "`xmlstarlet sel -t -m '//llnms-asset' -v 'ip4-address' -n $FILE_VALUE`\c"
    DATA_PRINTED=1
fi

#  Description
if [ "$DESCRIPTION_FLAG" = '1' -o "$EVERYTHING_FLAG" = '1' ]; then
    if [ "$DATA_PRINTED" = '1' ]; then
        echo " \c"
    fi

    echo "`xmlstarlet sel -t -m '//llnms-asset' -v 'description' -n $FILE_VALUE`\c"
    DATA_PRINTED=1
fi

echo ''
