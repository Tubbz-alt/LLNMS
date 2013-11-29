#!/bin/bash
# 
#   File:    llnms-list-networks.bash
#   Author:  Marvin Smith
#   Date:    11/23/2013
#

#-------------------------------#
#-     Usage Instructions      -#
#-------------------------------#
usage(){

    echo "usage $0 [options]"
    echo ""
    echo '   options:'
    echo '      -h | -help )  Print usage instructions'
    echo ''
    echo '      -p ) Print in a pretty, user-readable format(default)'
    echo '      -l ) Print in a list format suitable for piping'
    echo '      -debug ) Print debugging info with output'

}

#----------------------------#
#-      Main Function       -#
#----------------------------#

# Import default parameters
if [ "$LLNMS_HOME" == "" ]; then
    LLNMS_HOME=/var/tmp/llnms
fi

#  Import the utility script
source $LLNMS_HOME/bin/llnms-xmlstarlet-functions.bash
source $LLNMS_HOME/bin/llnms-network-utilities.bash

#  Set the default output format
OUTPUT_FORMAT="PRETTY"
DEBUG_STATE=0

#  Parse Command-Line Options
for OPTION in $@; do

    case $OPTION in
    
        #  Print usage instructions
        "-h" | "-help")
            usage
            exit 1
            ;;

        #  Format in pretty format
        "-p" )
            OUTPUT_FORMAT="PRETTY"
            ;;

        #  Format in a list
        "-l" )
            OUTPUT_FORMAT="LIST"
            ;;
        
        #  Set debugging state
        "-debug" )
            DEBUG_STATE=1
            ;;

        #  Print error for unknown option
        *)
            echo "Error: unknown option $OPTION"
            exit 1
            ;;

    esac

done

#  Print some debugging info
if [ "$DEBUG_STATE" == "1" ]; then
    if [ "$OUTPUT_FORMAT" == "LIST" ]; then
        echo "LLNMS_HOME=$LLNMS_HOME"
        echo "PS: $(llnms-ping-network-address 127.0.0.1)"
    fi
fi

#  make sure we have definitions in the network directory
NETWORK_DEFS=""
if [ ! "$(ls $LLNMS_HOME/networks/)" == "" ]; then
    NETWORK_DEFS=$(ls $LLNMS_HOME/networks/*.llnms-network.xml)
fi

export PATH=/opt/local/bin:$PATH


#  Pretty output
PRETTY_OUTPUT=""

#  If pretty output, print the number of network files
if [ "$OUTPUT_FORMAT" == "PRETTY" ]; then
    echo "Number of Networks Registered: $(ls $LLNMS_HOME/networks/*.xml | wc -l)"
else
    echo "NETWORK_FILE_COUNT:$(ls $LLNMS_HOME/networks/*.xml | wc -l | sed 's/ *//' )"
fi

#  Start iterating through each network definition
TOTAL_CNT=1
for DEF in $NETWORK_DEFS; do 
    
    #  These are the counts for the range and single types.  Make sure to keep these accurate
    RANGE_CNT=0
    SINGLE_CNT=0
    
    #  Get the name
    DEF_NAME="$(llnms-get-network-name $DEF)"

    #  Print the Name In a Table Format if pretty
    if [ "$OUTPUT_FORMAT" == "PRETTY" ]; then
        PRETTY_OUTPUT+="Network $TOTAL_CNT Name: $DEF_NAME\n"

    #  If in list form, print the id of the network with the name
    else
        #  print the number which we are in the list of networks 
        echo "NETWORK_${TOTAL_CNT}_NAME:$DEF_NAME"
    fi

    #  Get the list of network ranges
    DEF_NETWORK_CNT="$(llnms-count-network-definitions $DEF)"
    
    #  If in list form, print the count
    if [ "$OUTPUT_FORMAT" == "LIST" ]; then
        echo "NETWORK_${TOTAL_CNT}_NUM_DEFS:$DEF_NETWORK_CNT"
    fi

    #  For each network object, get the type
    for i in $(seq 1 $DEF_NETWORK_CNT); do
        
        #  Get the nth network type
        NETWORK_TYPE=$(llnms-get-network-type $DEF $i)
            
        #  If we are in a list format, then print now
        if [ "$OUTPUT_FORMAT" == "LIST" ]; then
            echo "NETWORK_${TOTAL_CNT}_DEF_$(($RANGE_CNT+$SINGLE_CNT+1))_TYPE:$NETWORK_TYPE"
        fi

        #  If we have a range object, then recover the address start and address end
        if [ "$NETWORK_TYPE" == "RANGE" ]; then
            
            #  Increment the range counter
            RANGE_CNT=$(($RANGE_CNT+1))

            NETWORK_ADDRESS_START=$(llnms-get-network-address-start $DEF $i $RANGE_CNT)
            NETWORK_ADDRESS_END=$(llnms-get-network-address-end $DEF $i  $RANGE_CNT)
           
            if [ "$OUTPUT_FORMAT" == "PRETTY" ]; then
                PRETTY_OUTPUT+="\t$NETWORK_ADDRESS_START\t$NETWORK_ADDRESS_END"
            else
                echo "NETWORK_${TOTAL_CNT}_DEF_$(($RANGE_CNT+$SINGLE_CNT))_ADDRESS_START:$NETWORK_ADDRESS_START"
                echo "NETWORK_${TOTAL_CNT}_DEF_$(($RANGE_CNT+$SINGLE_CNT))_ADDRESS_END:$NETWORK_ADDRESS_END"
            fi

        # Otherwise we have a single address
        else
            
            # Increment the single counter
            SINGLE_CNT=$(($SINGLE_CNT+1))

            NETWORK_ADDRESS=$(llnms-get-network-address $DEF $i $SINGLE_CNT)
            
            if [ "$OUTPUT_FORMAT" == "PRETTY" ]; then
                PRETTY_OUTPUT+="\t$NETWORK_ADDRESS"
            else
                echo "NETWORK_${TOTAL_CNT}_DEF_$(($RANGE_CNT+$SINGLE_CNT))_ADDRESS:$NETWORK_ADDRESS"
            fi

        fi
        
        PRETTY_OUTPUT+="\n"

    done
    
    TOTAL_CNT=$(($TOTAL_CNT+1))

done

if [ "$OUTPUT_FORMAT" == "PRETTY" ]; then
    printf "$PRETTY_OUTPUT" #| column -t -s $'\t'
fi

