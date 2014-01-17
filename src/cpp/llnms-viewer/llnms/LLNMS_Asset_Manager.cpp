/**
 * @file   LLNMS_Asset_Manager.cpp
 * @author Marvin Smith
 * @date   12/31/2013
*/
#include "LLNMS_Asset_Manager.hpp"

#include <boost/filesystem.hpp>

#include <iostream>
#include <fstream>

using namespace std;

namespace fs = boost::filesystem;

/**
 * Default Constructor
*/
LLNMS_Asset_Manager::LLNMS_Asset_Manager(){


}


/**
 * Get asset state info
 */
void LLNMS_Asset_Manager::load_asset_state_table( Table& table ){

    // create the headers
    table.setHeaderName( 0, "Asset Hostname");
    table.setHeaderName( 1, "Network Status");
    table.setHeaderName( 2, "Last Update");

    // set data
    for( size_t i=0; i<asset_list.size(); i++ ){
        table.setData( 0, i, asset_list[i].hostname );
        table.setData( 1, i, asset_list[i].network_status() );
        table.setData( 2, i, "N/A");
    }

}

/**
 * Recover the asset information table.
 */
void LLNMS_Asset_Manager::load_asset_info_table( Table& table ){

    table.setHeaderName( 0, "Hostname" );
    table.setHeaderName( 1, "IP4 Address" );
    table.setHeaderName( 2, "Description" );


    /** 
     * start setting the internal data
     */
    for( size_t i=0; i<asset_list.size(); i++ ){
        table.setData( 0, i, asset_list[i].hostname );
        table.setData( 1, i, asset_list[i].ip4_address );
        table.setData( 2, i, asset_list[i].description );
    }


}

void LLNMS_Asset_Manager::update_asset_list(){
    
    logger.add_message( Message( "Updating the Asset List", Logger::LOG_NOTE ));

    asset_list.clear();

    // get a list of files in the llnms home directory
    fs::path baseDir("/var/tmp/llnms/assets");
    fs::directory_iterator end_iter;

    std::vector<std::string> file_list;

    if ( fs::exists(baseDir) && fs::is_directory(baseDir)){
        for( fs::directory_iterator dir_iter(baseDir) ; dir_iter != end_iter ; ++dir_iter){
            if (fs::is_regular_file(dir_iter->status()) ){
                string fname = dir_iter->path().string();

                if( fname.substr(fname.size()-15) == "llnms-asset.xml" ){
                    file_list.push_back( dir_iter->path().string() );
                }
            }
        }
    }   

    // open each llnms asset and extract the required info
    for( size_t i=0; i<file_list.size(); i++ ){
        asset_list.push_back( LLNMS_Asset( file_list[i] ));
    }
    
}

/**
 * Delete an LLNMS Asset
*/
bool LLNMS_Asset_Manager::delete_asset( const LLNMS_Asset& asset2delete, std::string& message ){
    
    // iterate through assets searching for a match
    for( size_t i=0; i<asset_list.size(); i++ ){
        if( asset_list[i].hostname    == asset2delete.hostname ){
        if( asset_list[i].ip4_address == asset2delete.ip4_address ){
            
            std::string command = string("llnms-remove-asset.sh -host ") + asset2delete.hostname;
            return run_command( command, message );
    }}}

    message = "Asset not found";
    return false;
}

