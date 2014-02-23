/**
 * @file    MainMenu.cpp
 * @author  Marvin Smith
 * @date    12/31/2013
 */

/// CLI Libraries
#include "MainMenu.hpp"
#include "NetworkManagerUI.hpp"
//#include "asset_ui.hpp"
//#include "asset_status_ui.hpp"
//#include "network_status_ui.hpp"
//#include "configure_ui.hpp"
#include <utilities/CursesUtilities.hpp>

/// NCurses
#include <ncurses.h>


/**
 * Print the LLNMS Main Menu Footer
*/
void print_main_menu_footer( const int& idx ){
    
    // print bottom header row
    mvprintw( idx+1 , 0, "Press any key to continue: ");

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
        mvprintw( i++, 0, "n: Network Management");
        mvprintw( i++, 0, "q: Quit LLNMS Manager");

        // print footer
        print_main_menu_footer( i );

        // refresh the screen
        refresh();

        // grab the character
        int ch = getch();

        switch(ch){
            
            /**
             * Network Manager
             */
            case 'n':
            case 'N':
                network_manager_ui();
                break;


            /**
             * Quit Program
            */
            case 'q':
            case 'Q':
                EXIT_LOOP=true;
                break;
            
            default:;

        }


    }


}

