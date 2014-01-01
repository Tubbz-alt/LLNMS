/**
 * @file    llnms_viewer.cpp
 * @author  Marvin Smith
 * @date    12/31/2013
*/

/// Curses Utilities
#include "curses_utils.hpp"

/// LLNMS State container
#include "LLNMS_State.hpp"

/// LLNMS State
LLNMS_State llnms_state;

/**
 * Main Function
*/
int main( int argc, char* argv[] ){

    try{

        // initialize curses
        init_curses();
    
        // start main program
        main_menu();


    } catch(...){
        // do nothing
    } 

    // make sure to close up curses
    close_curses();

    return 0;
}


