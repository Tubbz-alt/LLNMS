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

/**************************************************/
/*                Default Constructor             */
/**************************************************/
Table::Table(){

    // initialize data
    m_data.clear();
    m_headers.resize(1);
    m_headerRatios.resize(1);
    
    m_headerRatios[0] = 1;
}

/*************************************************/
/*            Get Number of Table Rows           */
/*************************************************/
int Table::rows()const{
    if( cols() == 0 ){ return 0; }

    return m_data[0].size();
}

/*************************************************/
/*            Get Number of Table Columns        */
/*************************************************/
int Table::cols()const{
    return m_data.size();
}

/***************************************************/
/*               Reset Header Ratios               */
/***************************************************/
void Table::resetHeaderRatios(){
    
    for( size_t i=0; i<m_headerRatios.size(); i++ ){
        m_headerRatios[i] = ((double)1/m_headerRatios.size());
    }

}


/**********************************************/
/*           Update Header Widths             */
/**********************************************/
void Table::updateHeaderWidths( const int& maxTableWidth ){

    // resize the header width
    m_headerWidths.resize(m_headerRatios.size());
    for( size_t i=0; i<m_headerRatios.size(); i++ ){
         m_headerWidths[i] = m_headerRatios[i] * maxTableWidth;
    }
}


/*********************************************/
/*            Set header name                */
/*********************************************/
void Table::setHeaderName( const int& idx, const std::string& hdr ){
    
    // if the header list is not big enough, resize
    if( m_data.size() <= (idx+1) ){
        m_data.resize(idx+1);
        m_headers.resize(idx+1);
        m_headerRatios.resize(idx+1);

        // reset the header ratios
        resetHeaderRatios();
    }

    // set text
    m_headers[idx] = hdr;

}


/*********************************************************/
/*                  Set header ratio                     */
/*********************************************************/
void Table::setHeaderRatio( const int& idx, const double& ratio ){

    // if the ratio is greater than 1, skip
    if( ratio > 1 ){
        return;
    }

    // if the index is less than max
    if( idx > (m_headerRatios.size()-1) )
        return;

    // set ratio in index
    m_headerRatios[idx] = ratio;
    
}


/***************************************************************************/
/*                          Set Table Data Item                            */
/***************************************************************************/
void Table::setData( const int& col, const int& row, const string& strdata ){

    if( m_data.size() <= col ){
        m_data.resize(col+1);
        for( size_t i=0; i<m_data.size(); i++ ){
            if( m_data[i].size() <= row ){
                m_data[i].resize(row+1);
            }
        }
    }
    if( m_data[col].size() <= row ){
        for( size_t i=0; i<m_data.size(); i++ ){
            if( m_data[i].size() <= row ){
                m_data[i].resize(row+1);
            }
        }
    }
    
    m_data[col][row]=strdata;
}


/**********************************************/
/*                 Print Table                */
/**********************************************/
void Table::print( const int& minRow, 
                   const int& maxRow,
                   const int& minCol,
                   const int& maxCol, 
                   const int& currentIdx, 
                   const int& topItem ){  

    
    /// update header widths
    updateHeaderWidths( maxCol-minCol );

    // compute the maximum width
    // the max width is either maxX or the farthest width, whatever is smaller
    int maxWidth = 1;
    for( size_t i=0; i<m_headerWidths.size(); i++ ){
         maxWidth += m_headerWidths[i];
    }
    if( maxWidth > (maxCol - minCol) )
        maxWidth = (maxCol - minCol);


    // current row
    int crow=minRow;
    
    // print top bar
    print_outer_table_horizontal_bar( crow++, minCol, maxWidth  ); 
    
    // print table header
    print_table_header( crow++, minCol, maxWidth );
    
    // print header bar
    print_outer_table_horizontal_bar( crow++, minCol, maxWidth );
    
    // print data table
    print_table_data( crow, maxRow, minCol, maxWidth, currentIdx  );

     
    // print final row
    print_outer_table_horizontal_bar( maxRow, minCol, maxWidth );
}


