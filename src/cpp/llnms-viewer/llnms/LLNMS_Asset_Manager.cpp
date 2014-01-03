/**
 * @file   LLNMS_Asset_Manager.cpp
 * @author Marvin Smith
 * @date   12/31/2013
*/
#include "LLNMS_Asset_Manager.hpp"

/**
 * Default Constructor
*/
LLNMS_Asset_Manager::LLNMS_Asset_Manager(){


}


void LLNMS_Asset_Manager::load_table( Table& table ){

    table.setHeaderName( 0, "Asset Name" );
    table.setHeaderName( 1, "IP4 Address" );
    table.setHeaderName( 2, "Hostname" );
    table.setHeaderName( 3, "Number Registered Scanners");


    /** 
     * start setting the internal data
     */
    
}

void LLNMS_Asset_Manager::update_asset_list(){

    // get a list of files in the llnms home directory


}

