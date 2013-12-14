#!/bin/bash
#
#    File:    llnms-add-network.bash
#    Author:  Marvin Smith
#    Date:    12/13/2013
#
#    Purpose:  This program will add a network to the system.
#


#-------------------------------------#
#-     Print usage instructions      -#
#-------------------------------------#
usage(){

    echo "$0 [options]"
    echo ''
    echo '    options:'
    echo '        -h, --help             : Print usage instructions'
    echo '        -i, --interactive      : use the interactive wizard to configure network'
    echo '        -o [output file]       : Save the file to the specified filename.'
    echo '                                 Otherwise a random file will be generated.'
    echo '        -n, --name [New Name]  : Set the name of the network'
    echo '        -net TYPE:ADDRESS:ADDRESS : Add a network definition'
    echo '            NOTE: Single Addresses will resemble  SINGLE:127.0.0.1'
    echo '                  Range Addresses will resemble RANGE:192.168.0.1:192.168.0.254'
    echo ''

}


#--------------------------------------------#
#-      Get user input for network name     -#
#--------------------------------------------#
get_input_network_name(){
     
     while [ "$NETWORK_NAME" == "" ]; do
        NEW_NAME=''
        clear
        echo -n 'Enter desired network name: '
        read NEW_NAME

        echo -n "Do you wish to set the network name to \"$NEW_NAME\"? (y/n - default): "
        read ANS
        if [ "$ANS" == 'y' -o "$ANS" == 'Y' ]; then
            NETWORK_NAME=$NEW_NAME
        fi
        
    done
    
}


#-------------------------------------------#
#-       Get user input for networks       -#
#-------------------------------------------#
get_input_networks(){

    #  Start network loop
    EXIT_LOOP=0
    while [ $EXIT_LOOP -ne 1 ]; do
       

        #  start type loop
        TEMP_TYPE=''
        EXIT_TYPE_LOOP=0
        while [ $EXIT_TYPE_LOOP -ne 1 ]; do

            # Query for the network type
            clear
            echo "Add network definition to $NETWORK_NAME"
            echo '-------------------------------'
            echo ''
            echo 'Enter desired network type'
            echo '1. SINGLE - Single IP address'
            echo '2. RANGE  - Range of IP addresses'
            echo -n 'Selection: '
            read ANS
        
            # make sure we have acceptable output
            if [ "$ANS" == '1' ]; then 
                TEMP_TYPE='SINGLE'
                EXIT_TYPE_LOOP=1
            elif [ "$ANS" == '2' ]; then 
                TEMP_TYPE='RANGE'
                EXIT_TYPE_LOOP=1
            else
                echo 'error: not valid option'
            fi
        done # end of type loop
    
        #  Add the ip address for single
        if [ "$TEMP_TYPE" == "SINGLE" ]; then
            
            #  Start the address loop
            EXIT_ADDR_LOOP=0
            while [ $EXIT_ADDR_LOOP -ne 1 ]; do
                
                #  ask for the ip address
                echo -n 'Enter the desired IP address: '
                read ANS

                #  make sure it fits the pattern
                if [ "$(echo $ANS | sed 's/^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$//g')" == "" ]; then
                    ADDRESS=$ANS
                    EXIT_ADDR_LOOP=1
                fi
            done

        # add the addresses for range
        else
            
            #  Start the address loop
            EXIT_ADDR_LOOP=0
            while [ $EXIT_ADDR_LOOP -ne 1 ]; do
                
                #  ask for the ip address
                echo -n 'Enter the desired starting IP address: '
                read ANS

                #  make sure it fits the pattern
                if [ "$(echo $ANS | sed 's/^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$//g')" == "" ]; then
                    ADDRESS_START=$ANS
                    EXIT_ADDR_LOOP=1
                fi

            done
            
            #  Start the address loop
            EXIT_ADDR_LOOP=0
            while [ $EXIT_ADDR_LOOP -ne 1 ]; do
                
                #  ask for the ip address
                echo -n 'Enter the desired ending IP address: '
                read ANS

                #  make sure it fits the pattern
                if [ "$(echo $ANS | sed 's/^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$//g')" == "" ]; then
                    ADDRESS_END=$ANS
                    EXIT_ADDR_LOOP=1
                fi

            done

        fi

        
        # Review our changes
        clear
        echo 'Network Definition Review'
        echo '-------------------------'
        echo "Type: $TEMP_TYPE"
        if [ "$TEMP_TYPE" == "SINGLE" ]; then
            echo "IP Address: $ADDRESS"
        else
            echo "Starting IP Address: $ADDRESS_START"
            echo "Ending IP Address:   $ADDRESS_END"
        fi
        echo -n 'Do you wish to add the network? (y/n - default): '
        read ANS

        if [ "$ANS" == 'y' -o "$ANS" == 'Y' ]; then
            echo 'adding definition'
            OUTPUT+='    <network>\n'
            OUTPUT+="       <type>$TEMP_TYPE</type>\n"
            
            if [ "$TEMP_TYPE" == "SINGLE" ]; then
                OUTPUT+="       <address>$ADDRESS</address>\n"
            else
                OUTPUT+="       <address-start>$ADDRESS_START</address-start>\n"
                OUTPUT+="       <address-end>$ADDRESS_END</address-end>\n"
            fi
            OUTPUT+='    </network>\n'
        fi

        #  Ask if we want to continue
        echo -n 'Do you wish to add additional network definitions? (y/n - default): '
        read ANS
        if [ "$ANS" == 'n' -o "$ANS" == 'N' ]; then
            EXIT_LOOP=1
        else
            EXIT_LOOP=0
        fi



    done
}

