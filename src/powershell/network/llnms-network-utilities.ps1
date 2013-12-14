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

#-----------------------------------------------#
#-      Write LLNMS Network Object to File     -#
#-----------------------------------------------#
Function Write_Network_File(){

    Param(
        [parameter(Mandatory=$true)][string]$OutputFilename,
        [parameter(Mandatory=$true)][PSObject]$NetworkObject
    );


    
    
    #  Create the output file
    echo "<llnms-network>`n`r</llnms-network>" | Out-File $OutputFilename

    #  Re-Load file and start manipulating nodes
    $xml_file = New-Object System.XML.XMLDocument
    $xml_file.Load($OutputFilename);

    #  Enter the name
    $nameNode     = $xml_file.CreateElement("Name");
    $nameNodeText = $xml_file.CreateTextNode($($NetworkObject.Name));
    $nameNode.AppendChild($nameNodeText);
    $xml_file.LastChild.AppendChild($nameNode);

    #  Create the networks node
    $networksNode = $xml_file.CreateElement("networks");
    
    #  Get the number of new networks
    $netSize=$(@($($($new_network).Networks)).Length)

    #  Enter each network
    for( $x=0; $x -lt $netSize; $x++ ){
        
        #  Create the network element
        $networkNode = $xml_file.CreateElement("network");

        #  Set the type
        $typeNode = $xml_file.CreateElement("type");
        $typeNodeText = $xml_file.CreateTextNode($($($($NetworkObject).Networks)[$x].Type));
        $typeNode.AppendChild($typeNodeText);
        $networkNode.AppendChild($typeNode);

        #  If the type is SINGLE, then create an address node
        if( $($($($NetworkObject).Networks)[$x].Type) -eq "SINGLE" ){
            
            $addressNode = $xml_file.CreateElement("address");
            $addressNodeText = $xml_file.CreateTextNode($($($($NetworkObject).Networks)[$x].Address_Start));
            $addressNode.AppendChild($addressNodeText);

            #  add to the network node
            $networkNode.AppendChild($addressNode);

        } 
        
        #  if the node is RANGE, then do address start and end
        elseif( $($($($NetworkObject).Networks)[$x].Type) -eq 'RANGE' ){
        
            $addressStartNode     = $xml_file.CreateElement("address-start");
            $addressStartNodeText = $xml_file.CreateTextNode($($($($NetworkObject).Networks)[$x].Address_Start));
            $addressStartNode.AppendChild($addressStartNodeText);

            $addressEndNode     = $xml_file.CreateElement("address-end");
            $addressEndNodeText = $xml_file.CreateTextNode($($($($NetworkObject).Networks)[$x].Address_End));
            $addressEndNode.AppendChild($addressEndNodeText);

            #  add to the network node
            $networkNode.AppendChild($addressStartNode);
            $networkNode.AppendChild($addressEndNode);

        } 
        
        #  Otherwise throw an error
        else {
            Write-Output "error: Unknown type of $($($($network).Networks)[$x].Type)"
            Write-Output "       Only RANGE and SINGLE are supported."
            return 1;
        }

        #  Add network node to networks node
        $networksNode.AppendChild($networkNode);

    }

    #  Add networks node to llnms-network node
    $xml_file.LastChild.AppendChild($networksNode);

    #  save xml file
    $xml_file.Save($OutputFilename);


}
