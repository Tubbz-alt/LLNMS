/**
 * @file    configure_ui.cpp
 * @author  Marvin Smith
 * @date    1/14/2014
 */
#include "configure_ui.hpp"
#include "../utilities/CursesUtilities.hpp"

#include <ncurses.h>

/**
 * Print configuration footer
 */
void print_configuration_footer(){
    
    mvprintw( options.maxY-1, 0, "q: back to main menu,  s: save configuration file");

}


/**
 * Configuration User Interface
 */
void configure_ui(){

    int ch;

    /**
     * Run Loop
     */
    bool EXIT_LOOP=false;
    while( EXIT_LOOP == false ){

        // clear the screen
        clear();

        // draw header
        print_header("LLNMS-Viewer Configuration Pane");
        

        // print footer
        print_configuration_footer();

        // refresh screen
        refresh();

        // grab character
        ch = getch();
        
        // parse options
        switch(ch){

            // quit
            case 'q':
            case 'Q':
                EXIT_LOOP=true;
                break;


        }

    }

}

