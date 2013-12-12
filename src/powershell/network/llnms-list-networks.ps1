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

#  Import the network utility script
. C:\opt\llnms\bin\llnms-network-utilities.ps1


#--------------------------------------------------#
#-     Get a list of files in the LLNMS_HOME      -#
#--------------------------------------------------#
$llnms_network_files = Get-ChildItem -File -Path "C:\opt\llnms\networks\*.llnms-network.xml"
foreach( $llnms_network in $llnms_network_files ){
    
    $network = llnms_load_network $llnms_network

    echo "Network: $($network.name)"
    $netSize=$(@($($($network).Networks)).Length)

    for( $x=0; $x -lt $netSize; $x++ ){
        echo "      Type: $($($($network).Networks)[$x].Type)"
        if( $($($($network).Networks)[$x].Type) -eq 'SINGLE' ){
            echo "         Address: $($($($network).Networks)[$x].Address_Start)"
        }
        else{
            echo "         Address-Start: $($($($network).Networks)[$x].Address_Start)"
            echo "         Address-End  : $($($($network).Networks)[$x].Address_End)"
        }
        echo ''
    }
}

  