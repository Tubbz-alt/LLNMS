/**
 * @file    llnms-gui.cpp
 * @author  Marvin Smith
 * @date    1/27/2014
*/

//  Qt Libraries
#include <QApplication>
#include <QtGui>
#include <QWidget>

//  LLNMS-Core Library
#include <LLNMS.hpp>

//  LLNMS-Viewer Libraries
#include <core/DataContainer.hpp>
#include <core/MessagingService.hpp>
#include <gui/MainWindow.hpp>

// C++ STL
#include <iostream>

/// Program Settings
DataContainer settings;

/// LLNMS State Container
LLNMS::LLNMS_State llnms;

/// Messaging Services
MessagingService message_service;


using namespace std;


/**
 * Main Function
*/
int main( int argc, char* argv[] ){

    try{
        
        /// Set the filename for the config file
        string filename;
        filename = string(getenv("HOME"))+string("/.llnms-gui/options.cfg");
        
        /// load the config parser
        settings.load( argc, argv, filename);
    
    } catch ( string e ){
        cout << e << endl;
        return 1;
    }
    
    ///  Set LLNMS Home
    llnms.set_LLNMS_HOME( settings.gui_settings.LLNMS_HOME );
    llnms.update();
    
    ///   Create the Qt Application
    QApplication app(argc, argv);

	///   Create main window
	MainWindow*  mainWindow = new MainWindow( );

	/// Display the main window
	mainWindow->show();
	
	/// Execute the application
	return app.exec();
}

