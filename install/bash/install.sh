#!/bin/sh
#
#  Name:    install.sh
#  Author:  Marvin Smith
#  Date:    11/23/2013
#
#  Purpose:  LLNMS shell-script installer
#

#------------------------------#
#-     Usage Instructions     -#
#------------------------------#
usage(){

    echo "$0 [options]"
    echo ""
    echo "    options:"
    echo "      -h,  -help      :  Print usage instructions"
    echo "      -u,  -uninstall :  Uninstall LLNMS from LLNMS_HOME (Note: Should preserve user created data)"
    echo '      -s,  --samples  :  Install LLNMS Sample Configuration Files'
    echo ""

}


#-----------------------------------------------------#
#-     Build and Verify the Filestructure Exists     -#
#-----------------------------------------------------#
build_and_verify_filestructure(){

    #  Verify LLNMS_HOME
    if [ ! -d "$DEFAULT_LLNMS_HOME" ]; then
        mkdir -p "$DEFAULT_LLNMS_HOME"
    fi

    #  Verify the binary path
    if [ ! -d "$DEFAULT_LLNMS_BIN_PATH" ]; then
        mkdir -p "$DEFAULT_LLNMS_BIN_PATH"
    fi

    # Verify the network directory
    if [ ! -d "$DEFAULT_LLNMS_NETWORK_PATH" ]; then
        mkdir -p "$DEFAULT_LLNMS_NETWORK_PATH"
    fi
    
    # Verify the temp directory
    if [ ! -d "$DEFAULT_LLNMS_TEMP_PATH" ]; then
        mkdir -p "$DEFAULT_LLNMS_TEMP_PATH"
    fi
    
    # Verify the run directory
    if [ ! -d "$DEFAULT_LLNMS_RUN_PATH" ]; then
        mkdir -p "$DEFAULT_LLNMS_RUN_PATH" 
    fi
    
    # Verify the log directory exists
    if [ ! -d "$DEFAULT_LLNMS_LOG_PATH" ]; then
        mkdir -p "$DEFAULT_LLNMS_LOG_PATH"
    fi

    if [ ! -d "$DEFAULT_LLNMS_CONFIG_PATH" ]; then
        mkdir -p "$DEFAULT_LLNMS_CONFIG_PATH"
    fi
    
    if [ ! -d "$DEFAULT_LLNMS_ASSET_PATH" ]; then
        mkdir -p "$DEFAULT_LLNMS_ASSET_PATH/defined"
        mkdir -p "$DEFAULT_LLNMS_ASSET_PATH/discovered"
    fi

}


#-----------------------------------------------#
#-     Install all tools to the filesystem     -#
#-----------------------------------------------#
install_to_filesystem(){
    
    # llnms assets
    cp src/bash/assets/*.sh      $LLNMS_HOME/bin/

    # networks
    cp src/bash/network/*.bash   $LLNMS_HOME/bin/

    #  llnms utilities
    cp src/bash/utilities/*.bash $LLNMS_HOME/bin/
    cp src/bash/utilities/*.sh     $LLNMS_HOME/bin/

    #cp src/bash/logging/*.bash   $LLNMS_HOME/bin/

    cp src/bash/llnms-info.sh    $LLNMS_HOME/config/


}

#----------------------------#
#-     Uninstall LLNMS      -#
#----------------------------#
uninstall_llnms( ){
    
    #  Print notice
    echo "Uninstalling LLNMS from $LLNMS_HOME"

    #  Remove scripts
    if [ $(ls $LLNMS_HOME/bin/llnms-* 2>/dev/null | wc -l) -ne 0 ]; then
        rm $LLNMS_HOME/bin/llnms-*
    fi

    #  Remove logs
    if [ $(ls $LLNMS_HOME/logs/llnms*.log 2>/dev/null | wc -l) -ne 0 ]; then
        rm $LLNMS_HOME/logs/llnms-*.log
    fi


}


#----------------------------------------#
#-       Install LLNMS Samples          -#
#----------------------------------------#
install_samples(){
    
    #  Copy networks
    cp data/samples/networks/*.llnms-network.xml     $LLNMS_HOME/networks/

    #  Copy assets
    cp data/samples/assets/defined/*.llnms-asset.xml $LLNMS_HOME/assets/defined/

}


#  import our default configuration
. install/bash/options.sh

#  Set the LLNMS Home Directory
export LLNMS_HOME=$DEFAULT_LLNMS_HOME

#  Parse Command-Line Options
INSTALL_SAMPLES=0
for OPTION in $@; do
    
    #  Case for options
    case $OPTION in 

        #   Print the help instructions
        "-help" | "-h" )
            usage
            exit 0
            ;;
        
        #   Uninstall LLNMS
        "-u" | "-uninstall" )
            
            uninstall_llnms
            exit 0
            ;;
        
        #   Install LLNMS Samples
        '-s' | '--samples' )
            install_samples
            exit 1
            ;;

        #   Default Parameter.  Usually an error
        "*" )
            echo "Error: Unknown option $OPTION"
            usage
            exit 0
            ;;

    esac

done

#  If no options are present, then do a default install
echo "LLNMS_HOME=$LLNMS_HOME"

#  build the baseline filestructure
build_and_verify_filestructure

#  copy the tools to the directory
install_to_filesystem


#  Install samples
if [ $INSTALL_SAMPLES -eq 1 ]; then
    install_samples
fi



