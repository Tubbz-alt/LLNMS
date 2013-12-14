#!/bin/bash
#
#  file:    llnms-list-networks.bash
#  author:  Marvin Smith
#  date:    12/8/2013
#



#-------------------------------------#
#             Error Function          #
#-------------------------------------#
error(){
    echo "error $1"
    exit 1
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
    echo '         -x, --xml     :  Print in a XML format'
    echo '         -p, --pretty  :  Print in a human-readable format (DEFAULT)'

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
#           Main Function            -#
#-------------------------------------#

#  Source llnms home
if [ "$LLNMS_HOME" == "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi


#  Import the version info
source $LLNMS_HOME/config/llnms-info.sh

#  Import the network utilities
source $LLNMS_HOME/bin/llnms-xmlstarlet-functions.bash
source $LLNMS_HOME/bin/llnms-network-utilities.bash

#  Set the output format
OUTPUT_FORMAT="PRETTY"

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

        #  Set format to xml
        "-x" | "--xml" )
            OUTPUT_FORMAT="XML"
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

    
    # if xml, then print the header
    if [ "$OUTPUT_FORMAT" == "XML" ]; then
        OUTPUT+="    <network>\n"
    
    # if pretty, create a new list
    elif [ "$OUTPUT_FORMAT" == "PRETTY" ]; then
        echo "Network"
        echo '-------'
    fi

    #  Print the name
    NETWORK_NAME="$(llnms-get-network-name $NETWORK_FILE)"
    if [ "$OUTPUT_FORMAT" == "XML" ]; then
        OUTPUT+="        <name>$NETWORK_NAME</name>\n"
    elif [ "$OUTPUT_FORMAT" == "PRETTY" ]; then
        echo "Name: $NETWORK_NAME"
    fi
    
    # if xml, print the network definition lists
    if [ "$OUTPUT_FORMAT" == "XML" ]; then
        OUTPUT+="        <definitions>\n"
    # if pretty, just let the user know networks are coming next
    elif [ "$OUTPUT_FORMAT" == "PRETTY" ]; then
        echo 'Network Definitions'
    fi

    #  Print the different network definitions
    NETWORK_CNT="$(llnms-count-network-definitions $NETWORK_FILE)"
    RANGE_CNT=1
    SINGLE_CNT=1
    for ((x=0; x<$NETWORK_CNT; x++ )); do
        
        #  get the type of the specific network
        NETWORK_TYPE="$(llnms-get-network-type $NETWORK_FILE $((($x+1))))"
        
        # Get the addresses
        if [ "$NETWORK_TYPE" == "SINGLE" ]; then
            
            ADDRESS=$(llnms-get-network-address $NETWORK_FILE $SINGLE_CNT )
            
            #  Increment the single count
            SINGLE_CNT=$((($SINGLE_CNT + 1)))
        
        elif [ "$NETWORK_TYPE" == "RANGE" ]; then
            
            #  Get the address start and end
            ADDRESS_START=$(llnms-get-network-address-start $NETWORK_FILE $RANGE_CNT )
            ADDRESS_END=$(llnms-get-network-address-end   $NETWORK_FILE $RANGE_CNT )
            
            # Increment the range counter
            RANGE_CNT=$((($RANGE_CNT + 1)))

        fi
            
        # if xml, print everything in it
        if [ "$OUTPUT_FORMAT" == "XML" ]; then
            OUTPUT+="            <definition>\n"
            OUTPUT+="                <type>$NETWORK_TYPE</type>\n"
            if [ "$NETWORK_TYPE" == "SINGLE" ]; then
                OUTPUT+="                <address>$ADDRESS</address>\n"
            elif [ "$NETWORK_TYPE" == "RANGE" ]; then
                OUTPUT+="                <address-start>$ADDRESS_START</address-start>\n"
                OUTPUT+="                <address-end>$ADDRESS_END</address-end>\n"
            fi
            OUTPUT+="            </definition>\n"
        
        # if pretty, print in a list
        elif [ "$OUTPUT_FORMAT" == "PRETTY" ]; then
            if [ "$NETWORK_TYPE" == "SINGLE" ]; then
                echo "  - Type: $NETWORK_TYPE, Address: $ADDRESS"
            elif [ "$NETWORK_TYPE" == "RANGE" ]; then
                echo "  - Type: $NETWORK_TYPE, Address-Start: $ADDRESS_START, Address-End: $ADDRESS_END"
            fi
        fi
    done
    
    # if xml, print the network definition lists
    if [ "$OUTPUT_FORMAT" == "XML" ]; then
        OUTPUT+="        </definitions>\n"
    fi

    # if xml, then print the footer
    if [ "$OUTPUT_FORMAT" == "XML" ]; then
        OUTPUT+="    </network>\n"
    # if pretty, just print a space
    elif [ "$OUTPUT_FORMAT" == "PRETTY" ]; then
        echo ''
    fi
done


#  finish output if output type is xml
if [ "$OUTPUT_FORMAT" == "XML" ]; then
    OUTPUT+="</llnms-list-network-output>"
fi

# Output
OLDIFS=$IFS
IFS=''
echo -e $OUTPUT
IFS=$OLDIFS

