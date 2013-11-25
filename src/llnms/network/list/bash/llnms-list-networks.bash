#!/bin/bash


#-------------------------------#
#-     Usage Instructions      -#
#-------------------------------#
usage(){

    echo "usage $0 [options]"
    echo ""
    echo '   options:'
    echo '      -h | -help )  Print usage instructions'

}

#----------------------------#
#-      Main Function       -#
#----------------------------#

# Import default parameters
if [ "$LLNMS_HOME" == "" ]; then
    LLNMS_HOME=/var/tmp/llnms
fi

#  Import the utility script
. $LLNMS_HOME/bin/llnms-xmlstarlet-functions.bash

#  Parse Command-Line Options
for OPTION in $@; do

    case $OPTION in
    
        "-h" | "-help")
            usage
            exit 1
            ;;
        
        *)
            echo "Error: unknown option $OPTION"
            exit 1
            ;;

    esac

done


#  make sure we have definitions in the network directory
NETWORK_DEFS=""
if [ ! "$(ls $LLNMS_HOME/networks/)" == "" ]; then
    NETWORK_DEFS=$(ls $LLNMS_HOME/networks/*.llnms-network.xml)
fi


#  For each definition, print the details
RANGE_CNT=0
SINGLE_CNT=0

OUTPUT=""
for DEF in $NETWORK_DEFS; do 
    
    #  Get the name
    DEF_NAME="$(llnms-get-network-name $DEF)"
    OUTPUT+="Network Name=$DEF_NAME\n"

    #  Get the list of network ranges
    DEF_NETWORK_CNT="$(llnms-count-network-definitions $DEF)"
    
    #  For each network object, get the type
    for i in $(seq 1 $DEF_NETWORK_CNT); do
        
        #  Get the nth network type
        NETWORK_TYPE=$(llnms-get-network-type $DEF $i)

        #  If we have a range object, then recover the address start and address end
        if [ "$NETWORK_TYPE" == "RANGE" ]; then
            
            #  Increment the range counter
            RANGE_CNT=$(($RANGE_CNT+1))

            NETWORK_ADDRESS_START=$(llnms-get-network-address-start $DEF $i $RANGE_CNT)
            NETWORK_ADDRESS_END=$(llnms-get-network-address-end $DEF $i  $RANGE_CNT)
            
            OUTPUT+="\t$NETWORK_ADDRESS_START\t$NETWORK_ADDRESS_END"

        # Otherwise we have a single address
        else
            
            # Increment the single counter
            SINGLE_CNT=$(($SINGLE_CNT+1))

            NETWORK_ADDRESS=$(llnms-get-network-address $DEF $i $SINGLE_CNT)
            OUTPUT+="\t$NETWORK_ADDRESS"
        fi
        
        OUTPUT+="\n"

    done

done

printf "$OUTPUT" | column -t -s $'\t'
