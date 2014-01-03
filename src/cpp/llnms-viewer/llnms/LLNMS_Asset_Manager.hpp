/**
 * @file   LLNMS_Asset_Manager.hpp
 * @author Marvin Smith
 * @date   12/31/2013
*/
#ifndef __SRC_CPP_LLNMSVIEWER_LLNMSASSETMANAGER_HPP__
#define __SRC_CPP_LLNMSVIEWER_LLNMSASSETMANAGER_HPP__

#include "LLNMS_Asset.hpp"
#include "../ui/Table.hpp"

#include <vector>

/**
 * @class  LLNMS_Asset_Manager
*/
class LLNMS_Asset_Manager{

    public:

        /** 
         * Default Constructor
        */
        LLNMS_Asset_Manager();
        
        /**
         *  Load the table with relevant data
         */
        void load_table( Table& table );

        /**
         * Update asset list
         */
        void update_asset_list();
        
        /**
         * Asset List
         */
        std::vector<LLNMS_Asset> asset_list;


}; // End of LLNMS_Asset_Manager class

#endif
