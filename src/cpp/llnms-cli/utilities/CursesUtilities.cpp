/**
 * @file    curses_utils.cpp
 * @author  Marvin Smith
 * @date    12/31/2013
*/
/// Curses Utility Header
#include "CursesUtilities.hpp"

/// NCurses
#include <ncurses.h>

/**
 * Error Function
*/
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
   
    /// initialize the color pairs
    init_pair( options.PRIMARY_COLOR_PAIR,              COLOR_WHITE, COLOR_BLACK );
    init_pair( options.BUTTON_UNCOVERED_COLOR_PAIR,     COLOR_WHITE, COLOR_BLUE );
    init_pair( options.BUTTON_COVERED_COLOR_PAIR,       COLOR_BLACK, COLOR_BLUE );
    init_pair( options.LABEL_VALID_COLOR_PAIR,          COLOR_BLACK, COLOR_GREEN );
    init_pair( options.LABEL_INVALID_COLOR_PAIR,        COLOR_WHITE, COLOR_RED );
    init_pair( options.MULTILINE_UNCOVERED_COLOR_PAIR,  COLOR_BLACK, COLOR_BLUE );
    init_pair( options.ERROR_TEXT_COLOR_PAIR,           COLOR_RED,   COLOR_BLACK );

    attron(COLOR_PAIR( options.PRIMARY_COLOR_PAIR )); 

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


/**
 * Print single line form entry
 */
void print_form_line( const std::string& keyData, 
                      const std::string& valueData, 
                      const int& row, 
                      const int& startx, 
                      const int& stopx, 
                      const std::string& ALIGNMENT, 
                      const bool& highlighted,
                      const int& cursor_position
                     ){
    
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

        // If we are inside the value string
        else if( x >= valueStart && (x-valueStart) < valueData.size() ){
            
            // if we want the line to be highlighted, then highlight
            if( highlighted == true ){  attron(A_STANDOUT); }
            if( highlighted == true && cursor_position == (x-valueStart)){ attron(A_UNDERLINE); }     
            
            // print the character
            mvaddch( row, x, valueData[x-valueStart]);
            
            // undo the print changes
            if( highlighted == true ){  attroff(A_STANDOUT); }
            if( highlighted == true && cursor_position == (x-valueStart)){ attroff(A_UNDERLINE); }     
        
        }

        // if we are past the end of the value string, then print spaces
        else if( x >= valueStart ){
            
            if( highlighted == true ){
                attron(A_STANDOUT);
                if( highlighted == true && cursor_position == (x-valueStart)){ attron(A_UNDERLINE); }     
                
                mvaddch( row, x, ' ');
                
                if( highlighted == true && cursor_position == (x-valueStart)){ attroff(A_UNDERLINE); }     
                attroff(A_STANDOUT);
            }
        }

    }
}


/**
 * Print data meant for a form with multiple lines
 * 
 * @param[in] keyData          Key Information to Print in Form
 * @param[in] valueData        Value Information to Print in Form
 * @param[in] starty           Starting y position to print data
 * @param[in] stopy            Ending y position to print data
 * @param[in] startx           Starting x position to print data.
 * @param[in] stopx            Ending x position to print data
 * @param[in] highlighted      If true, then highlight the row, otherwise use normal color scheme.
 * @param[in] cursor_position  If highlighted, then underline the position where the "cursor" is.
*/
void print_form_multiline( const std::string& keyData, 
                      const std::string& valueData, 
                      const int& starty,
                      const int& stopy, 
                      const int& startx, 
                      const int& stopx, 
                      const bool& highlighted,
                      const int& cursor_position){
    
    /**
     * Dont print anything if the indeces are wrong
    */
    if( starty >= stopy+1 ){ return; }
    if( startx >= stopx   ){ return; }


    /**
     * Start printing the header
    */
    mvprintw( starty, startx, keyData.c_str());


    // turn on highlighting if requested
    if( highlighted == true ){
        attron( A_STANDOUT );
    } else {
        attron( COLOR_PAIR(options.MULTILINE_UNCOVERED_COLOR_PAIR) );
    }
    
    /**
     * Start printing the value data
     * We should iterate over the value data itself to enable multiline support.
    */
    // convert index to x and y coordinate
    int x = startx;
    int y = starty+1;
    int cursorIndex=0;
    while( true ){

        // turn on underlining if requested
        if( highlighted == true && cursor_position == cursorIndex ){
            attron( A_UNDERLINE );
        }

        // print the character
        if( cursorIndex < valueData.size() ){
            mvaddch( y, x, valueData[cursorIndex] );
        }
        // otherwise print whitespace
        else{
            mvaddch( y, x, ' ');
        }

        // turn off underlining if requested
        if( highlighted == true && cursor_position == cursorIndex ){
            attroff( A_UNDERLINE );
        }

        // increment the x character
        x++;

        // check if we need to increment rows
        if( x > stopx ){
            x = startx;
            y++;
        }

        // check if we have hit the bottom row
        if( y > stopy ){
            break;
        }

        // increment the cursor
        cursorIndex++;

    }

    // turn off highlighting if requested
    if( highlighted == true ){
        attroff( A_STANDOUT );
    } 
    
    // fix the color if modified    
    attron( COLOR_PAIR(options.PRIMARY_COLOR_PAIR) );


}






/**
 * Print an NCurses Button
 */
void print_button( const std::string& text, const int& row, const int& startx, const int& stopx, const bool& highlighted, const bool& print_arrows ){
    
    /// Find the location to start printing text
    int startWord = (stopx+startx)/2 - (text.size()/2);
    if( startWord < 0 ) startWord=0;

    /// print arrows if wanted
    attron(COLOR_PAIR( options.PRIMARY_COLOR_PAIR ));
    if( highlighted == true && print_arrows == true && (startx-3 >= 0) ){
        mvprintw( row, startx-3, "-->");
    }
    
    /// set the color
    if( highlighted == false ){
        attron(COLOR_PAIR( options.BUTTON_UNCOVERED_COLOR_PAIR )); 
    }
    else{
        attron(COLOR_PAIR( options.BUTTON_COVERED_COLOR_PAIR ));
    }
    
    /// Start printing text
    for( int x=startx; x < stopx; x++ ){
        if( x < startWord || x >= (startWord + text.size()) ){
            mvaddch( row, x, ' ');
        }
        else{
            mvaddch( row, x, text[x-startWord]);
        }
    }
    
    /// reset the color back to normal
    attron(COLOR_PAIR( options.PRIMARY_COLOR_PAIR ));
    
    /// print arrows if wanted
    if( highlighted == true && print_arrows == true && (stopx+3 < options.maxX )){
        mvprintw( row, stopx, "<--");
    }


}


/**
 * Print an NCurses Label
*/
void print_label( const std::string& text, const int& row, const int& startx, const int& stopx, const int& color_id, const std::string& ALIGNMENT ){
    
    // set the start of the work
    // note:  LEFT alignment starts at 0 always
    int startWord = 0;
    if( ALIGNMENT == "CENTER" ){
        startWord = (stopx+startx)/2 - (text.size()/2);
    }
    else{
        throw std::string("error: Unknown alignment");
    }
    if( startWord < 0 ) startWord=0;


    // set the color
    attron( COLOR_PAIR(color_id) );


    /// start printing text
    for( int x=startx; x<=stopx; x++ ){
        if( x < startWord || x >= (startWord + text.size()) ){
            mvaddch( row, x, ' ');
        }
        else{
            mvaddch( row, x, text[x-startWord]);
        }
    }
    

    // reset the color back to normal
    attron(COLOR_PAIR( options.PRIMARY_COLOR_PAIR )); 
    
}


