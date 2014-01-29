/**
 *  @file  DataContainer.hpp
 *  @author Marvin Smith
 *  @date  1/27/2014
*/
#ifndef __SRC_CPP_LLNMSGUI_CORE_DATACONTAINER_HPP__
#define __SRC_CPP_LLNMSGUI_CORE_DATACONTAINER_HPP__

#include "GUI_Settings.hpp"

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
        
        /**
         * Load the configuration file
         */
        void load( int argc, char* argv[], const std::string& filename );
        
        /**
         * Write configuration file
         */
        void write_config_file( );
        
        /**
         * Create baseline file structure
         */
        void create_file_structure();
       
        
        /// GUI Data Storage
        GUI_Settings gui_settings;

        /// Tells us if we found a config file
        bool config_file_found;


	

};


#endif

