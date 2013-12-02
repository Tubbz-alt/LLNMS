#!/bin/bash


#-------------------------------------------#
#-    View the network summary window      -#
#-------------------------------------------#


#--------------------------------#
#-    Start the llnms viewer    -#
#--------------------------------#
llnms-main-window(){
    
    # start the loop
    EXIT_MAIN_WINDOW_LOOP=0
    while [ $EXIT_MAIN_WINDOW_LOOP -lt 1 ]; do
        
        #  Clear the console screen
        clear

        #  Print the main header
        echo 'LLNMS Main Menu'
        echo '---------------'
        echo '1. View Network Summary'
        echo '2. View Asset Summary'
        echo '3. View Network Configuration'
        echo '4. View Asset Configuration'
        echo 'q. Quit LLNMS-Viewer'
        echo -n "option: "
        
        #  Get input
        read $MAIN_WINDOW_OPTION

        # parse inputs
        case $MAIN_WINDOW_OPTION in
            
            # View Network Summary
            '1' )
                llnms-view-network-summary-window
                ;;

            # Quit LLNMS Viewer
            'q' | 'Q' )
                EXIT_MAIN_WINDOW_LOOP=1
                ;;

            # Otherwise ignore
            * )
                ;;

        esac

    done

}


