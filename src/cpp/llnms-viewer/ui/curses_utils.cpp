/**
 * @file    curses_utils.cpp
 * @author  Marvin Smith
 * @date    12/31/2013
*/
#include "curses_utils.hpp"

#include <ncurses.h>

/**
 * Initialize Curses
*/
void init_curses(){

    // initialize the screen
    initscr();
    
    // set raw mode
    raw();

    // set keypad special characters
    keypad(stdscr, TRUE);

}


void close_curses(){

    // close the window
    endwin();

}

void print_header( const std::string& module_name ){
    
    // print top line
    mvprintw( 0, 0, module_name.c_str() );
    
    // print row
    for( int i=0; i<options.maxX; i++ )
        mvprintw( 1, i, "-" );

}

char format_string( std::string const& str, const int& idx, const int& maxWidth, const std::string& STYLE="LEFT" ){
    
    if( STYLE == "LEFT" ){
        
        if( idx < 0 ){ return ' '; }
        if( idx >= str.size() ){ return ' '; }
        return str[idx];

    }

    return ' ';

}

char parse_string( std::string const& strData, const int& index, const int& startWordIndex, const int& stopWordIndex, const std::string& STYLE="LEFT" ){

    //  Parse Word
    if( STYLE == "LEFT" ){

        if( index < startWordIndex ){ return ' '; }
        if( index > startWordIndex && index < (startWordIndex + strData.size()) ){ return strData[index - startWordIndex]; }

    }
    else if( STYLE == "CENTER" ){
        
        if( index < startWordIndex ){ return ' '; }
        if( index > stopWordIndex  ){ return ' '; }
        
        int halfIndex = (stopWordIndex+startWordIndex)/2;
        int startOfWord = (halfIndex - (strData.size()/2));

        if( index >= startOfWord && index < (startOfWord + strData.size())){
            return strData[index - startOfWord];
        }
    }

    return ' ';
}

