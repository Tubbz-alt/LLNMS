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

}

#-------------------------------------#
#-      Start of Main Function       -#
#-------------------------------------#
#  Parse the command-line options
if($Help -eq $true ){
    usage 
    return 1
}


#----------------------------#
#-       Main Function      -#
#----------------------------#

#  Import the network utility script
. C:\opt\llnms\bin\llnms-network-utilities.ps1

#  Get a list of networks to scan
$network_files = Get-ChildItem -File -Path "C:\opt\llnms\networks\*.llnms-network.xml"

#  for each network, get a range of addresses
foreach( $network_file in $network_files ){
    
    #  Load the network
    $network = llnms_load_network $network_file
    
    #  iterate through each address
    $netSize=$(@($($($network).Networks)).Length)

    for( $x=0; $x -lt $netSize; $x++ ){
        
        #  If we have a single address
        if( $($($($network).Networks)[$x].Type) -eq 'SINGLE' ){
        
        }
        
        #  Otherwise if we have a range of addresses
        else{
        
        
        }
}




