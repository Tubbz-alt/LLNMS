/**
 * @file    GUI_Settings.hpp
 * @author  Marvin Smith
 * @date    1/28/2014
 *
*/
#ifndef __SRC_CORE_GUI_SETTINGS_HPP__
#define __SRC_CORE_GUI_SETTINGS_HPP__

#include <string>

class GUI_Settings{

    public:

        /**
         * Default Constructor
        */
        GUI_Settings();
        

        /// Name of the application [ INDEX 0 ]
        std::string app_name;
        
        /// LLNMS Icon Home
        std::string ICON_HOME;

};


#endif

