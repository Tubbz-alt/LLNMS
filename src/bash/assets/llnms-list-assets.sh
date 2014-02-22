#!/bin/sh
#
#   File:    llnms-list-assets.sh
#   Author:  Marvin Smith
#   Date:    12/10/2013
#
#   Purpose:  Returns a list of LLNMS assets.
#

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
    echo '        Formatting Options (Select only ONE of the following)'
    echo '        -p, --pretty  :  Print in human-readible format (Default)'
    echo '        -l, --list    :  Print in list format.'
    echo ''
    echo '        Data to print (Note:  One or more combinations is acceptable)'
    echo '        -a, --all            :  Print all asset information. (Default)'
    echo '        -host, --host        :  Print hostname.'
    echo '        -ip4, --ip4-address  :  Print the IP4 Address.'
    echo '        -d, --description    :  Print the description.'
    echo '        -s, --scanners       :  Print registered scanners.'
    echo '        -path, --pathname    :  Print full pathname.'
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
. $LLNMS_HOME/config/llnms-info

#  Output Format
#  PRETTY : Pretty format
#  LIST   : List format
OUTPUT_FORMAT='PRETTY'


#Print options
PRINT_EVERYTHING=1
PRINT_HOSTNAME=0
PRINT_IP4ADDRESS=0
PRINT_DESCRIPTION=0
PRINT_SCANNERS=0
PRINT_PATHNAME=0

#   Parse Command-Line Options
for OPTION in $@; do

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
        
        #  Set pretty format
        '-p' | '--pretty' )
            OUTPUT_FORMAT='PRETTY'
            ;;

        #  Set List format
        '-l' | '--list' )
            OUTPUT_FORMAT='LIST'
            ;;
        
        #  Print everything
        '-a' | '--all' )
            PRINT_EVERYTHING=1
            ;;

        #  Print hostname
        '-host' | '--hostname' )
            PRINT_EVERYTHING=0
            PRINT_HOSTNAME=1
            ;;

        #  Print ip4 address
        '-ip4' | '--ip4-address' )
            PRINT_EVERYTHING=0
            PRINT_IP4ADDRESS=1
            ;;
        
        #  Print description
        '-d' | '--description' )
            PRINT_EVERYTHING=0
            PRINT_DESCRIPTION=1
            ;;

        #  Print scanners
        '-s' | '--scanners' )
            PRINT_EVERYTHING=0
            PRINT_SCANNERS=1
            ;;

        #  Print pathname
        '-path' | '--pathname' )
            PRINT_EVERYTHING=0
            PRINT_PATHNAME=1
            ;;

        #  Print error message
        *)
            error "Unknown option $OPTION" "$LINENO"
            usage
            exit 1
            ;;


    esac
done


# Print a header if in pretty format
if [ "$OUTPUT_FORMAT" = 'PRETTY' ]; then
    echo 'LLNMS Asset List'
    echo '----------------'
    echo ''
fi


#  Get a list of assets in the asset folder
ASSET_LIST=`ls $LLNMS_HOME/assets/*.llnms-asset.xml 2> /dev/null`
for ASSET_FILE in $ASSET_LIST; do
    

    DATA_PRINTED=0
    #  If we are in pretty format, print header
    if [ "$OUTPUT_FORMAT" = 'PRETTY' ]; then
        echo "- Asset,  Path: `basename $ASSET_FILE`"
    fi

    #  Print pathname
    if [ "$PRINT_EVERYTHING" = '1' -o "$PRINT_PATHNAME" = '1' ]; then
        if [ "$OUTPUT_FORMAT" = "LIST" ]; then
            printf "$ASSET_FILE"
            DATA_PRINTED=1
        fi
    fi

    #  Print Hostname
    if [ "$PRINT_EVERYTHING" = "1" -o "$PRINT_HOSTNAME" = "1" ]; then
        if [ "$OUTPUT_FORMAT" = "PRETTY" ]; then
            printf "      Hostname: `$LLNMS_HOME/bin/llnms-print-asset-info -host -f $ASSET_FILE`\n"
        elif [ "$OUTPUT_FORMAT" = "LIST" ]; then
            if [ "$DATA_PRINTED" = "1" ]; then
                printf " "
            fi
            printf "`$LLNMS_HOME/bin/llnms-print-asset-info -host -f $ASSET_FILE`"
            DATA_PRINTED=1
        fi
    fi


    #  Print IP4 Address
    if [ "$PRINT_EVERYTHING" = '1' -o "$PRINT_IP4ADDRESS" = '1' ]; then
        if [ "$OUTPUT_FORMAT" = "PRETTY" ]; then
            echo "      IP4 Address: `$LLNMS_HOME/bin/llnms-print-asset-info -ip4 -f $ASSET_FILE`"
        elif [ "$OUTPUT_FORMAT" = "LIST" ]; then
            if [ "$DATA_PRINTED" = "1" ]; then
                printf " "
            fi
            printf "`$LLNMS_HOME/bin/llnms-print-asset-info -ip4 -f $ASSET_FILE`"
            DATA_PRINTED=1
        fi
    fi
    
    
    #  Print description
    if [ "$PRINT_EVERYTHING" = "1" -o "$PRINT_DESCRIPTION" = '1' ]; then
        if [ "$OUTPUT_FORMAT" = "PRETTY" ]; then
            echo "      Description: `$LLNMS_HOME/bin/llnms-print-asset-info -d -f $ASSET_FILE`"
        elif [ "$OUTPUT_FORMAT" = "LIST" ]; then    
            if [ "$DATA_PRINTED" = '1' ]; then
                printf ' '
            fi
            printf "\"`$LLNMS_HOME/bin/llnms-print-asset-info -d -f $ASSET_FILE`\""
            DATA_PRINTED=1
        fi
    fi

    #  If we are done with the asset and in list output format, then start a new line
    if [ "$OUTPUT_FORMAT" = "LIST" ]; then
        echo ''
    fi

    #  Otherwise, if we are in prett format, create a new line
    if [ "$OUTPUT_FORMAT" = "PRETTY" ]; then
        echo ''
    fi

done



