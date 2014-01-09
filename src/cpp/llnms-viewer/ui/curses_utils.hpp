/**
 * @file    curses.utils.hpp
 * @author  Marvin Smith
 * @date    12/31/2013
*/
#ifndef __SRC_CPP_LLNMSVIEWER_CURSES_UTILS_HPP__
#define __SRC_CPP_LLNMSVIEWER_CURSES_UTILS_HPP__

#include <sstream>
#include <string>

#include "../llnms/Options.hpp"

extern Options options;

template <typename TP>
TP str2num( std::string const& value ){
    
    std::stringstream sin;
    TP result;
    sin << value;
    sin >> result;
    return result;
}

template <typename TP>
std::string num2str( TP const& value ){

    std::stringstream sin;
    sin << value;
    return sin.str();
}

extern Options options;

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
*/
void print_single_char_line( char const& printChar, const int& row, const int& startx, const int& endx );

/**
 * Print data meant for a form
*/
void print_form_line( const std::string& keyData, const std::string& valueData, const int& row, const int& startx, const int& stopx, const std::string& ALIGNMENT, const bool& highlighted );

void print_button( const std::string& text, const int& row, const int& startx, const int& stopx, const bool& highlighted );


#endif

