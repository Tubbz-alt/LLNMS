/**
 * @file   LLNMS_Asset_Manager.hpp
 * @author Marvin Smith
 * @date   12/31/2013
*/
#ifndef __SRC_CPP_LLNMSVIEWER_LLNMSASSETMANAGER_HPP__
#define __SRC_CPP_LLNMSVIEWER_LLNMSASSETMANAGER_HPP__

#include "LLNMS_Asset.hpp"
#include "../utilities/Table.hpp"

#include <string>
#include <vector>

#include "../utilities/FileUtilities.hpp"
#include "../utilities/Logger.hpp"

extern Logger logger;

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
         * Load the table with relevant asset state information
         */
        void load_asset_state_table( Table& table );

        /**
         *  Load the table with relevant asset information data
         */
        void load_asset_info_table( Table& table );

        /**
         * Update asset list
         */
        void update_asset_list();
        
        /**
         * Delete an LLNMS Asset
        */
        bool delete_asset( LLNMS_Asset const& asset2delete, std::string& message );

        /**
         * Asset List
         */
        std::vector<LLNMS_Asset> asset_list;


}; // End of LLNMS_Asset_Manager class

#endif