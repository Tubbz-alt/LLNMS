/**
 * @file    DataContainer.cpp
 * @author  Marvin Smith
 * @date    1/28/2014
 */
#include "DataContainer.hpp"

#include <core/FileUtilities.hpp>
#include <core/Parser.hpp>

#include <cstdlib>
#include <fstream>
#include <iostream>
#include <string>

using namespace std;

/**
 * Default Constructor
 */
DataContainer::DataContainer( ){

}

/**
 * Load a configuration from file
 */
void DataContainer::load( int argc, char* argv[], const std::string& filename ){
    
    // check that the filename exists and if not, skip loading
    if( file_exists( filename ) == false ){
        
        write_config_file( );
        config_file_found = false;
        return;
    }

    config_file_found = true;

    // create the parser object
    PSR::Parser parser( argc, argv, filename );
    
    
    // get the icon home
    gui_settings.ICON_HOME = getenv("LLNMS_ICON_HOME")+string("/icons");

}

/**
 * Write the configuration file
 */
void DataContainer::write_config_file( ){
    
    string config_filename;

#ifdef _WIN32
    config_filename="options.cfg";
#else
    // if linux, then check for the home directory
    config_filename=string(getenv("HOME"))+string("/.gis_viewer/options.cfg");
    
    // if the file does not exist for linux, then create it
    create_file_structure( );
#endif
    
    // write the file
    ofstream fout;
    fout.open(config_filename.c_str());
    

    ///   Write the GUI Options
    fout << "#  LLNMS-Viewer" << endl;

    // close the file
    fout.close();


}

void DataContainer::create_file_structure( ){
    
#ifndef _WIN32
    if( file_exists(string(string(getenv("HOME"))+string("/.gis_viewer"))) == false ){
        system("mkdir $HOME/.gis_viewer");
    }
#endif

}
