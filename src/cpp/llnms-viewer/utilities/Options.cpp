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
    
    // set the log filename
    log_filename = "/var/tmp/llnms/log/llnms-viewer.log";
    
    // set desired log priority
    log_priority = 0;

    // get max window size
    getmaxyx( stdscr, maxY, maxX );
}

