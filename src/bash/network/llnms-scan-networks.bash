#!/bin/bash


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

}

#-------------------------------------#
#           Version Function          #
#-------------------------------------#
version(){

    echo "$0 Information"
    echo ''
    echo "   LLNMS Version ${LLNMS_MAJOR}.${LLNMS_MINOR}.${LLNMS_SUBMINOR}"

}



#---------------------------------#
#         Main Functions          #
#---------------------------------#

#  Source llnms home
if [ "$LLNMS_HOME" == "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi


#  Import the version info
source $LLNMS_HOME/config/llnms-info.sh
source $LLNMS_HOME/bin/llnms-network-utilities.bash


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

        #  Print Error
        *)
            error "Unknown option $OPTION"
            ;;

    esac
done


#-----------------------------------------#
#-   Configure the Network Status File   -#
#-----------------------------------------#

#    Create an empty network status file if it does not exist
if [ ! -f "$LLNMS_HOME/run/llnms-network-status.txt" ]; then
    llnms-create-empty-network-status-file
fi


#-------------------------------------------#
#      Get a list of networks to scan       #
#-------------------------------------------#

#  Get the network count
LLNMS_NETWORK_FILES=$(ls $LLNMS_HOME/networks)

#  For each network
for NETWORK in $LLNMS_NETWORK_FILES; do

    #  Get the full path of the network file
    NETWORK_FILE="$LLNMS_HOME/networks/$NETWORK"

    #  Grab the number of networks
    NETWORK_DEF_CNT=$(llnms-count-network-definitions $NETWORK_FILE)
    
    #  Iterate through each network definition
    RANGE_CNT=1
    SINGLE_CNT=1
    for (( x=1; x<= $NETWORK_DEF_CNT; x++ )); do
        
        #  Get the type
        DEF_TYPE=$(llnms-get-network-type $NETWORK_FILE $x)

        #  If single, grab the address
        if [ "$DEF_TYPE" == "SINGLE" ]; then

            #  Get the address
            ADDRESS=$(llnms-get-network-address $NETWORK_FILE $SINGLE_CNT )

            #  Make sure address exists inside the table
            llnms-check-network-status-and-add-ip-entry $ADDRESS 
            
            #  Ping the address
            llnms-ping-network-address $ADDRESS

            #  Increment the single count
            SINGLE_CNT=$((($SINGLE_CNT + 1)))

        #  If a range, grab the range
        elif [ "$DEF_TYPE" == "RANGE" ]; then
            
            #  Get the address start and end
            ADDRESS_BEG=$(llnms-get-network-address-start $NETWORK_FILE $RANGE_CNT )
            ADDRESS_END=$(llnms-get-network-address-end   $NETWORK_FILE $RANGE_CNT )
            
            ADDR_BEG_0=$(echo $ADDRESS_BEG | cut -d '.' -f 1)
            ADDR_END_0=$(echo $ADDRESS_END | cut -d '.' -f 1)
            ADDR_BEG_1=$(echo $ADDRESS_BEG | cut -d '.' -f 2)
            ADDR_END_1=$(echo $ADDRESS_END | cut -d '.' -f 2)
            ADDR_BEG_2=$(echo $ADDRESS_BEG | cut -d '.' -f 3)
            ADDR_END_2=$(echo $ADDRESS_END | cut -d '.' -f 3)
            ADDR_BEG_3=$(echo $ADDRESS_BEG | cut -d '.' -f 4)
            ADDR_END_3=$(echo $ADDRESS_END | cut -d '.' -f 4)

            for (( a=$ADDR_BEG_0; a<=$ADDR_END_0; a++ )); do
            for (( b=$ADDR_BEG_1; b<=$ADDR_END_1; b++ )); do
            for (( c=$ADDR_BEG_2; c<=$ADDR_END_2; c++ )); do
            for (( d=$ADDR_BEG_3; d<=$ADDR_END_3; d++ )); do
                
                # Create the address
                ADDRESS=${a}.${b}.${c}.${d}
                
                #  Make sure address exists inside the table
                llnms-check-network-status-and-add-ip-entry $ADDRESS 
            
                #  Ping the address
                llnms-ping-network-address $ADDRESS

            
            done
            done
            done
            done

            # Increment the range counter
            RANGE_CNT=$((($RANGE_CNT + 1)))

        # Otherwise we have a problem
        else
            echo "error: Unknown network definition type of $DEF_TYPE for file $NETWORK_FILE"
            exit 1
        fi

    done

done

