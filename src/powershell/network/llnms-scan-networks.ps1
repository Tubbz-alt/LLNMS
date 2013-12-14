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
            
            #  Get the address
            $address=$($($($network).Networks)[$x].Address_Start)

            #  Ping the address
            echo "Testing: $address"
            echo "$(Test-Connection $address -Count 1 -ErrorAction Ignore -Quiet)"
        }
        
        #  Otherwise if we have a range of addresses
        else{
            
            #  Get the address
            $address_start=$($($($network).Networks)[$x].Address_Start).ToString().Split('.');
            $address_end  =$($($($network).Networks)[$x].Address_End).ToString().Split('.');

            for( $a=[int]$($address_start[0]); $a -le [int]$($address_end[0]); $a++ ){
            for( $b=[int]$($address_start[1]); $b -le [int]$($address_end[1]); $b++ ){
            for( $c=[int]$($address_start[2]); $c -le [int]$($address_end[2]); $c++ ){
            for( $d=[int]$($address_start[3]); $d -le [int]$($address_end[3]); $d++ ){
                $address="$a.$b.$c.$d"
                echo "Testing $address"
                echo "$(Test-Connection $address -Count 1 -ErrorAction Ignore -Quiet)"
            }}}}

        }
    }
}




