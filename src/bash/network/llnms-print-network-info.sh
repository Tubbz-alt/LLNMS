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
    echo '        -sc, --scanner : Print scanner list'
    echo '        -sac, --scanner-arg-cnt   [scanner-id]              : Print the number of arguments given the scanner id and the scanner-argument number.'
    echo '        -san, --scanner-arg-name  [scanner-id] [arg-number] : Print the scanner argument name given the scanner id and the scanner-argument number.'
    echo '        -sav, --scanner-arg-value [scanner-id] [arg-number] : Print the scanner argument value given the scanner id and the scanner-argument number.'
    echo ''
    echo '    Print Format:'
    echo '        -l, --list    : Print in list format.'
    echo '        -p, --pretty  : Print in pretty format. (DEFAULT)'
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


#--------------------------------#
#-      Get the Scanner ID      -#
#--------------------------------#
Get_Scanner_ID()
{
    #  find the index of the scanner id
    ID_LIST=`xmlstarlet sel -t -m '//llnms-network/scanners/scanner' -n -v 'id' $FILE_VALUE | sed '/^\s*$/d' | sed 's/ *//g'`

    #  Iterate over scanners, checking if the requested id matches
    TEMP_IDX=1
    ACTUAL_IDX=0
    for ID in $ID_LIST; do
        
        #  If the requested ID matches, set the index
        if [ "$ID" = "$1" ]; then
            ACTUAL_IDX=$TEMP_IDX

        #  Increment the counter
        else
            TEMP_IDX=`expr $TEMP_IDX + 1` 
        fi
    done

    echo "$ACTUAL_IDX"
}

#-------------------------------------------#
#-      Get the Scanner Argument Value     -#
#-------------------------------------------#
Get_Scanner_Argument_Value()
{
    #  Get the ID
    IDX="`Get_Scanner_ID $1`"

    # Get the Arg Number
    ARG_NO=$2
    
    #  Return the value
    echo "`xmlstarlet sel -t -m //llnms-network/scanners/scanner[$IDX]/argument[$ARG_NO] -n -v @value $FILE_VALUE | sed '/^\s*$/d' `"

}


#------------------------------------------#
#-      Get the Scanner Argument Name     -#
#------------------------------------------#
Get_Scanner_Argument_Name()
{
    #  Get the ID
    IDX="`Get_Scanner_ID $1`"

    # Get the Arg Number
    ARG_NO=$2
    
    #  Return the value
    echo "`xmlstarlet sel -t -m //llnms-network/scanners/scanner[$IDX]/argument[$ARG_NO] -n -v @name $FILE_VALUE | sed '/^\s*$/d' | sed 's/ *//g'` "
}


#------------------------------------------#
#-     Get the Scanner Argument Count     -#
#------------------------------------------#
Get_Scanner_Argument_Count()
{
    #  Get the ID
    IDX="`Get_Scanner_ID $1`"

    #  Get the value of the argument
    echo "`xmlstarlet sel -t -m //llnms-network/scanners/scanner[$IDX]/argument -n -v @value $FILE_VALUE | sed '/^\s*$/d' | wc -l | sed 's/ *//g'`"
}


#------------------------#
#-      Print Data      -#
#------------------------#
Print_Data()
{
    #  Get the format
    if [ "$FORMAT" = 'pretty' ]; then
        printf "%12s:  %-12s\n" "$2" "$1"
    else

        #  Add space for gap
        if [ "$DATA_PRINTED" = '1' ]; then
            printf " "
        fi

        #  Print content
        printf "$1"
    fi
}



#--------------------------------#
#-      Print Scanner Data      -#
#--------------------------------#
Print_Scanner_Data()
{
    #  Get the arguments
    IDX=$1
    SCANNER_NAME=$2
    ARG_CNT=$3

    #  Get the format
    if [ "$FORMAT" = 'pretty' ]; then
        #  Print the name and id
        printf  "%12s:  %-29s\n"  "Scanner" "$1"
        printf  "%20s  %-14s\n"  "-name    " "$2"
        
        # Iterate over arguments
        for ((X=1;X<=${ARG_CNT};X++)); do
            printf "%20s  %s" "-argument" "${ARG_NAMES[$X]}" 
            printf "  value: %-20s\n" "${ARG_VALUES[$X]}" 
        done

    else

        #  Add space for gap
        if [ "$DATA_PRINTED" = '1' ]; then
            printf " "
        fi

        #  Print content
        printf "$1"
    fi
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

SCANNER_FLAG=0

SCANNER_ARG_NAME_FLAG=0
SCANNER_ARG_VALUE_FLAG=0
SCANNER_ARG_COUNT_FLAG=0


SCANNER_ARG_ID_FLAG=0
SCANNER_ARG_NO_FLAG=0
SCANNER_ARG_ID=''
SCANNER_ARG_NO=''

FORMAT='list'


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
        
        #  Set the print scanner flag
        '-sc' | '--scanners' )
            SCANNER_FLAG=1
            PRINT_ALL=0
            ;;

        #  Set the scanner argument name flag
        '-san' | '--scanner-arg-name' )
            SCANNER_ARG_NAME_FLAG=1
            PRINT_ALL=0
            ;;

        #  set the scanner argument value flag
        '-sav' | '--scanner-arg-value' )
            SCANNER_ARG_VALUE_FLAG=1
            PRINT_ALL=0
            ;;
        #  set the scanner argument count flag
        '-sac' | '--scanner-arg-count' )
            SCANNER_ARG_COUNT_FLAG=1
            PRINT_ALL=0
            ;;
        
        #  Set to list format
        '-l' | '--list')
            FORMAT='list'
            ;;

        #  Set to pretty format
        '-p' | '--pretty')
            FORMAT='pretty'
            ;;

        #  Process flag values or print error message
        *)
            
            #   If the file flag has been set, grab the value
            if [ "$FILE_FLAG" = '1' ]; then
                FILE_VALUE=$OPTION
                FILE_FLAG=0
            
            #  If we need to grab the scanner id
            elif [ "$SCANNER_ARG_NAME_FLAG" = '1' -a "$SCANNER_ARG_ID_FLAG" = '0' ]; then
                SCANNER_ARG_ID=$OPTION
                SCANNER_ARG_ID_FLAG=1
            
            elif [ "$SCANNER_ARG_VALUE_FLAG" = '1' -a "$SCANNER_ARG_ID_FLAG" = '0' ]; then
                SCANNER_ARG_ID=$OPTION
                SCANNER_ARG_ID_FLAG=1
            
            elif [ "$SCANNER_ARG_COUNT_FLAG" = '1' -a "$SCANNER_ARG_ID_FLAG" = '0' ]; then
                SCANNER_ARG_ID=$OPTION
                SCANNER_ARG_ID_FLAG=1
            
            #  if we need to grab the scanner number
            elif [ "$SCANNER_ARG_NAME_FLAG" = '1' -a "$SCANNER_ARG_ID_FLAG" = '1' -a "$SCANNER_ARG_NO_FLAG" = '0' ]; then
                SCANNER_ARG_NO=$OPTION
                SCANNER_ARG_NO_FLAG=1
            
            elif [ "$SCANNER_ARG_VALUE_FLAG" = '1' -a "$SCANNER_ARG_ID_FLAG" = '1' -a "$SCANNER_ARG_NO_FLAG" = '0' ]; then
                SCANNER_ARG_NO=$OPTION
                SCANNER_ARG_NO_FLAG=1

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
    printf ' '
