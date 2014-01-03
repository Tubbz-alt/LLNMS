/**
 * @file    Table.hpp
 * @author  Marvin Smith
 * @date    1/2/2014
*/
#ifndef __SRC_CPP_LLNMS_UI_TABLE_HPP__
#define __SRC_CPP_LLNMS_UI_TABLE_HPP__

#include <string>
#include <vector>

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
         * Print table
        */
        void print( int const& row, int const& maxX, int const& maxY );

    private:
        
        /// Table Data
        std::vector<std::vector<std::string> > data;
        
        /// Headers
        std::vector<std::string> headers;
        
        /// Column ratios
        std::vector<double> headerRatios;
};


#endif

