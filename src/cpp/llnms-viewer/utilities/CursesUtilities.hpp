/**
 * @file    curses.utils.hpp
 * @author  Marvin Smith
 * @date    12/31/2013
*/
#ifndef __SRC_CPP_LLNMSVIEWER_CURSES_UTILS_HPP__
#define __SRC_CPP_LLNMSVIEWER_CURSES_UTILS_HPP__

#include <sstream>
#include <string>

#include "Options.hpp"

extern Options options;

/**
 * Convert a string into a number
*/
template <typename TP>
TP str2num( std::string const& value ){
    
    std::stringstream sin;
    TP result;
    sin << value;
    sin >> result;
    return result;
}

/**
 * Convert a number into a string
*/
template <typename TP>
std::string num2str( TP const& value ){

    std::stringstream sin;
    sin << value;
    return sin.str();
}


/**
 * Initialize Curses
*/
void init_curses();

/**
 * Close Curses
*/
void close_curses();

/**
 * Print LLNMS Header
*/
void print_header( const std::string& module_name );

/**
 * Return a string formatted for printing with ncurses
*/
void print_string( std::string const& strData, const int& row, const int& startWordIndex, const int& stopWordIndex, const std::string& ALIGNMENT = "CENTER" );

/**
*/
char parse_string( std::string const& str, const int& idx, const int& maxWidth, const std::string& STYLE="LEFT" );

/**
 * Return a string composed of a single character
 *
 * @param[in] printChar  Character to print
 * @param[in] row        Row to print
 * @param[in] startx     Starting X Position to print data
 * @param[in] endx       Ending X Position to print data
*/
void print_single_char_line( char const& printChar, 
                             const int& row, 
                             const int& startx, 
                             const int& endx );

/**
 * Print data meant for a form
 * 
 * @param[in] keyData          Key Information to Print in Form
 * @param[in] valueData        Value Information to Print in Form
 * @param[in] row              Row to print info on
 * @param[in] startx           Starting x position to print data.
 * @param[in] stopx            Ending x position to print data
 * @param[in] ALIGNMENT        Alignment for text.
 * @param[in] highlighted      If true, then highlight the row, otherwise use normal color scheme.
 * @param[in] cursor_position  If highlighted, then underline the position where the "cursor" is.
*/
void print_form_line( const std::string& keyData, 
                      const std::string& valueData, 
                      const int& row, 
                      const int& startx, 
                      const int& stopx, 
                      const std::string& ALIGNMENT, 
                      const bool& highlighted,
                      const int& cursor_position);


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
                      const int& cursor_position);




/**
 * Print a button
 * 
 * @param[in] text         Text to print on button 
 * @param[in] row          Row to print info
 * @param[in] startx       Starting x position to print text.
 * @param[in] stopx        Ending x position to print text.
 * @param[in] highlighted  If true, then will highlight button.
 */
void print_button(  const std::string& text, 
                    const int& row, 
                    const int& startx, 
                    const int& stopx, 
                    const bool& highlighted,
                    const bool& print_arrows = true );



/**
 * Print a label
 *
 * @param[in] text       Text to print inside label
 * @param[in] row        Row to print data to
 * @param[in] startx     Starting x coordinate to print text
 * @param[in] stopx      Stopping x coordinate to print text
 * @param[in] color_id   Color to print data to
 * @param[in] ALIGNMENT  Alignment schema to print text to
*/
void print_label( const std::string& text, 
                  const int& row, 
                  const int& startx, 
                  const int& stopx, 
                  const int& color_code,
                  const std::string& ALIGNMENT = "CENTER"
                  );


#endif