fi
if [ "$PRINT_ALL" = '1' -o "$PRINT_ADDRESS_START" = '1' ]; then
    printf "`xmlstarlet sel -t -m '//llnms-network' -v 'address-start' -n $FILE_VALUE`"
fi


#------------------------------------------------#
#-          Print the ending address            -#
#------------------------------------------------#
if [ "$PRINT_ALL" = '1' ]; then
    printf ' '
fi
if [ "$PRINT_ALL" = '1' -o "$PRINT_ADDRESS_END"   = '1' ]; then
    printf "`xmlstarlet sel -t -m '//llnms-network' -v 'address-end' -n $FILE_VALUE`"
fi
if [ "$FORMAT" = 'pretty' ]; then
    printf '\n'
fi


#-----------------------------------------#
#-        Print the Scanner Info         -#
#-----------------------------------------#
#  Scanners for everything flag
if [ "$PRINT_ALL" = '1' ]; then
    
    # Get the scanner list
    SCANNER_NAMES="`xmlstarlet sel -t -m '//llnms-network/scanners/scanner' -n -v '.' -n $FILE_VALUE | sed 's/ *//g' | sed '/^\s*$/d'`"

    #  Iterate
    for SCANNER_NAME in $SCANNER_NAMES; do
        
        #  Get the ID
        SCANNER_ID="`Get_Scanner_ID $SCANNER_NAME`"

        #  Get the Argument Count
        ARG_CNT=`Get_Scanner_Argument_Count $SCANNER_NAME`
        
        #  Iterate over each argument
        for ((X=1;X<=${ARG_CNT};X++)); do
        
            #  Get the argument name
            ARG_NAMES[$X]=`Get_Scanner_Argument_Name   $SCANNER_NAME  $X`
            ARG_VALUES[$X]=`Get_Scanner_Argument_Value $SCANNER_NAME  $X`
        done

        # Print
        Print_Scanner_Data $SCANNER_ID $SCANNER_NAME $ARG_CNT
    done
fi

#  Scanners
if [ "$SCANNER_FLAG" = '1' ]; then
    
    # Get the scanner list
    SCANNER_NAMES="`xmlstarlet sel -t -m '//llnms-network/scanners/scanner' -n -v '.' -n $FILE_VALUE | sed 's/ *//g' | sed '/^\s*$/d'`"

    #  Iterate
    for SCANNER_NAME in $SCANNER_NAMES; do
        Print_Data "$SCANNER_NAME" 'Scanners'
        DATA_PRINTED=1
    done
fi

#  Scanner argument name
if [ "$SCANNER_ARG_NAME_FLAG" = '1' ]; then
    PRINT_INFO=`Get_Scanner_Argument_Name $SCANNER_ARG_ID $SCANNER_ARG_NO`
    Print_Data $PRINT_INFO 'Scanner Argument Name'
    DATA_PRINTED=1
fi


#  Scanner Argument Value
if [ "$SCANNER_ARG_VALUE_FLAG" = '1' ]; then
    PRINT_INFO=`Get_Scanner_Argument_Value $SCANNER_ARG_ID $SCANNER_ARG_NO`
    Print_Data $PRINT_INFO 'Scanner Argument Value'
    DATA_PRINTED=1
fi

#  Scanner ARgument Count
if [ "$SCANNER_ARG_COUNT_FLAG" = '1' ]; then
    PRINT_INFO=`Get_Scanner_Argument_Count $SCANNER_ARG_ID`
    Print_Data $PRINT_INFO 'Scanner Argument Count'
    DATA_PRINTED=1
fi


echo ''

