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

    printf "${bluef}-----------------------------${reset}\n"
    printf "${bluef}    Start of $1 Module    ${reset}\n"
    printf "${bluef}-----------------------------${reset}\n"

}

#-------------------------------------#
#-     Print test module footer      -#
#-                                   -#
#-     $1 - Module Name              -#
#-------------------------------------#
print_module_footer(){
    
    printf "${bluef}-----------------------------${reset}\n"
    printf "${bluef}    End of $1 Module    ${reset}"
    printf "${bluef}-----------------------------${reset}\n"

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
        printf "${greenf}| passed |${bluef} $1 - $2 ${reset}\n"
    else
        printf "${redf}| failed |${bluef} $1 - $2 ${reset} - Cause: $(cat /var/tmp/cause.txt)\n"
    fi

    if [ -e "/var/tmp/cause.txt" ]; then
        rm "/var/tmp/cause.txt"
    fi

}
