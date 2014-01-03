/**
 * @file    curses.utils.hpp
 * @author  Marvin Smith
 * @date    12/31/2013
*/
#ifndef __SRC_CPP_LLNMSVIEWER_CURSES_UTILS_HPP__
#define __SRC_CPP_LLNMSVIEWER_CURSES_UTILS_HPP__

#include <string>

#include "../llnms/Options.hpp"

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

#endif

