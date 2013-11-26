#  File:    install.ps1
#  Author:  Marvin Smith
#  Date:    11/26/2013
#
#   Purpose:  The primary, recommended installation script
#             for installing LLNMS onto Windows 7 and later 
#             systems.
#
Param(
    [parameter(Mandatory=$false)][switch]$Help
)


#-------------------------------------#
#-    Default Parameters for LLNMS   -#
#-------------------------------------#
$LLNMS_HOME='C:\opt\llnms'


#-------------------------------------#
#-     Print Usage Instructions      -#
#-------------------------------------#
Function usage( ){

    echo "usage: install.ps1 [options]"
    echo ""
    echo "    options:"
    echo ""
    echo "        -Help : Print usage instructions"
    

}

#--------------------------------------------#
#-     Verify and Build Filestructure       -#
#--------------------------------------------#
Function verify-and-build-filestructure(){

    #  Make sure the base path exists
    if( $(Test-Path $LLNMS_HOME) -ne $true ){
        

}


#-------------------------------------#
#-      Start of Main Function       -#
#-------------------------------------#
#  Parse the command-line options
if($Help -eq $true ){
    usage 
    return
}


#--------------------------------------#
#-    Verify File Structure Exists    -#
#--------------------------------------#
verify-and-build-filestructure


#--------------------------------#
#-    Start Installing Files    -#
#--------------------------------#
