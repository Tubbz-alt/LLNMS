/**
 * @file    ConfigurationUI.cpp
 * @author  Marvin Smith
 * @date    3/2/2014
 */
#include "ConfigurationUI.hpp"

/// NCurses
#include <ncurses.h>

/// Utilities 
#include <utilities/CursesUtilities.hpp>

/**
 * Print the footer
 */
void print_configuration_footer(){

    print_single_char_line('-', options.maxY-3, 0, options.maxX );
    mvprintw( options.maxY-2, 0, "q/Q: Back to Main Menu.");

}

/**
 * Print the configuration ui
 */
void configuration_ui(){

    /// start the loop
    bool EXIT_LOOP=false;
    while( EXIT_LOOP == false ){

        // clear the screen
        clear();

        // print the header
        print_header("LLNMS Configuration Options");



        // print the footer
        print_configuration_footer();

        // refresh the screen
        refresh();

        // get input
        int ch = getch();

        switch(ch){

            // exit window
            case 'q':
            case 'Q':
                EXIT_LOOP=true;
                break;
        }

    }


}

