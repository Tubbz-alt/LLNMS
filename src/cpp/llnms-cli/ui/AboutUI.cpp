/**
 * @file    AboutUI.cpp
 * @author  Marvin Smith
 * @date    3/2/2014
 */
#include "AboutUI.hpp"

#include <utilities/CursesUtilities.hpp>

#include <ncurses.h>

#include <string>

using namespace std;

/**
 * Print the footer
 */
void print_about_footer( ){

    // print the dashed line
    print_single_char_line('-', options.maxY-3, 0, options.maxX );
    
    mvprintw( options.maxY-2, 0, "q/Q: Back to Main Menu.");
    mvprintw( options.maxY-1, 0, "Up/Down Arrows: Navigate Help.");


}

/**
 * Print the about/usage/help screen
 */
void about_ui(){

    /// Index where the top of the screen is
    int topAboutIndex = 0;

    /// start a loop
    bool EXIT_LOOP=false;
    while( EXIT_LOOP == false ){

        // clear the screen
        clear();

        // print the header
        print_header("LLNMS Help");
        
        // print the about info
        int idx = 1;
        for( size_t i=topAboutIndex; i<options.aboutPaneData.size(); i++ ){
            mvprintw( idx++, 0, options.aboutPaneData[i].c_str());
        
        }

        // print the footer
        print_about_footer();

        // refresh the ui
        refresh();

        // get the next character
        int ch = getch();

        switch(ch){

            /// back to main menu
            case 'q':
            case 'Q':
                EXIT_LOOP=true;
                break;

        }

    }


}

