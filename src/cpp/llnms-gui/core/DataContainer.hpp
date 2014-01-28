/**
 *  @file  DataContainer.hpp
 *  @author Marvin Smith
 *  @date  1/27/2014
*/
#ifndef __SRC_CPP_LLNMSGUI_CORE_DATACONTAINER_HPP__
#define __SRC_CPP_LLNMSGUI_CORE_DATACONTAINER_HPP__

#include "AssetSettings.hpp"
#include "BrowserSettings.hpp"
#include "GUI_Settings.hpp"

#include "TempData.hpp"

#include <string>

/**
 * @class DataContainer
 * 
 * Contains all of the required global data which is used by the program.
 * To add to your own widgets, just extern the class as shown in the main 
 * gui widgets.
*/
class DataContainer {

    public:

        /**
         * Default Constructor
        */
        DataContainer();
        
        void load( int argc, char* argv[], const std::string& filename );
        
        void print();

        void write_config_file( );
        
        void create_file_structure();
        
        /// Default Asset Settings
        AssetSettings asset_settings;

        /// Configuration data specific to the GUI
        GUI_Settings  gui_settings;
        
        /// Configuration data specific to GeoBrowsers
        Browser_Settings browser_settings;

        /// Temp Data Storage
        TempData      temp_data;

        /// Tells us if we found a config file
        bool config_file_found;

    private:
	

};


#endif

