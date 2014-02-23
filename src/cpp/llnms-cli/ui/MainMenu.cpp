/**
 * @file    MainMenu.cpp
 * @author  Marvin Smith
 * @date    12/31/2013
 */

/// CLI Libraries
#include "MainMenu.hpp"
//#include "asset_ui.hpp"
//#include "asset_status_ui.hpp"
//#include "network_manager_ui.hpp"
//#include "network_status_ui.hpp"
//#include "configure_ui.hpp"
#include <utilities/CursesUtilities.hpp>

/// NCurses
#include <ncurses.h>


/**
 * Print the LLNMS Main Menu Footer
*/
void print_footer(){
    
    // print bottom header row
    mvprintw( 10, 0, "Press any key to continue: ");

}


/**
 * Print the main menu
*/
void main_menu(){
    
    // start a loop
    bool EXIT_LOOP=false;
    while( EXIT_LOOP == false ){

        // clear the screen
        clear();    

        // print header
        print_header("LLNMS Main Menu");
        
        // print content
        int i=2;
        mvprintw( i++, 0, "1: Network Status");
        mvprintw( i++, 0, "2: Asset Status");
        mvprintw( i++, 0, "a: Asset Manager");
        mvprintw( i++, 0, "n: Network Manager");
        mvprintw( i++, 0, "c: Configure LLNMS-Viewer");
        mvprintw( i++, 0, "q: Quit LLNMS Manager");

        // print footer
        print_footer();

        // refresh the screen
        refresh();

        // grab the character
        int ch = getch();

        switch(ch){
            
            /**
             * Network status
             */
            case '1':
                //network_status_ui();
                break;

            /**
             * Asset Status UI
             */
            case '2':
                //asset_status_ui();
                break;

            /**
             * Network Manager
             */
            case 'n':
            case 'N':
                //network_manager_ui();
                break;

            /**
             * Configuration UI
             */
            case 'c':
            case 'C':
                //configure_ui();
                break;

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
                //asset_ui();
                break;
                
            default:;

        }


    }


}

