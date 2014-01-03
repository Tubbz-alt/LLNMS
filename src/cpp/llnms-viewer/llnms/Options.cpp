/**
 * @file    Options.cpp
 * @author  Marvin Smith
 * @date    1/2/2014
*/
#include "Options.hpp"

#include <ncurses.h>

/**
 * Initialize Options Container
*/
void Options::init(){

    // get max window size
    getmaxyx( stdscr, maxY, maxX );
}
