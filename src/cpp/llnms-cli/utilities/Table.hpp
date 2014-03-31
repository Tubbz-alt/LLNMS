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
         * Get number of rows
         */
        int rows()const;

        /**
         * Get number of columns
         */
        int cols()const;
        
        /**
         * Clear Table Data
         */
        void clear();
        
        /**
         * Set the row count
         */
        void setRowCount( const int& rowCount );

        /**
         * Set header name
         *
         * @param[in] idx Index to set header name to
         * @param[in] hdr String to set data to
        */
        void setHeaderName( const int& idx, const std::string& hdr );
        
        /**
         * Set header ratio
         *
         * @param[in] idx Index to set ratio
         * @param[in] ratio Ratio of the column width.  Must be less than 1.
         */
        void setHeaderRatio( const int& idx, const double& ratio );

        /**
         * Set table data
         *
         * @param[in] col Column of the data
         * @param[in] row Row of the data
         * @param[in] strdata Data to set
        */
        void setData( const int& col, const int& row, const std::string& strdata );

        
        
        /**
         * Print table with highlighting and other stuff
         *
         * @param[in] minRow Row to start printing data
         * @param[in] maxRow Row to stop print data
         * @param[in] minCol Column to start printing data
         * @param[in] maxCol Column to stop printing data
         * @param[in] currentIdx Index to highlight, -1 will highlight nothing
         * @param[in] topItem  Top data row to print. 0 is the top.
        */
        void print( int const& minRow, 
                    int const& maxRow, 
                    int const& minCol, 
                    int const& maxCol,
                    const int& currentIdx = -1, 
                    const int& topItem = 0
                  );
        
        
        /**
         * Print header 
         *
         * @param[in]  row    Row to print header on
         * @param[in]  minCol Starting column to print on
         * @param[in]  maxCol Ending column to print on
         */
        void print_table_header( const int& row,
                                 const int& minCol,
                                 const int& maxCol
                               );
        
        /**
         * Print Table Data
         *
         * @param[in] minRow Starting row to print data
         * @param[in] maxRow Ending row to print data
         * @param[in] minCol Starting column to print data
         * @param[in] maxCol Ending column to print data
         */
        void print_table_data( const int& minRow,
                               const int& maxRow,
                               const int& minCol,
                               const int& maxCol,
                               const int& currentIdx = -1,
                               const int& topItem = 0
                             );

        
        /**
         * Get the printed table height
         */
        int getFullTableHeight()const;

    
    private:
        
        /**
         * Print header horizontal line
         *
         * @param[in] row    Row to print data
         * @param[in] startX Starting x position
         * @param[in] endX   Stopping x position
         * @param[in] widths Widths of each column
         */
        void print_outer_table_horizontal_bar( const int& row, 
                                          const int& minCol,
                                          const int& maxCol
                                         );

        /**
         * Reset Header Ratios
         *
         * This will fix the header ratio container.
        */
        void resetHeaderRatios();

        /**
         * Update Header Widths
         */
        void updateHeaderWidths( const int& maxColumn );

       
        /// Table Data
        std::vector<std::vector<std::string> > m_data;
        
        /// Headers
        std::vector<std::string> m_headers;
        
        /// Column ratios
        std::vector<double> m_headerRatios;

        /// Width of each column 
        std::vector<int> m_headerWidths;

};


#endif

