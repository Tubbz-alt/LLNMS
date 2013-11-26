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
    echo "        -x | -xml    : Print the output in xml format for more advanced usage"

}

#-------------------------------------#
#-      Start of Main Function       -#
#-------------------------------------#
#  Parse the command-line options
if($Help -eq $true ){
    usage 
    return 1
}



#  