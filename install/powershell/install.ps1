#  File:    install.ps1
#  Author:  Marvin Smith
#  Date:    11/26/2013
#
#   Purpose:  The primary, recommended installation script
#             for installing LLNMS onto Windows 7 and later 
#             systems.
#
Param(
    [parameter(Mandatory=$false)][switch]$Help,
    [parameter(Mandatory=$false)][switch]$AddProfile,
    [parameter(Mandatory=$false)][switch]$Version
)


#-------------------------------------#
#-    Default Parameters for LLNMS   -#
#-------------------------------------#
$LLNMS_HOME='C:\opt\llnms'
$LLNMS_MAJOR=1
$LLNMS_MINOR=0
$LLNMS_SUBMINOR=1


#-------------------------------------#
#-     Print Usage Instructions      -#
#-------------------------------------#
Function usage( ){

    echo "usage: install.ps1 [options]"
    echo ""
    echo "    options:"
    echo ""
    echo "        -Help       : Print usage instructions"
    echo "        -AddProfile : Add LLNMS to the system profile"
    echo "        -Version    : Print information about LLNMS"
    

}

#--------------------------------------------#
#-     Verify and Build Filestructure       -#
#--------------------------------------------#
Function verify-and-build-filestructure(){

    #  Make sure the base path exists
    if( $(Test-Path "$LLNMS_HOME" ) -ne $true ){
         New-Item -ItemType directory -Path "$LLNMS_HOME"
    }

    #  Make sure the binary directory exists
    if( $(Test-Path "$LLNMS_HOME\bin" ) -ne $true){
        New-Item -ItemType directory -Path "$LLNMS_HOME\bin"
    }

    #  Make sure the networks directory exists
    if( $(Test-Path "$LLNMS_HOME\networks") -ne $true ){
        New-Item -ItemType directory -Path "$LLNMS_HOME\networks"
    }

    #  Make sure the run directory exists
    if( $(Test-Path "$LLNMS_HOME\run" ) -ne $true ){
        New-Item -ItemType directory -Path "$LLNMS_HOME\run"
    }

    #  Make sure the config directory exists
    if( $(Test-Path "$LLNMS_HOME\config" ) -ne $true ){
        New-Item -ItemType directory -Path "$LLNMS_HOME\config"
    }


}


#-----------------------------------------#
#-        Print the Version Info         -#
#-----------------------------------------#
Function version(){
    
    #Print LLNMS Info
    Write-Output 'LLNMS : Low-Level Network Management System'
    Write-Output ''
    Write-Output "LLNMS_HOME=$LLNMS_HOME"
    Write-Output "LLNMS_VERSION=$LLNMS_MAJOR.$LLNMS_MINOR.$LLNMS_SUBMINOR"

}

#------------------------------------------------------#
#-     Add LLNMS Variables to the System Profile      -#
#------------------------------------------------------#
Function configure-system-profile(){


}

#--------------------------------------#
#-       LLNMS Install Files          -#
#--------------------------------------#
Function llnms-install-files(){

    #  Copy Configuration files
    Copy-Item .\src\powershell\llnms-info.xml "$LLNMS_HOME\config\"

    #  Copy binary files
    Copy-Item .\src\powershell\network\llnms-list-networks.ps1 "$LLNMS_HOME\bin\"
    Copy-Item .\src\powershell\network\llnms-scan-networks.ps1 "$LLNMS_HOME\bin\"
    Copy-Item .\src\powershell\network\llnms-network-utilities.ps1 "$LLNMS_HOME\bin\"



}

#-------------------------------------#
#-      Start of Main Function       -#
#-------------------------------------#
#  Print the installation messages
Write-Host 'LLNMS Windows PowerShell Installer'

#  Parse the command-line options
if($Help -eq $true ){
    usage 
    return
}

#  Print the Version Info
if($Version -eq $true ){
    version
}

#--------------------------------------#
#-    Verify File Structure Exists    -#
#--------------------------------------#
verify-and-build-filestructure


#--------------------------------#
#-    Start Installing Files    -#
#--------------------------------#
llnms-install-files

#-----------------------------------------#
#-    Add LLNMS to the system profile    -#
#-----------------------------------------#
if( $AddProfile -eq $true ){
    configure-system-profile
}


