/**
 * @file    LLNMS_Asset.hpp
 * @author  Marvin Smith
 * @date    1/3/2014
 */
#ifndef __SRC_CPP_LLNMSVIEWER_LLNMS_LLNMSASSET_HPP__
#define __SRC_CPP_LLNMSVIEWER_LLNMS_LLNMSASSET_HPP__

#include <string>
#include <utility>
#include <vector>


#include "../utilities/Logger.hpp"
#include "../utilities/Table.hpp"


extern Logger logger;


/**
 * @class LLNMS_Asset_Scanner
 */
class LLNMS_Asset_Scanner{

    public:
        
        /**
         * Default Constructor
         */
        LLNMS_Asset_Scanner();

        /**
         *  Parameterized Constructor
         */
        LLNMS_Asset_Scanner( const std::string& scanner_id, const std::vector<std::pair<std::string,std::string> >& argument_list );
        
        /**
         * Get the argument list
         */
        std::vector<std::pair<std::string,std::string> > argument_list()const;
        
        /**
         * Set the argument list
         */
        std::vector<std::pair<std::string,std::string> >&  argument_list();


        /**
         * Get the scanner id
         */
        std::string scanner_id()const;

        /**
         * Set the scanner id
         */
        std::string& scanner_id();
        
        /**
         * Convert the scanner to a curses table
         */
        Table toTable()const;

    private:

        ///  Scanner ID
        std::string m_scanner_id;

        ///  Argument list
        std::vector<std::pair<std::string,std::string> > m_argument_list;


}; ///  End of LLNMS_Asset_Scanner Class


/**
 * @class LLNMS_Asset
 */
class LLNMS_Asset{

    public:
        
        /**
         * Default Constructor
        */
        LLNMS_Asset();
        
        /**
         * Default Constructor Given Filename to Load
         * 
         * @filename  llnms-asset.xml file to load.
        */
        LLNMS_Asset( std::string const& filename );
        
        /**
         * Get the scanner list
         */
        std::vector<LLNMS_Asset_Scanner> scanner_list()const;

        ///  Asset Filename
        std::string filename;

        ///  Asset Hostname
        std::string hostname;

        ///  Asset IP4 Address
        std::string ip4_address;

        ///  Asset Description
        std::string description;

    private:
    
        /// Registered Scanner List
        std::vector<LLNMS_Asset_Scanner> m_scanner_list;


}; /// End of LLNMS_Asset Class

#endif
