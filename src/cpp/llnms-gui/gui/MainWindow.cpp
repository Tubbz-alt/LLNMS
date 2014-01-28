/**
 * @file    MainWindow.cpp
 * @author  Marvin Smith
 * @date    1/28/2014
 */
#include "MainWindow.hpp"


/**
 * Default Constructor
 */
MainWindow::MainWindow() : QMainWindow() {

    /// set the window title
    setWindowTitle( settings.gui_settings.app_name.c_str());

    // initialize all of our connections
    connect( &message_service, SIGNAL(quit_program_signal()), this, SLOT(quit_program()));

}


void MainWindow::quit_program( ){
    QApplication::quit();
}


