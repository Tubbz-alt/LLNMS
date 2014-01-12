/**
 * @file     error_ui.cpp
 * @author   Marvin Smith
 * @date     1/11/2014
*/
#include "error_ui.hpp"

#include <ncurses.h>



/**
 * Print an error window
*/
void error_prompt( const std::string& message ){

    // hide the cursor temporarily
    curs_set(0);

    // find the center
    int centerX = options.maxX/2;
    int centerY = options.maxY/2;
    
    // find the top and bottom of the window
    int minX = centerX - (message.size()/2) - 2;
    if( minX < 0 ){ minX = 0; }
    int maxX = centerX + (message.size()/2) + 2;
    if( maxX >= options.maxX-2 ){ maxX = options.maxX-2; }
    if( (minX+maxX)%2 == 0 ){maxX++;}

    
    int minY = centerY - 3;
    int maxY = centerY + 4;

    // find the error header start
    std::string errorHeaderText = "ERROR";
    int xgap=6;
    int errorMinX = centerX - (errorHeaderText.size()/2) - xgap;
    int errorMaxX = centerX + (errorHeaderText.size()/2) + xgap;
    if( (errorMinX+errorMaxX)%2 == 0 ) errorMaxX++;
    int errorHeaderY = centerY-2;

    // find the message dimensions
    int messageX = centerX - (message.size()/2);
    if( messageX < minX+1 ){ messageX=minX+1; }
    int messageY = centerY + 1;
    
    /// print press to continue dimensions
    std::string pressText = "Press ENTER to Continue.";
    int pressX = centerX - (pressText.size()/2);
    int pressY = messageY + 2;

    // misc variables
    int ch = 0;

    // start exit loop
    bool EXIT_LOOP=false;
    while( EXIT_LOOP == false ){

        /// Redraw the box
        for( int y=minY; y<maxY; y++ ){
        for( int x=minX; x<maxX; x++ ){
            mvaddch( y, x, ' ' );
        }}

        //----------------------------//
        //        ERROR HEADER        //
        //----------------------------//
        attron( A_BOLD );
        attron( COLOR_PAIR( options.ERROR_TEXT_COLOR_PAIR ));
        
        /// draw the header box corners
        mvaddch(  errorHeaderY+1, errorMinX, '+' );
        mvaddch(  errorHeaderY-1, errorMinX, '+' );
        mvaddch(  errorHeaderY-1, errorMaxX, '+' );
        mvaddch(  errorHeaderY+1, errorMaxX, '+' );
        
        /// draw the header box sides
        mvaddch(  errorHeaderY, errorMinX, '|' );
        mvaddch(  errorHeaderY, errorMaxX, '|' );

        for( int i=errorMinX+1; i<=errorMaxX-1; i++ ){
            mvaddch( errorHeaderY-1, i, '-' );
            mvaddch( errorHeaderY+1, i, '-' );
        }

        /// draw the header
        mvprintw( errorHeaderY, errorMinX+xgap, errorHeaderText.c_str());
        
        /// clean up header printing
        attroff( A_BOLD );
        attron( COLOR_PAIR( options.PRIMARY_COLOR_PAIR ));


        /// print the message
        mvprintw( messageY, messageX, message.c_str() );
        
        /// Print press to continue
        mvprintw( pressY, pressX, pressText.c_str() );

        /// hide cursor
        move( 0, 0);

        /// refresh screen
        refresh();
        
        // get character input
        ch = getch();
        
        // check for enter key
        if( ch == 10 || ch == KEY_ENTER ){
            EXIT_LOOP=true;
        }

    }

    // unhide the cursor
    curs_set(1);


}

