/**
 * @file    curses_utils.cpp
 * @author  Marvin Smith
 * @date    12/31/2013
*/
#include "curses_utils.hpp"

#include <ncurses.h>

std::string ERROR_FUNCTION(){ 


    return std::string("File: ")+std::string(__FILE__)+std::string(", Line: ")+std::string(num2str(__LINE__))+std::string(".");
}


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
    
    // setup colors
    start_color();
   

    init_pair( 1, COLOR_WHITE, COLOR_BLACK );//WHITE, COLOR_GREEN );
    init_pair( 2, COLOR_WHITE, COLOR_BLUE );
    init_pair( 3, COLOR_BLACK, COLOR_WHITE ); 
    attron(COLOR_PAIR(1)); 

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

void print_string( std::string const& strData, const int& row, const int& startWordIndex, const int& stopWordIndex, const std::string& ALIGNMENT ){

    // select the start of the word
    int wordStart = startWordIndex;
    if( ALIGNMENT == "CENTER" ){
        wordStart = (stopWordIndex + startWordIndex)/2 - (strData.size()/2);
    }
    
    // iterate over range
    for( size_t i=startWordIndex; i<=stopWordIndex; i++ ){
        
        if( i < wordStart || i >= (wordStart + strData.size()) ){ 
            mvaddch( row, i, ' ');
        }
        else{ 
            mvaddch( row, i, strData[i-wordStart]);
        }
    }
    
}


char parse_string( std::string const& str, const int& idx, const int& maxWidth, const std::string& STYLE ){
    
    if( STYLE == "LEFT" ){
        
        if( idx < 0 ){ return ' '; }
        if( idx >= str.size() ){ return ' '; }
        return str[idx];

    }
    else{
        throw std::string("ERROR: Unknown condition");
    }

    return ' ';

}

void print_single_char_line( char const& printChar, const int& row, const int& startx,  const int& endx ){
    
    for( int i=startx; i<=endx; i++ ){
        mvaddch( row, i, printChar );
    }

}

void print_form_line( const std::string& keyData, const std::string& valueData, const int& row, const int& startx, const int& stopx, const std::string& ALIGNMENT, const bool& highlighted ){
    
    /**
     * Dont print anything if the indeces are wrong
    */
    if( startx >= stopx ){ return; }

    /**
      Set the indeces for key versus value data
     */
    int keyStart, valueStart;
    if( ALIGNMENT == "LEFT" ){
        // if using left alignment, the start of the key is the start of the line
        keyStart=startx;

        // if the key is longer than halfway, discard
        if( (stopx-startx)/2 < keyData.size() ){
            valueStart = (stopx+startx)/2;
        }
        else{
            valueStart = keyStart + keyData.size() + 1;
        }

    }
    else{ 
        throw std::string(std::string("Error: ")+ERROR_FUNCTION());
    }

    /**
     * Start iterating over characters
    */
    for( int x=startx; x<=stopx; x++ ){
        
        if( x < keyStart ){ 
            mvaddch(row, x, ' ');
        }
        else if( x >= keyStart && (x-keyStart) < keyData.size() ){
            mvaddch(row, x, keyData[x-keyStart]);
        }
        else if( x >= valueStart && (x-valueStart) < valueData.size() ){
            
            if( highlighted == true ){  attron(A_STANDOUT); }

            mvaddch( row, x, valueData[x-valueStart]);
            
            if( highlighted == true ){  attroff(A_STANDOUT); }
        }
        else if( x >= valueStart ){
            if( highlighted == true ){
                attron(A_STANDOUT);
                mvaddch( row, x, ' ');
                attroff(A_STANDOUT);
            }
        }

    }
}


void print_button( const std::string& text, const int& row, const int& startx, const int& stopx, const bool& highlighted ){
    
    int startWord = (stopx+startx)/2 - (text.size()/2);
    if( startWord < 0 ) startWord=0;

    if( highlighted == false ){
        attron(COLOR_PAIR(2)); 
    }
    else{
        attron(COLOR_PAIR(3));
    }
    // turn on highlighting
    for( int x=startx; x<=stopx; x++ ){
        if( x < startWord || x >= (startWord + text.size()) ){
            mvaddch( row, x, ' ');
        }
        else{
            mvaddch( row, x, text[x-startWord]);
        }
    }
    
    attron(COLOR_PAIR(1)); 
}


