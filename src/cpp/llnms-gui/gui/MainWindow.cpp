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

    /**
     * Build Widget
     */
    build_ui();

    // initialize all of our connections
    connect( &message_service, SIGNAL(quit_program_signal()), this, SLOT(quit_program()));
    

}


/**
 * Quit Program
 */
void MainWindow::quit_program( ){
    QApplication::quit();
}


/**
 * Build UI Components
 */
void MainWindow::build_ui(){

    /// create the main layout

}

