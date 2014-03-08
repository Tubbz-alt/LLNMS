/**
 * @file    MessageDialog.cpp
 * @author  Marvin Smith
 * @date    3/2/2014
 */
#include "MessageDialog.hpp"

#include <ncurses.h>

#include <utilities/CursesUtilities.hpp> 
/**
 * Print a Message Box
 */
int message_dialog( const std::string& message, const int& BUTTON_FLAGS ){

    // compute size of text
    int textWidth = message.size();

    // compute box center
    int centerX = options.maxX / 2;
    int centerY = options.maxY / 2;

    // set the main outer box dimensions
    int outerBoxMinX = centerX - (textWidth/2) - 5;
    int outerBoxMaxX = centerX + (textWidth/2) + 5;
    int outerBoxMinY = centerY - 5;
    int outerBoxMaxY = centerY + 5;
    if( outerBoxMinX < 0 ){ outerBoxMinX = 0; }

    // set the positions of the text
    int minTextX = outerBoxMinX + 5;
    int maxTextX = outerBoxMaxX - 5;
    int minTextY = outerBoxMinY + 4;
    int maxTextY = outerBoxMaxY - 4;
    
    // cursor position
    int cursorIdx = 0;

    // turn on the background color
    attron( COLOR_PAIR(options.ERROR_TEXT_COLOR_PAIR) );

    // start loop
    bool EXIT_LOOP = false;
    while( EXIT_LOOP == false ){
    
        // print clear box
        for( size_t y=outerBoxMinY; y<=outerBoxMaxY; y++ )
        for( size_t x=outerBoxMinX; x<=outerBoxMaxX; x++ )
            mvaddch( y, x, ' ');

        attron( COLOR_PAIR( options.LABEL_INVALID_COLOR_PAIR ));
        // vertical bars
        for( size_t y=outerBoxMinY+2; y<=outerBoxMaxY-2; y++ ){
            mvaddch( y, outerBoxMinX+2, ' ' ); 
            mvaddch( y, outerBoxMaxX-2, ' ' );
        }
        
        // horizontal bars
        for( size_t x=outerBoxMinX+2; x<=outerBoxMaxX-2; x++ ){
            mvaddch( outerBoxMinY+2, x, ' ' );  
            mvaddch( outerBoxMaxY-2, x, ' ' );
        }
        attroff( COLOR_PAIR( options.PRIMARY_COLOR_PAIR));
        
        // print message
        mvprintw( minTextY, minTextX, message.c_str()); 

        // print buttons
        print_button(   "Save", minTextY+2, minTextX+2,  centerX-2, (cursorIdx == 0), "CENTER" );
        print_button( "Cancel", minTextY+2, centerX+2 , maxTextX-2, (cursorIdx == 1), "CENTER" );
        
        // hide the cursor
        move( 0,0 );

        // get character
        int ch = getch();

        switch(ch){

            /// exit loop
            case 'q':
            case 'Q':
                EXIT_LOOP=true;
                break;

            /// arrow key
            case KEY_LEFT:
            case KEY_RIGHT:
            case 9: /// TAB

                cursorIdx++;
                if( cursorIdx > 1 ){ cursorIdx = 0; }
                break;

            /// enter key
            case KEY_ENTER:
            case 10:
                
                if( cursorIdx == 0 ){ return 1; }
                else{ return 0; }
                break;


        }
    }
    
    // turn off the background color
    attroff( COLOR_PAIR(options.PRIMARY_COLOR_PAIR));
    //attroff( A_STANDOUT );
    

    return false;
}

