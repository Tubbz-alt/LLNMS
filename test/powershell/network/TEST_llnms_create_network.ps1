#    File:    TEST_llnms_create_network.ps1
#    Author:  Marvin Smith
#    Date:    1/27/2014
#
#    Purpose:  Test the llnms-create-network script
#


#-----------------------------------#
#-           Unit Test 01          -#
#-----------------------------------#
Function TEST_llnms_create_network_01(){
    
    
    $global:cause="Not Implemented Yet";
    return '0'

    return '1';
}

$global:cause='';


#  Iterate over each test
$result=TEST_llnms_create_network_01
print-test-result -TestModule 'llnms-create-asset' -Result $result -Cause $global:cause
