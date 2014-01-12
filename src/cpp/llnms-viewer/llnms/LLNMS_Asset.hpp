/**
 * @file    LLNMS_Asset.hpp
 * @author  Marvin Smith
 * @date    1/3/2014
 */
#ifndef __SRC_CPP_LLNMSVIEWER_LLNMS_LLNMSASSET_HPP__
#define __SRC_CPP_LLNMSVIEWER_LLNMS_LLNMSASSET_HPP__

#include <string>
#include <vector>

#include "../utilities/Logger.hpp"

extern Logger logger;

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

        std::string filename;
        std::string hostname;
        std::string ip4_address;
        std::string description;


}; /// End of LLNMS_Asset Class

#endif
