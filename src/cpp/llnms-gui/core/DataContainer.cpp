/**
 * @file    DataContainer.cpp
 * @author  Marvin Smith
 * @date    1/28/2014
 */
#include "DataContainer.hpp"

#include <src/core/Parser.hpp>

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
    if( GIS::file_exists( filename ) == false ){
        
        write_config_file( );
        config_file_found = false;
        return;
    }

    config_file_found = true;

    // create the parser object
    PSR::Parser parser( argc, argv, filename );

    bool found;
    string str_value;
    int int_value;
    double double_value;

    // look for GUI settings
    int_value = parser.getItem_int("MAIN_RIBBON_BUTTON_WIDTH", found );
    if( found == true ){ gui_settings.mainRibbonButtonWidth = int_value; }
    
    int_value = parser.getItem_int("MAIN_RIBBON_BUTTON_HEIGHT", found );
    if( found == true ){ gui_settings.mainRibbonButtonHeight = int_value; }
    
    int_value = parser.getItem_int("MINI_RIBBON_BUTTON_HEIGHT", found );
    if( found == true ){ gui_settings.miniRibbonButtonHeight = int_value; }

    int_value = parser.getItem_int("MAIN_RIBBON_BUTTON_FONT_SIZE", found );
    if( found == true ){ gui_settings.mainRibbonButtonFontSize = int_value; }
    
    int_value = parser.getItem_int("MINI_RIBBON_BUTTON_FONT_SIZE", found );
    if( found == true ){ gui_settings.miniRibbonButtonFontSize = int_value; }

    //  look for browser settings
    double_value = parser.getItem_double("GEOBROWSER_DEFAULT_LAT", found );
    if( found == true ){ browser_settings.default_lat = double_value; }

    double_value = parser.getItem_double("GEOBROWSER_DEFAULT_LON", found );
    if( found == true ){ browser_settings.default_lon = double_value; }

    int_value = parser.getItem_int("GEOBROWSER_DEFAULT_MAP",found);
    if( found == true ){ browser_settings.default_map = int_value; }

    // look for asset settings
    
    /// Base path
    str_value = parser.getItem_string("ASSET_MANAGER_DEFAULT_BASE_PATH", found );
    if( found == true ){ asset_settings.default_base_path = str_value; }
    else{ asset_settings.default_base_path = string(getenv("HOME")) + "/Desktop"; }
    
    /// Filter Path
    str_value = parser.getItem_string("ASSET_MANAGER_DEFAULT_FILTER_PATH", found );
    if( found == true ){ asset_settings.default_filter_path = str_value; }
    else{ 
        asset_settings.default_filter_path = string(getenv("HOME")) + "/.gis_viewer/asset_filters"; 
        system("mkdir -p ~/.gis_viewer/asset_filters");    
    }
    
    /// Load Asset Filters
    asset_settings.load_global_filters();


}

void DataContainer::print(){

    cout << "Data Container" << endl;
    cout << endl;
    gui_settings.print();
    cout << endl;
    browser_settings.print();

}

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
    fout << "#   Width of the Main Ribbon Widget" << endl;
    fout << "MAIN_RIBBON_BUTTON_WIDTH=" << gui_settings.mainRibbonButtonWidth << endl;
    fout << endl;
    fout << "#   Height of the Main Ribbon Widget" << endl;
    fout << "MAIN_RIBBON_BUTTON_HEIGHT=" << gui_settings.mainRibbonButtonHeight << endl;
    fout << endl;
    fout << "#   Height of the Mini Ribbon Widget.  Note:  The width will be the same as the main" << endl;
    fout << "MINI_RIBBON_BUTTON_HEIGHT=" << gui_settings.miniRibbonButtonHeight << endl;
    fout << endl;
    fout << "#   Font Size of the Text in the Ribbon Buttons" << endl;
    fout << "MAIN_RIBBON_BUTTON_FONT_SIZE=" << gui_settings.mainRibbonButtonFontSize << endl;
    fout << endl;
    fout << "#   Font Size of the Text in the Ribbon Buttons" << endl;
    fout << "MINI_RIBBON_BUTTON_FONT_SIZE=" << gui_settings.miniRibbonButtonFontSize << endl;
    fout << endl;
    
    ///   Write the Browser Settings
    fout << "#   Default Latitude for GeoBrowser" << endl;
    fout << "GEOBROWSER_DEFAULT_LAT=" << browser_settings.default_lat << endl;
    fout << endl;

    fout << "#   Default Longitude for GeoBrowser" << endl;
    fout << "GEOBROWSER_DEFAULT_LON=" << browser_settings.default_lon << endl;
    fout << endl;

    fout << "#   Default Map for GeoBrowser" << endl;
    fout << "#   0 - Google Maps" << endl;
    fout << "#   1 - Open Street Maps" << endl;
    fout << "GEOBROWSER_DEFAULT_MAP=" << browser_settings.default_map << endl;
    fout << endl;
    
    /// Write the asset manager settings
    fout << "#   Default Base Path for Asset Manager" << endl;
    fout << "ASSET_MANAGER_DEFAULT_BASE_PATH=" << asset_settings.default_base_path << endl;
    fout << endl;

    fout << "#   Default Path For Asset Filters" << endl;
    fout << "ASSET_MANAGER_DEFAULT_FILTER_PATH=" << asset_settings.default_filter_path << endl;
    fout << endl;

    // close the file
    fout.close();


}

void DataContainer::create_file_structure( ){
    
#ifndef _WIN32
    if( GIS::file_exists(string(string(getenv("HOME"))+string("/.gis_viewer"))) == false ){
        system("mkdir $HOME/.gis_viewer");
    }
#endif

}
