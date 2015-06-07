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
    echo "      -h,  -help       :  Print usage instructions"
    echo '      -n,  --no-update :  Skip updating the version file.'
    echo ""
    echo '      --PREFIX <new-path> : Set the installation location.'
    echo ''

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
    
    # Verify the config path exists
    if [ ! -d "$DEFAULT_LLNMS_CONFIG_PATH" ]; then
        mkdir -p "$DEFAULT_LLNMS_CONFIG_PATH"
    fi
    
    # Verify the asset paths exist
    if [ ! -d "$DEFAULT_LLNMS_ASSET_PATH" ]; then
        mkdir -p "$DEFAULT_LLNMS_ASSET_PATH"
    fi

    # Verify the scanner path exists
    if [ ! -d "$DEFAULT_LLNMS_SCAN_PATH" ]; then
        mkdir -p "$DEFAULT_LLNMS_SCAN_PATH"
        mkdir -p "$DEFAULT_LLNMS_SCAN_PATH/scanners"
    fi


}


#-----------------------------------------------#
#-     Install all tools to the filesystem     -#
#-----------------------------------------------#
install_to_filesystem(){
    
    # llnms assets
    echo ''
    echo '   -> Copying asset module scripts'
    
    echo '      -> llnms-create-asset.sh'
    cp 'src/bash/assets/llnms-create-asset.sh'            "$LLNMS_HOME/bin/llnms-create-asset"
    
    echo '      -> llnms-remove-asset.sh'
    cp 'src/bash/assets/llnms-remove-asset.sh'            "$LLNMS_HOME/bin/llnms-remove-asset"
    
    echo '      -> llnms-list-assets.sh'
    cp 'src/bash/assets/llnms-list-assets.sh'             "$LLNMS_HOME/bin/llnms-list-assets"
    
    echo '      -> llnms-print-asset-info.sh'
    cp 'src/bash/assets/llnms-print-asset-info.sh'        "$LLNMS_HOME/bin/llnms-print-asset-info"
    
    echo '      -> llnms-register-asset-scanner.sh'   
    cp 'src/bash/assets/llnms-register-asset-scanner.sh'  "$LLNMS_HOME/bin/llnms-register-asset-scanner"
    
    echo '      -> llnms-scan-asset.sh'                  
    cp 'src/bash/assets/llnms-scan-asset.sh'              "$LLNMS_HOME/bin/llnms-scan-asset"


    # networks
    echo ''   
    echo '   -> Copying network module scripts'
    
    echo '      -> Copying llnms-create-network'                
    cp 'src/bash/network/llnms-create-network.sh'         "$LLNMS_HOME/bin/llnms-create-network"
    
    echo '      -> Copying llnms-list-networks'
    cp 'src/bash/network/llnms-list-networks.sh'          "$LLNMS_HOME/bin/llnms-list-networks"
    
    echo '      -> Copying llnms-scan-address' 
    cp 'src/bash/network/llnms-scan-address.sh'           "$LLNMS_HOME/bin/llnms-scan-address"

    echo '      -> Copying llnms-print-network-info'
    cp 'src/bash/network/llnms-print-network-info.sh'     "$LLNMS_HOME/bin/llnms-print-network-info"

    echo '      -> Copying llnms-remove-network'    
    cp 'src/bash/network/llnms-remove-network.sh'         "$LLNMS_HOME/bin/llnms-remove-network"
    
    echo '      -> Copying llnms-scan-networks'   
    cp 'src/bash/network/llnms-scan-networks.sh'          "$LLNMS_HOME/bin/llnms-scan-networks"


    #  Scanning utilities
    echo ''
    echo '   -> Copying scanning module scripts'
    
    echo '      -> llnms-list-scanners.sh'
    cp 'src/bash/scanning/llnms-list-scanners.sh'       "$LLNMS_HOME/bin/llnms-list-scanners"

    echo '      -> llnms-register-scanner.sh'
    cp 'src/bash/scanning/llnms-register-scanner.sh'    "$LLNMS_HOME/bin/llnms-register-scanner"
    
    echo '      -> llnms-print-scanner-info.sh' 
    cp 'src/bash/scanning/llnms-print-scanner-info.sh'  "$LLNMS_HOME/bin/llnms-print-scanner-info"
    
    echo '      -> llnms scanner scripts'
    cp -r  src/bash/scanning/scanners/*                 "$LLNMS_HOME/scanning/"

    #  config utilities
    echo '      -> llnms info script'
    cp src/bash/llnms-info.sh                           "$LLNMS_HOME/config/llnms-info"
    
    echo '      -> llnms-locking-manager'
    cp 'src/bash/utilities/llnms-locking-manager.sh'    "$LLNMS_HOME/bin/llnms-locking-manager"

    #  Python Utilities
    mkdir -p "$LLNMS_HOME/bin/python"

    echo '      -> llnms-viewer'
    cp 'src/python/llnms-viewer.py'                     "$LLNMS_HOME/bin/python/"
    cp -r 'src/python/llnms'                            "$LLNMS_HOME/bin/python/"



}

#----------------------------#
#-     Uninstall LLNMS      -#
#----------------------------#
uninstall_llnms( ){
    
    #  Print notice
    echo "Uninstalling LLNMS from $LLNMS_HOME"

    #  Remove scripts
    if [ `ls $LLNMS_HOME/bin/llnms-* 2>/dev/null | wc -l` -ne 0 ]; then
        rm $LLNMS_HOME/bin/llnms-*
    fi

    #  Remove logs
    if [ `ls $LLNMS_HOME/logs/llnms*.log 2>/dev/null | wc -l` -ne 0 ]; then
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


#-------------------------#
#-    Check xmlstarlet   -#
#-------------------------#
check_xmlstarlet(){
    
    #  Look for xmlstarlet on the main path
    which 'xmlstarlet' &> /dev/null
    if [ $? -eq 0 ]; then
        return 0
    fi

    #   Look for the actual file
    XMLSTARLET_BIN=`find / -name 'xmlstarlet' 2> /dev/null`
    if [ "$XMLSTARLET_BIN" = '' ]; then
        return 1
    else
        return 0
    fi
    
    return 1
}

#------------------------------------------------------#
#-    Check LLNMS Pre-Requisites for installation     -#
#------------------------------------------------------#
check_prerequisites(){

    echo '   -> checking LLNMS installation pre-requisites'

    #  Check for xmlstarlet
    printf "      -> checking xmlstarlet : "

    check_xmlstarlet
    if [ $? -eq 0 ]; then
        printf 'found\n'
    else
        printf 'not found\n'
        echo 'error: xmlstarlet not found, please install'
        exit 1
    fi

}


#----------------------------------------------------------------#
#-     Build the installation-specific configuration file       -#
#----------------------------------------------------------------#
create_configuration_file(){

    echo ''
    #  Create the file
    if [ -e "$LLNMS_HOME/config/llnms-config" ]; then
        rm -r $LLNMS_HOME/config/llnms-config
    fi

    #  If we are using Darwin, then build the Darwin-specific options
    if [ "`uname`" = "Darwin" ]; then
        ./install/bash/darwin-config.sh "$LLNMS_HOME"

    #  If we are using Linux, add the -e to the echo
    else
        ./install/bash/linux-config.sh "$LLNMS_HOME"
    fi


}

#-----------------------------#
#-      Main Function        -#
#-----------------------------#

#  Set LLNMS_Home to the default release location
export LLNMS_HOME='release/llnms'

#  Parse Command-Line Options
INSTALL_SAMPLES=0
UPDATE_LLNMS=1
PREFIX_FLAG=0

for OPTION in $@; do
    
    #  Case for options
    case $OPTION in 

        #   Print the help instructions
        "-help" | "-h" )
            usage
            exit 0
            ;;
        
        #   Skip update of llnms version file
        '-n' | '--no-update' )
            UPDATE_LLNMS=0
            ;;

        #   Set the prefix flag
        '--PREFIX' )
            PREFIX_FLAG=1
            ;;

        #   Default Parameter.  Usually an error
        * )
            #  Set the prefix flag
            if [ "$PREFIX_FLAG" = '1' ]; then
                PREFIX_FLAG=0
                LLNMS_HOME=$OPTION
            
            #  Otherwise throw an error
            else
                echo "Error: Unknown option $OPTION"
                usage
                exit 1
            fi
            ;;

    esac

done

#  import our default configuration
. install/bash/options.sh $LLNMS_HOME

#  build the baseline filestructure
build_and_verify_filestructure

#  Check prerequisites
check_prerequisites


#  Increment the version file
echo ''
if [ $UPDATE_LLNMS -eq 1 ]; then
    echo "   -> Updating LLNMS Version Information in $LLNMS_HOME/config/llnms-info.sh"
    ./install/bash/version.sh -i subminor
else
    echo "   -> Skipping update of LLNMS Version Information in $LLNMS_HOME/config/llnms-info.sh"
fi


#  copy the tools to the directory
install_to_filesystem


#  Create the configuration file
create_configuration_file


