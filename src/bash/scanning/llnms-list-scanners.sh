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

    echo "$0 [options]"
    echo ''
    echo '    options:'
    echo '        -h, --help    : Print usage instructions'
    echo '        -v, --version : Print version information'
    echo '' 
    echo '        --names-only  : Print only the scanner names, no other info (Default)'
    echo ''
    echo '        Printing Format'
    echo '        -p, --pretty  : Print data in human-readible format (Default)'
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


#-------------------------------------#
#-           Main Function           -#
#-------------------------------------#

#  Source llnms home
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi


#  Import the version info
source $LLNMS_HOME/config/llnms-info.sh

#  Import the scanning utilities
source $LLNMS_HOME/bin/llnms_scanning_utilities.sh


#  Detail flag
#  0 - Print only names
PRINT_FLAG=0


#  Output format flag
#  PRETTY - Pretty output format
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
SCANNER_PATHS=$(llnms_list_registered_scanner_paths)

#  Iterate over each scanner, printing the desired information
for SCANNER in $SCANNER_PATHS; do
    
    #  print the name
    SCANNER_NAME=$(llnms_print_registered_scanner_name $SCANNER)
    echo "- ID: $(llnms_print_registered_scanner_id $SCANNER)"
    echo "  Name: $SCANNER_NAME"
    
    #  print the command
    SCANNER_CMD=$(llnms_print_registered_scanner_command $SCANNER)
    echo "  Command: $SCANNER_CMD"

    # print the description
    SCANNER_DESC=$(llnms_print_registered_scanner_description $SCANNER)
    echo "  Description: $SCANNER_DESC"

    #  Print ending blank line
    echo ''

done


