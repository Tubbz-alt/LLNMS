/**
 * @file    GUI_Settings.cpp
 * @author  Marvin Smith
 * @date    1/28/2014
*/
#include "GUI_Settings.hpp"

#include <cstdlib>
#include <iostream>

#include <boost/filesystem.hpp>

using namespace std;

namespace bf=boost::filesystem;

/**
 * GUI_Settings Default Constructor
 */
GUI_Settings::GUI_Settings( ){

    // set the application name
    app_name = "LLNMS-Viewer";
    
    // set the LLNMS Home Variable
    LLNMS_HOME="/var/tmp/llnms";
    if( ( getenv("LLNMS_HOME") != NULL ) && ( bf::exists(getenv("LLNMS_HOME")) == true )){
        LLNMS_HOME = getenv("LLNMS_HOME");
    }

}


