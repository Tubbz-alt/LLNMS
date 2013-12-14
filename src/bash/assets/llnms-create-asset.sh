#!/bin/sh
#
#  File:    llnms-create-asset.sh
#  Author:  Marvin Smith
#  Date:    12/13/2013
#
#

#----------------------------------------#
#-       Print Usage Instructions       -#
#----------------------------------------#
usage(){

    echo "$0 [options]"
    echo ''
    echo '    options:'
    echo '        -h, --help    :  Print usage instructions'
    echo '        -v, --version :  Print version information'
    echo ''
    echo '        -i, --interactive : Use the interactive mode'
    echo ''
    echo '        -host, --hostname [name] : Set the asset hostname'
    echo '        -ip4 [address]           : Set the IP4 address'
    echo '        -d, --description [text] : Set the description (optional)'
    echo ''
    echo '        -o   : Set the output filename.  Otherwise, a '
    echo '               filename will be generated.'

}


#-------------------------------------#
#             Error Function          #
#-------------------------------------#
error(){
    echo "error $1"
}


#-------------------------------------#
#           Version Function          #
#-------------------------------------#
version(){

    echo "$0 Information"
    echo ''
    echo "   LLNMS Version ${LLNMS_MAJOR}.${LLNMS_MINOR}.${LLNMS_SUBMINOR}"

}


#------------------------------------------------#
#-     Get the user input for the hostname      -#
#------------------------------------------------#
get_input_hostname(){

    EXIT_LOOP=0

    while [ $EXIT_LOOP -ne 1 ]; do
    
        #  prompt the user
        echo ''
        echo -n 'Please enter the desired hostname: '
        read TEMP_HOSTNAME
        
        #  check if answer is correct
        echo ''
        echo -n "Hostname will be set to ${TEMP_HOSTNAME}.  Is this correct (y/n, y - default): "
        read ANS

        #  if the user is happy, then set the hostname and exit
        if [ "$ANS" = "y" -o "$ANS" = 'Y' ]; then
            EXIT_LOOP=1
            NEW_HOSTNAME=$TEMP_HOSTNAME
        fi
    done

}
 
#---------------------------------------------------#
#-     Get the user input for the ip4 address      -#
#---------------------------------------------------#
get_input_ip4_address(){

    EXIT_LOOP=0

    while [ $EXIT_LOOP -ne 1 ]; do
    
        #  prompt the user
        echo ''
        echo -n 'Please enter the desired ip4 address: '
        read TEMP_ADDRESS
        
        #  check if answer is correct
        echo ''
        echo -n "The ip4 address will be set to ${TEMP_ADDRESS}.  Is this correct (y/n, y - default): "
        read ANS

        #  if the user is happy, then set the address and exit
        if [ "$ANS" = "y" -o "$ANS" = 'Y' ]; then
            EXIT_LOOP=1
            IP4_ADDRESS=$TEMP_ADDRESS
        fi
    done

}   

#--------------------------------------------------#
#-     Get the user input for the description     -#
#--------------------------------------------------#
get_input_description(){

    EXIT_LOOP=0

    while [ $EXIT_LOOP -ne 1 ]; do
    
        #  prompt the user
        echo ''
        echo -n 'Please enter the desired asset description (optional): '
        read TEMP_DESCRIPTION
        
        #  check if answer is correct
        echo ''
        echo    "The description will be set to: "
        echo    "${TEMP_DESCRIPTION}"
        echo -n "Is this correct (y/n, y - default): "
        read ANS

        #  if the user is happy, then set the description and exit
        if [ "$ANS" = "y" -o "$ANS" = 'Y' ]; then
            EXIT_LOOP=1
            DESCRIPTION=$TEMP_DESCRIPTION
        fi
    done

}

#-----------------------------------#
#-         Main Function           -#
#-----------------------------------#

#  Source llnms home
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi


#  Import the version info
source $LLNMS_HOME/config/llnms-info.sh

