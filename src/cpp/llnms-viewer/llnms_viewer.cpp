/**
 * @file    llnms_viewer.cpp
 * @author  Marvin Smith
 * @date    12/31/2013
*/

/// Curses Utilities
#include "ui/curses_utils.hpp"

/// LLNMS Main Menu
#include "ui/main_menu.hpp"

/// Options
#include "llnms/Options.hpp"

/// Global Options
Options options;

/**
 * Main Function
*/
int main( int argc, char* argv[] ){

    try{

        // initialize curses
        init_curses();

        // initialize options
        options.init();
    
        // start main program
        main_menu();


    } catch(...){
        // do nothing
    } 

    // make sure to close up curses
    close_curses();

    return 0;
}


