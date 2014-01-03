/**
 * @file    Table.cpp
 * @author  Marvin Smith
 * @date    1/2/2014
*/
#include "Table.hpp"

#include <ncurses.h>

using namespace std;

/**
 * Default Constructor
*/
Table::Table(){

    // initialize data
    data.clear();
    data.resize(1);
    headers.resize(1);
    headerRatios.resize(1);

}

/**
 * Reset ratios
*/
void Table::resetRatios(){
    for( size_t i=0; i<headerRatios.size(); i++ ){
        headerRatios[i] = ((double)i/headerRatios.size());
    }
}

/**
 * Set header name
*/
void Table::setHeaderName( const int& idx, const std::string& hdr ){
    
    // if the header list is not big enough, resize
    if( data.size() <= (idx+1) ){
        data.resize(idx+1);
        headers.resize(idx+1);
        headerRatios.resize(idx+1);

        // reset the header ratios
        resetRatios();
    }

    // set text
    headers[idx] = hdr;

}

/**
 * Print table
*/
void Table::print( const int& row, const int& maxX, const int& maxY ){
    
    // current index
    int cIdx=0;
    vector<int> widths(headers.size());
    for( size_t i=0; i<widths.size(); i++ ){
        widths[i] = headerRatios[i] * maxX;
    }

    // print header info
    for( size_t i=0; i<maxX; i++ ){
        

    }
}

