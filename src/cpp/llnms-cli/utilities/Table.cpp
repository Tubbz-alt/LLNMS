/**
 * @file    Table.cpp
 * @author  Marvin Smith
 * @date    1/2/2014
*/

/// LLNMS CLI Libraries
#include "Table.hpp"
#include <utilities/CursesUtilities.hpp>

/// NCurses
#include <ncurses.h>

/// Standard Libraries
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
 * Set header ratio
 */
void Table::setHeaderRatio( const int& idx, const double& ratio ){

    // if the ratio is greater than 1, skip
    if( ratio > 1 ){
        return;
    }

    // if the index is less than max
    if( idx > (headerRatios.size()-1) )
        return;

    // set ratio in index
    headerRatios[idx] = ratio;
    
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
 * Print table header line
 */
void Table::print_outer_table_horizontal_bar( const int& row, 
                                              const int& startX, 
                                              const int& endX,
                                              std::vector<int>const& widths 
                                            ){

    // print header bar
    int tidx=0;
    int cidx=0;
    for( size_t i=startX; i<=endX; i++ ){
        
        /**
         * Print corner
         */
        if( tidx == 0 || i == endX ){
            mvaddch( row, i, '+' );
        }

        /**
         * Print horizontal line
         */
        else{
            mvaddch( row, i, '-' );
        }

        /// increment temp index
        tidx++;
        if( tidx > widths[cidx] ){
            tidx=0;
            cidx++;
        }

    }

}


/**
 * Print table
*/
void Table::print( const int& row, const int& maxX, const int& maxY, const int& currentIdx, const int& topItem ){  
  
    // current index
    int cIdx=0;

    // compute the width of each section
    int maxWidth = 1;
    vector<int> widths(headers.size());
    for( size_t i=0; i<widths.size(); i++ ){
         
         // set the width
         widths[i] = headerRatios[i] * maxX;
         maxWidth += widths[i];
    }
    
    // the max width is either maxX or the farthest width, whatever is smaller
    if( maxWidth > maxX )
        maxWidth = maxX;

    
    // print top bar
    int crow=row;
    
    // print top row
    print_outer_table_horizontal_bar( crow++, 0, maxWidth, widths ); 
    
    // print header row
    int tidx=0;
    int cidx=0;
    for( size_t i=0; i<=maxWidth; i++ ){

        // if starting a new block, print the bar
        if( tidx == 0 || i == maxWidth ){ mvprintw( crow, i, "|" ); }

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
    crow++;

    // print header bar
    print_outer_table_horizontal_bar( crow++, 0, maxWidth, widths );


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

        for( size_t j=0; j<=maxWidth; j++ ){
            
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

    while( crow <= (maxY-1) ){
            
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
    
    // print final row
    crow++;
    for( size_t i=0; i<=maxX; i++ ){
        mvaddch( crow, i, '-' );
    }
}


/**
 * Get the full, printed table height
 */
int Table::getFullTableHeight()const{
    
    int headerHeight = 2;
    int dataHeight   = 0;
    if( data.size() > 0 ){ dataHeight = data[0].size(); }

    return headerHeight + dataHeight;
}

