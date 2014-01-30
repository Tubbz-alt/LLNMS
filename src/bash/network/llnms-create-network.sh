#!/bin/bash
#
#    File:    llnms-add-network.bash
#    Author:  Marvin Smith
#    Date:    12/13/2013
#
#    Purpose:  This program will add a network to the system.
#

ERROR_NO_FLAGS_PROVIDED=2
ERROR_ADDR_START_FLAG_INVALID_FORMAT=3
ERROR_ADDR_END_FLAG_INVALID_FORMAT=4

#-------------------------------------#
#-     Print usage instructions      -#
#-------------------------------------#
usage(){

    echo "$0 [options]"
    echo ''
    echo '    options:'
    echo '        -h, --help             : Print usage instructions'
    echo '        -v, --version          : Print version information' 
    echo '        -i, --interactive      : use the interactive wizard to configure network'
    echo '        -o [output file]       : Save the file to the specified filename.'
    echo '                                 Otherwise a random file will be generated.'
    echo '        -n, --name [New Name]  : Set the name of the network'
    echo '        -as, --address-start [address] : Starting address in the range'
    echo '        -ae, --address-end   [address] : Ending address in the range'
    echo ''
    echo '    return values:'
    echo "        $ERROR_NO_FLAGS_PROVIDED : Not enough flags were provided."
    echo "        $ERROR_ADDR_START_FLAG_INVALID_FORMAT : address-start flag is in invalid format"
    echo "        $ERROR_ADDR_END_FLAG_INVALID_FORMAT : address-end flag is in invalid format"
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

        # Query for the network type
        clear
        echo "Add network definition to $NETWORK_NAME"
        echo '-------------------------------'
        echo ''
            
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
        
        # Review our changes
        clear
        echo 'Network Definition Review'
        echo '-------------------------'
        echo "Starting IP Address: $ADDRESS_START"
        echo "Ending IP Address:   $ADDRESS_END"
        echo ''
        echo -n 'Do you wish to add the network? (y/n - default): '
        read ANS

        if [ "$ANS" == 'y' -o "$ANS" == 'Y' ]; then
            OUTPUT+="       <address-start>$ADDRESS_START</address-start>\n"
            OUTPUT+="       <address-end>$ADDRESS_END</address-end>\n"
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


#  Import the version info
. $LLNMS_HOME/config/llnms-info


#  Import the configuration info
. $LLNMS_HOME/config/llnms-config


#  Desired name
NETWORK_NAME=''
NAME_FLAG=0

#  Desired starting address
ADDR_START_FLAG=0
ADDR_START_VALUE=''

#  Desired Ending Address
ADDR_END_FLAG=0
ADDR_END_VALUE=''

#  Interactive option
INTERACTIVE_FLAG=0

#  File parameters
FILE_FLAG=0
OUTPUT_FILENAME="$LLNMS_HOME/networks/$(date +"%Y%m%d_%H%M%S_%N").llnms-network.xml"


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
        
        # add a network starting address
        '-as' )
            ADDR_START_FLAG=1
            ;;
        
        # add a network ending address
        '-ae' )
            ADDR_END_FLAG=1
            ;;

        # set the output file
        '-o' )
            FILE_FLAG=1
            ;;

        # Otherwise, parse flags or throw an error
        *)
           
            #  If name flag set, grab flag
            if [ $NAME_FLAG -eq 1 ]; then
                NAME_FLAG=0
                NETWORK_NAME="$OPTION"
            
            #  If address start flag is set
            elif [ $ADDR_START_FLAG -eq 1 ]; then
                ADDR_START_FLAG=0
                ADDR_START_VALUE=$OPTION
            
            #  If address end flag is set
            elif [ $ADDR_END_FLAG -eq 1 ]; then
                ADDR_END_FLAG=0
                ADDR_END_VALUE=$OPTION

            # if the output filename is set
            elif [ $FILE_FLAG -eq 1 ]; then
                FILE_FLAG=0
                OUTPUT_FILENAME=$OPTION

            #  otherwise throw an error
            else
                echo "error: unknown flag $OPTION"
                exit 1
            fi

            ;;

    
    esac

done


#----------------------------------------------------------------------------------#
#-     Make sure that either interactive is set or the other flags are set        -#
#----------------------------------------------------------------------------------#
if [ ! "$INTERACTIVE_FLAG" = '1' ]; then
    if [ "$NETWORK_NAME" = '' -o "$ADDR_START_FLAG" = '' -o "$ADDR_END_FLAG" = '' ]; then
        error "Either interactive mode must be set or all network flags must be provided." "$LINENO"
        exit $ERROR_NO_FLAGS_PROVIDED
    fi
fi


#-------------------------------------------------------------------------#
#-       Make sure the input addresses are in the correct format         -#
#-------------------------------------------------------------------------#
if [ ! "$ADDR_START_VALUE" = '' ]; then
    if [ ! "$(echo $ADDR_START_VALUE | sed 's/^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$//g')" == "" ]; then
        error "The address-start flag must be in a proper ip4 address format." "$LINENO"
        exit $ERROR_ADDR_START_FLAG_INVALID_FORMAT
    else
        ADDRESS_START=$ADDR_START_VALUE
    fi

fi

if [ ! "$ADDR_END_VALUE" = '' ]; then
    if [ ! "$(echo $ADDR_END_VALUE | sed 's/^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$//g')" == "" ]; then
        error "The address-end flag must be in a proper ip4 address format." "$LINENO"
        exit $ERROR_ADDR_END_FLAG_INVALID_FORMAT
    else    
        ADDRESS_END=$ADDR_END_VALUE
    fi
fi


#-------------------------------------------#
#-       Start Processing the Output       -#
#-------------------------------------------#
#  Create output
OUTPUT='<llnms-network>\n'

#  Add the network name
if [ $INTERACTIVE_FLAG -eq 1 ]; then get_input_network_name; fi
OUTPUT+="  <name>$NETWORK_NAME</name>\n"



#  Add each network
if [ $INTERACTIVE_FLAG -eq 1 ]; then 
    get_input_networks;
else
    # create network 
    OUTPUT+="  <address-start>$ADDRESS_START</address-start>\n"
    OUTPUT+="  <address-end>$ADDRESS_END</address-end>\n"
fi

# Close off the output
OUTPUT+="</llnms-network>\n"

#  Modify IFS to print spaces properly
OLDIFS="$IFS"
IFS=""

#  Print data to file
printf $OUTPUT > $OUTPUT_FILENAME

#  Fix IFS
IFS=$OLDIFS



