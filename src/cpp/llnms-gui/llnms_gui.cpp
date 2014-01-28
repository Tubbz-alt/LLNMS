/**
 * @file    llnms-gui.cpp
 * @author  Marvin Smith
 * @date    1/27/2014
*/

//  Qt Libraries
#include <QApplication>
#include <QtGui>
#include <QWidget>

//  LLNMS-Viewer Libraries
#include <core/DataContainer.hpp>
#include <core/MessagingService.hpp>
#include <gui/MainWindow.hpp>


#include <iostream>

DataContainer settings;
MessagingService message_service;

using namespace std;

/**
 * Main Function
*/
int main( int argc, char* argv[] ){

    try{
        /// load the config parser
        string filename;
#ifdef _WIN32
        filename = "options.cfg";
#else
        filename = string(getenv("HOME"))+string("/.gis_viewer/options.cfg");
#endif
        settings.load( argc, argv, filename);
    } catch ( string e ){
        cout << e << endl;
        return 1;
    }
    
    ///   Create the Qt Application
    QApplication app(argc, argv);

	///   Create main window
	MainWindow*  mainWindow = new MainWindow( );

	/// Display the main window
	mainWindow->show();
	
	/// Execute the application
	return app.exec();
}

