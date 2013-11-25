#!/bin/bash
#
#  Name:    llnms-start-network-scan.bash
#  Author:  Marvin Smith
#  Date:    11/24/2013
#
#


#-------------------------------#
#-      Usage Instructions     -#
#-------------------------------#
usage(){

    echo "usage: $0 [options]"
    echo ""
    echo "   options:"
    echo ""
    echo "      -h | -help) Print usage instructions"
}

#--------------------------------#
#-         Main Function        -#
#--------------------------------#


#  Process Command-Line Arguments
for OPTION in $@; do
    
    case $OPTION in 

        #  Print Usage Instructions
        "-h" | "-help" )
            usage
            exit 1
            ;;

        #  Otherwise print the error
        *)
            echo "Error: Unknown option $OPTION"
            exit 1
            ;;
    esac
done


ADDRESS_LIST=()
#  Get the number of current network definition files
NUM_NETWORK_FILES=$($LLNMS_HOME/bin/llnms-list-networks.bash -l | grep NETWORK_FILE_COUNT | cut -d ':' -f 2)

#  Iterate through each network file, checking that it matches the network-status-list
for i in `seq 1 $NUM_NETWORK_FILES`; do
    
    #  Grab the number of definitions
    DEF_CNT=$($LLNMS_HOME/bin/llnms-list-networks.bash -l | grep NETWORK_${i}_NUM_DEFS | cut -d ':' -f 2)
    
    #  Iterate through each definition
    for j in `seq 1 $DEF_CNT`; do
        
        echo start $i $j
        #  get the type
        DEF_TYPE=$($LLNMS_HOME/bin/llnms-list-networks.bash -l | grep NETWORK_${i}_DEF_${j}_TYPE | cut -d ':' -f 2)
        
        #  If it is a range type, then get the start and stop range
        if [ "$DEF_TYPE" == "RANGE" ]; then
            ADDR_START=$($LLNMS_HOME/bin/llnms-list-networks.bash -l | grep NETWORK_${i}_DEF_${j}_ADDRESS_START | cut -d ':' -f 2)
            ADDR_END=$($LLNMS_HOME/bin/llnms-list-networks.bash -l | grep NETWORK_${i}_DEF_${j}_ADDRESS_END | cut -d ':' -f 2)
            
            # decompose the addresses 
            ADDR1_START=$(echo $ADDR_START | cut -d '.' -f 1)
            ADDR2_START=$(echo $ADDR_START | cut -d '.' -f 2)
            ADDR3_START=$(echo $ADDR_START | cut -d '.' -f 3)
            ADDR4_START=$(echo $ADDR_START | cut -d '.' -f 4)
            ADDR1_END=$(echo $ADDR_END | cut -d '.' -f 1)
            ADDR2_END=$(echo $ADDR_END | cut -d '.' -f 2)
            ADDR3_END=$(echo $ADDR_END | cut -d '.' -f 3)
            ADDR4_END=$(echo $ADDR_END | cut -d '.' -f 4)
            
            for a in `seq $ADDR1_START $ADDR1_END`; do
            for b in `seq $ADDR2_START $ADDR2_END`; do
            for c in `seq $ADDR3_START $ADDR3_END`; do
            for d in `seq $ADDR4_START $ADDR4_END`; do
                echo $a.$b.$c.$d
            done
            done
            done
            done

        #  If it is a single type, then just get the address
        else
            ADDR=$($LLNMS_HOME/bin/llnms-list-networks.bash -l | grep NETWORK_${i}_DEF_${j}_ADDRESS | cut -d ':' -f 2)
            ADDRESS_LIST+=($ADDR)
        fi


            
    done
done

echo $ADDRESS_LIST