/******************************************************************/
/*                       Print Table Header                       */
/******************************************************************/
void Table::print_table_header( const int& row,
                                const int& minCol,
                                const int& maxCol
                              ){
    
    // print header row
    int tidx=0;
    int cidx=0;
    for( size_t i=minCol; i<=maxCol; i++ ){

        // if starting a new block, print a vertical bar
        if( tidx == 0 || i == maxCol ){ 
            mvprintw( row, i, "|" ); 
        }

        // if starting a new block, print a space after the bar
        else if( tidx == 1 ){ 
            mvprintw( row, i, " " ); 
        }
        
        // if ending a new block, print another space
        else if( tidx == (m_headerWidths[cidx])){ 
            mvprintw( row, i, " "); 
        }

        // otherwise print the string
        else{ 
            mvaddch( row, i, parse_string(m_headers[cidx], tidx-2, m_headerWidths[cidx]-3, "LEFT") ); 
        }
        
        tidx++;
        if( tidx > m_headerWidths[cidx] ){
            cidx++;
            tidx=0;
        }

    }
}


/******************************************************************************/
/*                           Print table header line                          */
/******************************************************************************/
void Table::print_outer_table_horizontal_bar( const int& row, 
                                              const int& minCol, 
                                              const int& maxCol
                                            ){

    // print header bar
    int tidx=0;
    int cidx=0;
    for( size_t i=minCol; i<=maxCol; i++ ){
        
        /**
         * Print corner
         */
        if( tidx == 0 || i == maxCol ){
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
        if( tidx > m_headerWidths[cidx] ){
            tidx=0;
            cidx++;
        }

    }

}


/*************************************************************************/
/*                              Print Table Data                         */
/*************************************************************************/
void Table::print_table_data( const int& minRow, 
                              const int& maxRow,
                              const int& minCol,
                              const int& maxCol,
                              const int& currentIdx,
                              const int& topItem
                             ){
    
    // if no data exists, then exit
    if( m_data.size() <= 0 ){
        return;
    }
    
    // temporary indeces 
    int tidx, cidx;
    int crow = minRow;
    int tableWidth = maxCol - minCol;

    
    // iterate over the data, printing
    for( size_t i=0; i<m_data[0].size(); i++ ){
        tidx=0;
        cidx=0;

        // turn on highlighting if requested
        if( i == currentIdx ){  
            attron( A_STANDOUT ); 
        }

        // print over the table
        for( size_t j=0; j<=tableWidth; j++ ){
            
            // if starting a new block, print the vertical bar
            if( tidx == 0 || j == tableWidth ){ 
                mvprintw( crow, j+minCol, "|" ); 
            }

            // if starting a new block, print a space after the bar
            else if( tidx == 1 ){ 
                mvprintw( crow, j+minCol, " " ); 
            }
        
            // if ending a new block, print another space
            else if( tidx == (m_headerWidths[cidx])){ 
                mvprintw( crow, j+minCol, " "); 
            }

            // otherwise print the string
            else{ 
                mvaddch( crow, j+minCol, parse_string(m_data[cidx][i], tidx-2, m_headerWidths[cidx]-3, "LEFT") ); 
            }

            tidx++;
            if( tidx > m_headerWidths[cidx] ){
                cidx++;
                tidx=0;
            }
        }
        
        // turn off highlighting if requested
        if( i == currentIdx ){  
            attroff( A_STANDOUT ); 
        }
        
        // increment the row
        crow++;
    }

    while( crow <= (maxRow-1) ){
            
        tidx=0;
        cidx=0;
        for( size_t j=0; j<=tableWidth; j++ ){

            // if starting a new block, print the bar
            if( tidx == 0 || j == tableWidth ){ mvprintw( crow, j+minCol, "|" ); }

            tidx++;
            if( tidx > m_headerWidths[cidx] ){
                cidx++;
                tidx=0;
            }
        }
        crow++;
    }
    

}


/**
 * Get the full, printed table height
 */
int Table::getFullTableHeight()const{
    
    int headerHeight = 2;
    int dataHeight   = 0;
    if( m_data.size() > 0 ){ dataHeight = m_data[0].size(); }

    return headerHeight + dataHeight;
}

