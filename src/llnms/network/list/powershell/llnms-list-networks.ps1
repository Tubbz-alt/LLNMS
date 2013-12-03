#   File:    llnms-list-networks.ps1
#   Author:  Marvin Smith
#   Date:    11/26/2013
#
Param(
    [parameter(Mandatory=$false)][switch]$Help
)


#-------------------------------------#
#-     Print Usage Instructions      -#
#-------------------------------------#
Function usage( ){

    echo "usage: $($args[0]) options"
    echo ""
    echo "    options:"
    echo ""
    echo "        -Help : Print usage instructions"
    echo "        -p | -pretty : Print output in human-readable format"
    echo "        -l | -list   : Print output in list format with variables for piping"

}

#-------------------------------------#
#-      Start of Main Function       -#
#-------------------------------------#
#  Parse the command-line options
if($Help -eq $true ){
    usage 
    return 1
}


#--------------------------------------------------#
#-     Get a list of files in the LLNMS_HOME      -#
#--------------------------------------------------#
$llnms_network_files = Get-ChildItem -File -Path "C:\opt\llnms\networks\*.llnms-network.xml"
$llnms_network_count=1
echo "NETWORK_COUNT="
foreach( $llnms_network in $llnms_network_files ){
    
    #  open the file and parse the xml
    $xml_data = [xml](Get-Content -Path $llnms_network)
    
    #  Grab the name
    $xml_name = $xml_data.'llnms-network'.'name'

    echo "NETWORK_($llnms_network_count)_NAME=$xml_name"

    #  Increment the count
    $llnms_network_count += 1
}

  