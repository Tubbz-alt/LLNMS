#!/bin/bash


. test/unit_test/initializeANSI.sh

# $1 - Function
# $2 - Purpose
# $3 - Result
# $4 - Note
print_test_result(){

    if [ $3 -eq 0 ]; then
        echo -e "${greenf}| passed |${bluef} $1 - $2 ${reset}"
    else
        echo -e "${redf}| failed |${bluef} $1 - $2 ${reset}"
    fi


}
