/**
 * @file    Table.hpp
 * @author  Marvin Smith
 * @date    1/2/2014
*/
#ifndef __SRC_CPP_LLNMSCLI_UI_TABLE_HPP__
#define __SRC_CPP_LLNMSCLI_UI_TABLE_HPP__

#include <sstream>
#include <string>
#include <vector>

#include <utilities/CursesUtilities.hpp>


/** 
 * @class Table
*/
class Table{

    public:
        
        /**
         * Default Constructor
        */
        Table();
        
        /**
         * Reset Ratios
        */
        void resetRatios();

        /**
         * Set header
        */
        void setHeaderName( const int& idx, const std::string& hdr );
        
        /**
         * Set header ratio
         */
        void setHeaderRatio( const int& idx, const double& ratio );

        /**
         * Set table data
        */
        void setData( const int& x, const int& y, const std::string& strdata );

        /**
         * Print table
        */
        void print( int const& row, int const& maxX, int const& maxY );
        
        /**
         * Print table with highlighting and other stuff
        */
        void print( int const& row, int const& maxX, int const& maxY, const int& currentIdx, const int& topItem );
        
        /**
         * Get the printed table height
         */
        int getFullTableHeight()const;

    private:
        
        /**
         * Print table line
         */
        void print_header_table_line( const int& row, 
                                      const int& maxWidth, 
                                      const std::vector<int>& widths 
                                    );
        
        /// Table Data
        std::vector<std::vector<std::string> > data;
        
        /// Headers
        std::vector<std::string> headers;
        
        /// Column ratios
        std::vector<double> headerRatios;
};


#endif

