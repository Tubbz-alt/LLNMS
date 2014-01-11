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

bool isValidHostnameCharacter( const char& ch ){

    if( ch >= 'a' && ch <= 'z' ){ return true; }

    switch(ch){
    
        case '-': 
                 return true;

        default: 
                 return false;
    }

    return false;

}

bool isValidIP4AddressCharacter( const char& ch ){
    
    if( ch >= '0' && ch <= '9' ){ return true; }
    if( ch == '.' ){ return true; }

    return false;
}

bool isValidDescriptionCharacter( const char& ch ){
    
    if( ch >= 'a' && ch <= 'z' ){ return true; }
    if( ch >= 'A' && ch <= 'Z' ){ return true; }
    switch(ch){
        
        case ' ':
        case '.':
        case ',':
        case '-':
           return true;

        default:
            return false;
    }

    return false;
}

