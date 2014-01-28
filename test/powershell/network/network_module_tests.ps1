#    File:    network_module_tests.ps1
#    Author:  Marvin Smith
#    Date:    1/27/2014
#
#    Purpose:  Performs network module tests.
#



#------------------------------------------#
#-        Network Module Unit Test        -#
#------------------------------------------#
Function test_network_module(){


    #  Import the unit test library
    . .\test\powershell\unit_test\unit_test_utilities.ps1


    #  Print unit test header
    print-unit-test-header -ModuleName "Network"

    #  Print llnms-create-network results
    .\test\powershell\network\TEST_llnms_create_network.ps1


    #  Print unit test footer
    print-unit-test-footer -ModuleName "Network"


}