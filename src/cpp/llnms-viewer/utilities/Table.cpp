/**
 * @file    Table.cpp
 * @author  Marvin Smith
 * @date    1/2/2014
*/
#include "Table.hpp"

#include "CursesUtilities.hpp"

#include <ncurses.h>

#include <cstdlib>

using namespace std;

/**
 * Default Constructor
*/
Table::Table(){

    // initialize data
    data.clear();
    headers.resize(1);
    headerRatios.resize(1);
    
    headerRatios[0] = 1;
}

/**
 * Reset ratios
*/
void Table::resetRatios(){
    for( size_t i=0; i<headerRatios.size(); i++ ){
        headerRatios[i] = ((double)1/headerRatios.size());
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
 * Set table data
*/
void Table::setData( const int& x, const int& y, const string& strdata ){

    if( data.size() <= x ){
        data.resize(x+1);
        for( size_t i=0; i<data.size(); i++ ){
            if( data[i].size() <= y ){
                data[i].resize(y+1);
            }
        }
    }
    if( data[x].size() <= y ){
        for( size_t i=0; i<data.size(); i++ ){
            if( data[i].size() <= y ){
                data[i].resize(y+1);
            }
        }
    }
    
    data[x][y]=strdata;
}

/**
 * Print table
*/
void Table::print( const int& row, const int& maxX, const int& maxY ){
    print( row, maxX, maxY, -1, 0 );
}

/**
 * Print table
*/
void Table::print( const int& row, const int& maxX, const int& maxY, const int& currentIdx, const int& topItem ){  
  
    // current index
    int cIdx=0;
    vector<int> widths(headers.size());
    for( size_t i=0; i<widths.size(); i++ ){
        widths[i] = headerRatios[i] * maxX;
    }

    // print header info
    int tidx=0;
    int cidx=0;
    int crow=row;
    for( size_t i=0; i<=maxX; i++ ){
        

        // if starting a new block, print the bar
        if( tidx == 0 || i == maxX ){ mvprintw( crow, i, "|" ); }

        // if starting a new block, print a space after the bar
        else if( tidx == 1 ){ mvprintw( crow, i, " " ); }
        
        // if ending a new block, print another space
        else if( tidx == (widths[cidx])){ mvprintw( crow, i, " "); }

        // otherwise print the string
        else{ mvaddch( crow, i, parse_string(headers[cidx], tidx-2, widths[cidx]-3, "LEFT") ); }
        
        tidx++;
        if( tidx > widths[cidx] ){
            cidx++;
            tidx=0;
        }

    }

    // print header bar
    tidx=0;
    cidx=0;
    crow++;
    for( size_t i=0; i<=maxX; i++ ){
        
        /**
         * Print corner
         */
        if( tidx == 0 || i == maxX ){
            mvaddch( crow, i, '+' );
        }

        /**
         * Print horizontal line
         */
        else{
            mvaddch( crow, i, '-' );
        }

        /// increment temp index
        tidx++;
        if( tidx > widths[cidx] ){
            tidx=0;
            cidx++;
        }

    }

    if( data.size() <= 0 ){
        return;
    }

    /**
     * Print data
     */
    for( size_t i=0; i<data[0].size(); i++ ){
        tidx=0;
        cidx=0;
        crow++;

        // turn on highlighting if requested
        if( i == currentIdx ){  attron( A_STANDOUT ); }

        for( size_t j=0; j<=maxX; j++ ){
            
            // if starting a new block, print the bar
            if( tidx == 0 || j == maxX ){ mvprintw( crow, j, "|" ); }

            // if starting a new block, print a space after the bar
            else if( tidx == 1 ){ mvprintw( crow, j, " " ); }
        
            // if ending a new block, print another space
            else if( tidx == (widths[cidx])){ mvprintw( crow, j, " "); }

            // otherwise print the string
            else{ mvaddch( crow, j, parse_string(data[cidx][i], tidx-2, widths[cidx]-3, "LEFT") ); }

            tidx++;
            if( tidx > widths[cidx] ){
                cidx++;
                tidx=0;
            }
        }
        
        // turn off highlighting if requested
        if( i == currentIdx ){  attroff( A_STANDOUT ); }
    }

    while( crow <= maxY ){
            
        tidx=0;
        cidx=0;
        crow++;
        for( size_t j=0; j<=maxX; j++ ){

            // if starting a new block, print the bar
            if( tidx == 0 || j == maxX ){ mvprintw( crow, j, "|" ); }

            tidx++;
            if( tidx > widths[cidx] ){
                cidx++;
                tidx=0;
            }
        }
    }
}



