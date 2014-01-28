#    File:    run_tests.ps1
#    Author:  Marvin Smith
#    Date:    1/27/2014
#
#    Purpose:  Perform unit tests on the LLNMS Powershell Modules
#
Param( 
    [parameter(Mandatory=$false)][switch]$Help
)

#-----------------------------------#
#-          Usage Function         -#
#-----------------------------------#
Function usage(){
    
    Write-Host 'run-tests.ps1 [options]'
    Write-Host ''
    Write-Host '     options:'
    Write-Host ''
    Write-Host '      -Help   :  Print usage instructions'
    Write-Host ''

}




#------------------------------------#
#-            Main Program          -#
#------------------------------------#

#  Check if help has been requested
if( $Help -eq $true ){
    usage
    exit 1
}
