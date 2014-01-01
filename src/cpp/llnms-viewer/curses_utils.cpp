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