#  Import utilities
source $LLNMS_HOME/bin/llnms-asset-utilities.sh


#  Mode flags
INTERACTIVE_MODE=0

HOSTNAME_FLAG=0
HOSTNAME=''

IP4_ADDRESS_FLAG=0
IP4_ADDRESS=''

DESCRIPTION=''
DESCRIPTION_FLAG=0

OUTFILE_FLAG=0
OUTFILE=''

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

        #  Set interactive mode
        '-i' | '--interactive' )
            INTERACTIVE_MODE=1
            ;;
        
        #  Set the hostname
        '-host' | '--hostname' )
            HOSTNAME_FLAG=1
            ;;

        #  Set the ip4 address
        '-ip4' )
            IP4_ADDRESS_FLAG=1
            ;;
        
        #  Set the description
        '-d' | '--description' )
            DESCRIPTION_FLAG=1
            ;;

        #  Set the output filename
        '-o' )
            OUTFILE_FLAG=1
            ;;

        #  Print error message or process flags
        *)

            #  if the hostname flag is set, then grab the hostname
            if [ $HOSTNAME_FLAG -eq 1 ]; then
                NEW_HOSTNAME=$OPTION
                HOSTNAME_FLAG=0

            # if the ip4 address flag is set, then grab the address
            elif [ $IP4_ADDRESS_FLAG -eq 1 ]; then
                IP4_ADDRESS_FLAG=0
                IP4_ADDRESS=$OPTION
            
            #  If the output file flag is set, then grab the filename
            elif [ $OUTFILE_FLAG -eq 1 ]; then
                OUTFILE_FLAG=0
                OUTFILE=$OPTION
            
            #  If the description is set, then grab the text
            elif [ $DESCRIPTION_FLAG -eq 1 ]; then
                DESCRIPTION=$OPTION
                DESCRIPTION_FLAG=0

            #  otherwise, throw an unknown option error
            else
                error "Unknown option $OPTION"
                usage
                exit 1
            fi
            ;;


    esac
done


#-------------------------------------#
#-          Error Checking           -#
#-------------------------------------#

#  make sure if interactive mode is not set that we have a hostname and ip address
if [ $INTERACTIVE_MODE -eq 0 ]; then
    if [ "$NEW_HOSTNAME" = '' ]; then
        echo 'error: Interactive mode is not set.  A hostname is required to create assets.'
        exit 1
    fi

    if [ "$IP4_ADDRESS" = '' ]; then
        echo 'error: Interactive mode is not set.  An ip4 address is required to create assets.'
        exit 1
    fi
fi


#----------------------------------------#
#-         Start building xml           -#
#----------------------------------------#

#  create the baseline output
OUTPUT='<llnms-asset>\n'


#---------------------------#
#-    Set the hostname     -#
#---------------------------#
#  if interactive mode is set, then use the ui to set the hostname
if [ $INTERACTIVE_MODE -eq 1 ]; then
    get_input_hostname
fi

#  set the xml
OUTPUT+="    <hostname>$NEW_HOSTNAME</hostname>\n"


#------------------------------#
#-     Set the IP4 Address    -#
#------------------------------#
# if interactive mode is set, then use the ui to set the address
if [ $INTERACTIVE_MODE -eq 1 ]; then
    get_input_ip4_address
fi

#  Set the xml
OUTPUT+="    <ip4-address>$IP4_ADDRESS</ip4-address>\n"


#-------------------------------#
#-     Set the description     -#
#-------------------------------#
# if interactive mode is set, then use the ui to set the description
if [ $INTERACTIVE_MODE -eq 1 ]; then
    get_input_description
fi

#  set the xml
OUTPUT+="    <description>$DESCRIPTION</description>\n"


#  Close off the xml data
OUTPUT+='</llnms-asset>\n'

#  Write data to file
OLDIFS=$IFS
IFS=''
echo -e $OUTPUT
IFS=$OLDIFS

