#    File:    unit_test_utilities.ps1
#    Author:  Marvin Smith
#    Date:    1/27/2014
#
#    Purpose:  Contains utility functions for unit test output
#


#---------------------------------------------#
#-          Print Unit Test Header           -#
#---------------------------------------------#
Function print-unit-test-header( ){
    
    #  Define Parameters
    Param(
        [parameter(Mandatory=$true)][string]$ModuleName,
        [parameter(Mandatory=$false)][string]$Color
    )

    #  Create string to print inside banner
    $data="Start of $ModuleName Module"
    
    #  Create top and bottom bar
    $barline='|'
    for( $x=0; $x -lt $data.Length; $x++ ){
        $barline+='--'
    }
    $barline+='|' 


    #  Create middle row
    $middlerow='|'
    $startword=[int]($barline.Length/2) - [int]($data.Length/2);
    for( $x=0; $x -lt $barline.Length-2; $x++ ){
        
        #  If the iterator is before the start of the word
        if( $x -lt $startword ){
            $middlerow += ' ';
        } 

        #  If we are inside the word
        elseif ( $x -lt ($startword + $data.Length) ){
            $middlerow += $data[($x - $startword)];
        } 
        
        #  If we are after the word
        else {
            $middlerow+= ' ';
        }

    }
    $middlerow+='|'

    #  Check color
    if( $Color -eq '' ){
        $Color="DarkMagenta"
    }

    #   Print data
    Write-Host -ForegroundColor $Color "$barline"
    Write-Host -ForegroundColor $Color "$middlerow"
    Write-Host -ForegroundColor $Color "$barline"

}





#---------------------------------------------#
#-          Print Unit Test Footer           -#
#---------------------------------------------#
Function print-unit-test-footer( ){
   
    #  Define Parameters
    Param(
        [parameter(Mandatory=$true)][string]$ModuleName,
        [parameter(Mandatory=$false)][string]$Color
    )

    #  Create string to print inside banner
    $data="End of $ModuleName Module"
    
    #  Create top and bottom bar
    $barline='|'
    for( $x=0; $x -lt $data.Length; $x++ ){
        $barline+='--'
    }
    $barline+='|' 


    #  Create middle row
    $middlerow='|'
    $startword=[int]($barline.Length/2) - [int]($data.Length/2);
    for( $x=0; $x -lt $barline.Length-2; $x++ ){
        
        #  If the iterator is before the start of the word
        if( $x -lt $startword ){
            $middlerow += ' ';
        } 

        #  If we are inside the word
        elseif ( $x -lt ($startword + $data.Length) ){
            $middlerow += $data[($x - $startword)];
        } 
        
        #  If we are after the word
        else {
            $middlerow+= ' ';
        }

    }
    $middlerow+='|'

    #  Check color
    if( $Color -eq '' ){
        $Color="DarkMagenta"
    }


    #   Print data
    Write-Host -ForegroundColor $Color "$barline"
    Write-Host -ForegroundColor $Color "$middlerow"
    Write-Host -ForegroundColor $Color "$barline"


}


#-----------------------------------------#
#-           Print Test Result           -#
#-----------------------------------------#
Function print-test-result(){
    Param(
        [parameter(Mandatory=$true)][string]$TestModule,
        [parameter(Mandatory=$true)][string]$Result,
        [parameter(Mandatory=$true)][string]$Cause
    )

    #  Print green if result is good, red if bad, orange if warning
    $GoodColor='Green'
    $BadColor='Red'
    $WarnColor='Orange'

    #  If result passes
    if( $Result -eq '1' ){
        Write-Host -ForegroundColor $GoodColor "Pass"
    }
    elseif( $Result -eq '0' ){
        Write-Host -ForegroundColor $BadColor "Fail"
    } 
    else{
        Write-Host -ForegroundColor $WarnColor "Warning"
    }



}
