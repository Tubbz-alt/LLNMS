#!/bin/bash


. test/unit_test/initializeANSI.sh


#  Make sure LLNMS has been installed
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi
. $LLNMS_HOME/config/llnms-config.sh


#-------------------------------------#
#-     Print test module header      -#
#-                                   -#
#-     $1 - Module Name              -#
#-------------------------------------#
print_module_header(){

    $ECHO "${bluef}-----------------------------${reset}"
    $ECHO "${bluef}    Start of $1 Module    ${reset}"
    $ECHO "${bluef}-----------------------------${reset}"

}

#-------------------------------------#
#-     Print test module footer      -#
#-                                   -#
#-     $1 - Module Name              -#
#-------------------------------------#
print_module_footer(){
    
    $ECHO "${bluef}-----------------------------${reset}"
    $ECHO "${bluef}    End of $1 Module    ${reset}"
    $ECHO "${bluef}-----------------------------${reset}"

}


#-------------------------------------#
#-     Print test module results     -#
#-                                   -#
#-     $1 - Function                 -#
#-     $2 - Purpose                  -#
#-     $3 - Result                   -#
#-------------------------------------#
print_test_result(){

    if [ ! "$3" = "0" ]; then
        if [ ! -e /var/tmp/cause.txt ]; then
            touch /var/tmp/cause.txt
        fi
    fi
    
    if [ "$3" = "0" ]; then
        $ECHO "${greenf}| passed |${bluef} $1 - $2 ${reset}"
    else
        $ECHO "${redf}| failed |${bluef} $1 - $2 ${reset} - Cause: $(cat /var/tmp/cause.txt)"
    fi

    if [ -e "/var/tmp/cause.txt" ]; then
        rm "/var/tmp/cause.txt"
    fi

}
