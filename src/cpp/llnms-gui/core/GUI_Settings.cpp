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


/**
 * GUI_Settings Default Constructor
 */
GUI_Settings::GUI_Settings( ){

    // set the application name
    app_name = "LLNMS-Viewer";
    
    // set the LLNMS Home Variable
    if( boost::filesystem::exists(getenv("LLNMS_HOME")) == false ){
        cout << "Setting LLNMS_HOME in gui-settings" << endl;
        LLNMS_HOME = "/var/tmp";
    } 

}


