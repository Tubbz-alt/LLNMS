#   File:    llnms-add-network.ps1
#   Author:   Marvin Smith
#   Date:     12/13/2013
#
#   Purpose:  This script adds a network to the system
#
Param(
    [parameter(Mandatory=$false)][switch]$Help,
    [parameter(Mandatory=$false)][switch]$Interactive,
    [parameter(Mandatory=$false)][string]$Name,
    [parameter(Mandatory=$false)][string[]]$Networks,
    [parameter(Mandatory=$false)][string]$OutputFilename
)


#--------------------------------------------#
#-           Usage Instructions             -#
#--------------------------------------------#
Function usage(){

    Write-Host "llnms-add-network.ps1 [options]"
    Write-Host ""
    Write-Host "    options:"
    Write-Host "        -Help : Print usage instructions"
    Write-Host "        -Interactive : Create network using command-line interactive wizard"
    Write-Host "        -Name [new name]  : Set network name"
    Write-Host "        -Networks `"TYPE:ADDRESS-START:ADDRESS-END`",`"TYPE:ADDRESS-START:ADDRESS-END`"..."
    Write-Host "            Note:  If the type is RANGE, then use ADDRESS-START and ADDRESS-END (inclusive)"
    Write-Host "                   If the type is SINGLE, then just use ADDRESS-START"
    Write-Host "        -OutputFilename [filename] : Name of output file, otherwise a filename will be generated."


}

#---------------------------------------------------#
#-        Interactive Menu for Add Network         -#
#---------------------------------------------------#
Function interactive_menu( ){
    
    #  Create return object
    $new_network = New-Object PSObject | Select-Object Name, Networks

    #  ask user for name
    $new_network.Name = Read-Host 'Please Enter a Network Name '

    Write-Error 'error:  Function not implemented, exiting now'
    exit 1

    #  Return from function
    return $new_network

}

#---------------------------------#
#-         Main Function         -#
#---------------------------------#
#  Import the network utility script
. C:\opt\llnms\bin\llnms-network-utilities.ps1

#  set the default
$output_filename="C:\opt\llnms\networks\$($(Get-Date).Year)$($(Get-Date).Month)$($(Get-Date).Day)$($(Get-Date).Hour)$($(Get-Date).Minute)$($(Get-Date).Second)_$($(Get-Date).Millisecond).llnms-network.xml"


#  Check if we are printing usage instructions
if( $Help -eq $true ){
    usage
    return 1
}

#   create our output object
$new_network = New-Object PSObject | Select-Object Name, Networks

#  If we are using the interactive option, then call on that function
if( $Interactive -eq $true ){
    $new_network = interactive_menu
}

#  Otherwise, set the options
else{

    #  set the output filename
    if( $OutputFilename -ne "" ){
        $output_filename = $OutputFilename
    }

    #  Set the name
    $new_network.Name=$Name    

    #  Set the networks
    $temp_network = New-Object PSObject | Select-Object Type, Address_Start, Address_End
    $new_network.Networks = @()

    #  iterate through each network
    foreach( $tempnet in $Networks ){
        
        #  split the string by the colon
        $netparams = $tempnet.Split(':')

        # check the type
        $temp_network.Type=$netparams.Get(0);

        # If range, then set the addresses
        if( $($temp_network.Type) -eq "RANGE" ){
            $temp_network.Address_Start=$($netparams.Get(1));
            $temp_network.Address_End=$($netparams.Get(2));
        }

        # If single, then set the single address
        elseif( $($temp_network.Type) -eq "SINGLE" ){
            $temp_network.Address_Start=$($netparams.Get(1));
            $temp_network.Address_End=""
        }

        # Otherwise, an incorrect network type was input
        else{
            Write-Error "error: Incorrect network type of $($temp_network.Type) was given."
            Write-Error "       Only supported types are SINGLE and RANGE."
            usage
            return 1
        }

        #  Append the network
        $new_network.Networks += $temp_network

    }


}


#  Write the network to file
Write_Network_File -OutputFilename $output_filename -NetworkObject $new_network

Write-Host "Network Created At $output_filename"
