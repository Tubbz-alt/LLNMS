#   File:    llnms-network-utilities.ps1
#   Author:  Marvin Smith
#   Date:    12/11/2013
#
#   Purpose:  This script contains functions related to networks
#

#--------------------------------------------------------------#
#-    Function loads the the network xml file and returns a   -#
#-    structure with the relevant informtaion                 -#
#--------------------------------------------------------------#
Function llnms_load_network( ){

    #  The user must specify a network file to load
    param($network_file);

    #  Open the xml file
    echo 'Opening file'
    $xml_data = New-Object XML
    $xml_data.Load($network_file);

    #  Create the new object
    $LLNMS_Network = New-Object PSObject | Select-Object Name, Networks

    #  Set the network name
    $LLNMS_Network.Name = $xml_data.'llnms-network'.'name'
    $LLNMS_Network.Networks=@()

    #  Add each sub network
    $xml_data.'llnms-network'.'networks'.'network' | foreach{
        
        #  Parse depending on network type
        $NET_TYPE=$($_.TYPE)
        if( $NET_TYPE -eq "SINGLE" ){

            #  Create a new type
            $network = New-Object PSObject 
            $network | Add-Member -type NoteProperty -Name Type -Value SINGLE
            $network | Add-Member -type NoteProperty -Name Address_Start -Value $_.'address'

            $LLNMS_Network.Networks += $network

        }
        elseif( $NET_TYPE -eq "RANGE" ){
            
            #  Create a new type
            $network = New-Object PSObject 
            $network | Add-Member -type NoteProperty -Name Type -Value RANGE
            $network | Add-Member -type NoteProperty -Name Address_Start -Value $_.'address-start'
            $network | Add-Member -type NoteProperty -Name Address_End   -Value $_.'address-end'

            $LLNMS_Network.Networks += $network

        }
    }

   
   return $LLNMS_Network
}