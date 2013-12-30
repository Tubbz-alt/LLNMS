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

    $ECHO_ESC "${bluef}-----------------------------${reset}"
    $ECHO_ESC "${bluef}    Start of $1 Module    ${reset}"
    $ECHO_ESC "${bluef}-----------------------------${reset}"

}

#-------------------------------------#
#-     Print test module footer      -#
#-                                   -#
#-     $1 - Module Name              -#
#-------------------------------------#
print_module_footer(){
    
    $ECHO_ESC "${bluef}-----------------------------${reset}"
    $ECHO_ESC "${bluef}    End of $1 Module    ${reset}"
    $ECHO_ESC "${bluef}-----------------------------${reset}"

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
        $ECHO_ESC "${greenf}| passed |${bluef} $1 - $2 ${reset}"
    else
        $ECHO_ESC "${redf}| failed |${bluef} $1 - $2 ${reset} - Cause: $(cat /var/tmp/cause.txt)"
    fi

    if [ -e "/var/tmp/cause.txt" ]; then
        rm "/var/tmp/cause.txt"
    fi

}
