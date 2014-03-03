/**
 * @file    MessageDialog.cpp
 * @author  Marvin Smith
 * @date    3/2/2014
 */
#include "MessageDialog.hpp"

#include <ncurses.h>

/**
 * Print a Message Box
 */
int message_dialog(){

    // set bounds
    int minX = (options.maxX / 2) - (options.maxX/4);
    int maxX = (options.maxX / 2) + (options.maxX/4);
    int minY = (options.maxY / 2) - (options.maxY/4);
    int maxY = (options.maxY / 2) + (options.maxY/4);

    // turn on the background color
    attron( COLOR_PAIR(options.ERROR_TEXT_COLOR_PAIR) );
    //attron( A_STANDOUT );

    // start loop
    bool EXIT_LOOP = false;
    while( EXIT_LOOP == false ){

        // print clear box
        for( size_t y=minY; y<=maxY; y++ )
        for( size_t x=minX; x<=maxX; x++ )
            mvaddch( y, x, ' ');

        // print text
        for( size_t y=minY+4; y<=maxY-4; y++ ){
            mvaddch( y, minX+4, '|' ); mvaddch( y, maxX-4, '|' );
        }
        for( size_t y=minY+5; y<=maxY-5; y++ ){
            mvaddch( y, minX+5, '|' ); mvaddch( y, maxX-5, '|' );
        }

        for( size_t x=minX+4; x<=maxX-4; x++ ){
            mvaddch( minY+4, x, '-' );  mvaddch( maxY-4, x, '-' );
        }
        for( size_t x=minX+5; x<=maxX-5; x++ ){
            mvaddch( minY+5, x, '-' );  mvaddch( maxY-5, x, '-' );
        }
        
        // print corners
        mvaddch( minY+4, minX+4, '+' );  mvaddch( minY+4, maxX-4, '+' );
        mvaddch( maxY-4, minX+4, '+' );  mvaddch( maxY-4, maxX-4, '+' );
        mvaddch( minY+5, minX+5, '+' );  mvaddch( minY+5, maxX-5, '+' );
        mvaddch( maxY-5, minX+5, '+' );  mvaddch( maxY-5, maxX-5, '+' );
        
        // print message


        // get character
        int ch = getch();

        switch(ch){

            /// exit loop
            case 'q':
            case 'Q':
                EXIT_LOOP=true;
                break;
        }
    }
    
    // turn off the background color
    attroff( COLOR_PAIR(options.PRIMARY_COLOR_PAIR));
    //attroff( A_STANDOUT );
    

    return false;
}

