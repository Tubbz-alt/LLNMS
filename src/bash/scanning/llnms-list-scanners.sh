#!/bin/sh
#
#  File:   llnms-list-scanners.sh
#  Author: Marvin Smith
#  Date:   12/13/2013
#


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
    echo '        Printing Information (Select one or more)'
    echo '        -a, --all          : Print everything (Default)'
    echo '        -i, --id           : Print id'
    echo '        -n, --name         : Print name'
    echo '        -d, --description  : Print description'
    echo '        -c, --command      : Print the required command.' 
    echo '        -f, --file         : Print the scanner filename.'
    echo '' 
    echo '        Printing Format'
    echo '        -p, --pretty  : Print data in human-readible format (Default)'
    echo '        -l, --list    : Print data in list format.'
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

#-----------------------------------------------#
#-      Create a registered scanners file      -#
#-----------------------------------------------#
llnms_create_registered_scanners_file(){

    #  Create the output xml headers
    OUTPUT="<llnms-registered-scanners>\n"
    
    #  Create the output xml footers
    OUTPUT+="</llnms-registered-scanners>\n"

    #  Output to file
    OLDIFS=$IFS
    IFS=''
    printf $OUTPUT > "$LLNMS_HOME/run/llnms-registered-scanners.xml"
    IFS=$OLDIFS


}

#--------------------------------------------------#
#-      Print all registered scanner paths        -#
#--------------------------------------------------#
llnms_list_registered_scanner_paths(){
    xmlstarlet sel -t -m '//llnms-registered-scanners/llnms-scanner' -n -v '.' $LLNMS_HOME/run/llnms-registered-scanners.xml
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

#  Import the configuration
. $LLNMS_HOME/config/llnms-config


#  Detail flag
PRINT_EVERYTHING=1
PRINT_ID=0
PRINT_NAME=0
PRINT_DESCRIPTION=0
PRINT_COMMAND=0
PRINT_FILE=0


#  Output format flag
#  PRETTY - Pretty output format
#  LIST   - List output format
OUTPUT_FORMAT='PRETTY'


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

        #  Set output format to pretty
        '-p' | '--pretty' )
            OUTPUT_FORMAT='PRETTY'
            ;;

        #  Set output format to list
        '-l' | '--list' )
            OUTPUT_FORMAT="LIST"
            ;;
        
        #  Print everything
        '-a' | '--all' )
            PRINT_EVERYTHING=1
            ;;

        #  Print id
        '-i' | '--id' )
            PRINT_ID=1
            PRINT_EVERYTHING=0
            ;;

        #  Print name
        '-n' | '--name' )
            PRINT_NAME=1
            PRINT_EVERYTHING=0
            ;;

        #  Print description
        '-d' | '--description' )
            PRINT_DESCRIPTION=1
            PRINT_EVERYTHING=0
            ;;

        #  Print command
        '-c' | '--command' )
            PRINT_COMMAND=1
            PRINT_EVERYTHING=0
            ;;

        #  Print file
        '-f' | '--file' )
            PRINT_FILE=1
            PRINT_EVERYTHING=0
            ;;

        #  Otherwise there is an error or we are pulling values
        *)

            #  Otherwise, there is an error
            #else
                error "unknown option $OPTION"
                exit 1
            #fi

            ;;
        
    esac
done


#---------------------------------------------------------------------------#
#-     Make sure registered scanner list exists.  If not, then create.     -#
#---------------------------------------------------------------------------#
if [ ! -e "$LLNMS_HOME/run/llnms-registered-scanners.xml" ]; then
    llnms_create_registered_scanners_file
fi

#  Print the header if in pretty format
if [ "$OUTPUT_FORMAT" = 'PRETTY' ]; then
    echo 'LLNMS Registered Scanners'
    echo '-------------------------'
    echo ''
fi

#  Grab a list of all scanners
SCANNER_PATHS="`llnms_list_registered_scanner_paths`"

#  Iterate over each scanner, printing the desired information
for SCANNER in $SCANNER_PATHS; do
    
    DATA_PRINTED=0

    #  print the name
    if [ "$OUTPUT_FORMAT" = 'PRETTY' ]; then
        echo " -> Scanner: `llnms-print-scanner-info -f $SCANNER -n`"
    elif [ "$PRINT_EVERYTHING" = '1' -o "$PRINT_NAME" = '1' ]; then
        if [ "$OUTPUT_FORMAT" = 'LIST' ]; then
            printf "`llnms-print-scanner-info -f $SCANNER -n`"
            DATA_PRINTED=1
        fi
    fi
    
    #  Print the filename
    if [ "$PRINT_EVERYTHING" = '1' -o "$PRINT_FILE" = '1' ]; then
        if [ "$OUTPUT_FORMAT" = "PRETTY" ]; then
            echo "    File: $SCANNER"
        elif [ "$OUTPUT_FORMAT" = "LIST" ]; then
            if [ "$DATA_PRINTED" = '1' ]; then
                printf ", "
            fi
            printf "$SCANNER"
            DATA_PRINTED=1
        fi
    fi

    #  Print the id
    if [ "$PRINT_EVERYTHING" = '1' -o "$PRINT_ID" = '1' ]; then
        if [ "$OUTPUT_FORMAT" = 'PRETTY' ]; then
            echo "    ID: `llnms-print-scanner-info -f $SCANNER -i`"
         elif [ "$OUTPUT_FORMAT" = 'LIST' ]; then
            if [ "$DATA_PRINTED" = '1' ]; then
                printf ", "
            fi
            printf "`llnms-print-scanner-info -f $SCANNER -i`"
            DATA_PRINTED=1
         fi
    fi
    
    #  Print the description
    if [ "$PRINT_EVERYTHING" = '1' -o "$PRINT_DESCRIPTION" = '1' ]; then
        if [ "$OUTPUT_FORMAT" = 'PRETTY' ]; then
            echo "    Description: `llnms-print-scanner-info -f $SCANNER -d`"
        elif [ "$OUTPUT_FORMAT" = 'LIST' ]; then
            if [ "$DATA_PRINTED" = '1' ]; then
                printf ", "
            fi
            printf "`llnms-print-scanner-info -f $SCANNER -d`"
            DATA_PRINTED=1
        fi
    fi


    #  Print ending blank line
    if [ "$OUTPUT_FORMAT" = 'LIST' ]; then
        echo ''
    elif [ "$OUTPUT_FORMAT" = 'PRETTY' ]; then
        echo ''
    fi


done