#---------------------------------#
#-          Main Function        -#
#---------------------------------#


#  Source llnms home
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi

#  Desired name
NETWORK_NAME=''
NAME_FLAG=0

#  Interactive option
INTERACTIVE_FLAG=0

#  Network flag
NET_FLAG=0
DEFINITIONS=''

#  Parse command-line options
for OPTION in "$@"; do

    case $OPTION in 
       
        #  Print usage instructions
        '-h' | '--help' )
            usage
            exit 1
            ;;
        
        #  Set the name
        '-n' | '--name')
            NAME_FLAG=1
            ;;
        
        # set the interactive flag
        '-i' | '--interactive' )
            INTERACTIVE_FLAG=1
            ;;
        
        # add a network definition
        '-net' )
            NET_FLAG=1
            ;;

        # Otherwise, parse flags or throw an error
        *)
           
            #  If name flag set, grab flag
            if [ $NAME_FLAG -eq 1 ]; then
                NAME_FLAG=0
                NETWORK_NAME="$OPTION"
            
            #  If net flag is set
            elif [ $NET_FLAG -eq 1 ]; then
                NET_FLAG=0
                DEFINITIONS+=" $OPTION"
                
            #  otherwise throw an error
            else
                echo "error: unknown flag $OPTION"
                exit 1
            fi

            ;;

    
    esac

done


#  Create output
OUTPUT='<llnms-network>\n'

#  Add the network name
if [ $INTERACTIVE_FLAG -eq 1 ]; then get_input_network_name; fi
OUTPUT+="  <name>$NETWORK_NAME</name>\n"



#  Add each network
OUTPUT+='  <networks>\n'

if [ $INTERACTIVE_FLAG -eq 1 ]; then 
    get_input_networks;
else
    
    for DEF in $DEFINITIONS; do
        
        # modify the ifs var
        OLDIFS="$IFS"
        IFS=":"
        
        # create temp array
        read -ra STUFF <<< "$DEF"
        
        # return the ifs
        IFS=$OLDIFS
        
        TEMP_TYPE="${STUFF[0]}"
        if [ "$TEMP_TYPE" == "SINGLE" ]; then 
            ADDRESS="${STUFF[1]}"
        else        
            ADDRESS_START="${STUFF[1]}"
            ADDRESS_END="${STUFF[2]}"
        fi
        
        # create network 
        OUTPUT+='    <network>\n'
        if [ "$TEMP_TYPE" == "SINGLE" ]; then 
            OUTPUT+='      <type>SINGLE</type>\n'
            OUTPUT+="      <address>$ADDRESS</address>\n"
        else  
            OUTPUT+='      <type>RANGE</type>\n'
            OUTPUT+="      <address-start>$ADDRESS_START</address-start>\n"
            OUTPUT+="      <address-end>$ADDRESS_END</address-end>\n"
        fi
        OUTPUT+='    </network>\n'
    done
fi
OUTPUT+='  </networks>\n'

# Close off the output
OUTPUT+='</llnms-network>'

#  Modify IFS to print spaces properly
OLDIFS="$IFS"
IFS=""

#  Print data to file
echo -e $OUTPUT > '/var/tmp/llnms/networks/test-network.llnms-network.xml'

#  Fix IFS
IFS=$OLDIFS


