/**
 * @file    main_menu.cpp
 * @author  Marvin Smith
 * @date    12/31/2013
 */
#include "main_menu.hpp"
#include "asset_ui.hpp"
#include "curses_utils.hpp"

#include <ncurses.h>

/**
 * Print the LLNMS Main Menu Footer
*/
void print_footer(){
    
    // print bottom header row
    mvprintw( 10, 0, "Press any key to continue: ");

}


void main_menu(){
    
    // start a loop
    bool EXIT_LOOP=false;

    while( EXIT_LOOP == false ){

        // clear the screen
        clear();    

        // print header
        print_header("LLNMS Main Menu");
        
        // print content
        mvprintw( 2, 0, "a: Asset Manager");
        mvprintw( 3, 0, "q: Quit LLNMS Manager");

        // print footer
        print_footer();

        // refresh the screen
        refresh();

        // grab the character
        int ch = getch();

        switch(ch){

            /**
             * Quit Program
            */
            case 'q':
            case 'Q':
                EXIT_LOOP=true;
                break;
            
            /**
             * Show Asset Configuration Pane
            */
            case 'a':
            case 'A':
                asset_ui();
                break;
                
            default:;

        }


    }


}

