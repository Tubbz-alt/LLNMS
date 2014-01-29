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

    /// create main widget
    mainWidget = new QWidget(this);

    /// create the main layout
    mainLayout = new QVBoxLayout;
    
    /// Create the navigation bar
    navigationBar = new NavigationBar;
    
    /// Create the stacked widget
    assetPane   = new AssetPane;
    networkPane = new NetworkPane;
    summaryPane = new SummaryPane;
    configPane  = new ConfigPane;
    
    stackedWidget = new QStackedWidget;
    stackedWidget->addWidget( summaryPane );
    stackedWidget->addWidget( networkPane );
    stackedWidget->addWidget( assetPane );
    stackedWidget->addWidget( configPane );

    /// add the layout items
    mainLayout->addWidget( navigationBar );
    mainLayout->addWidget( stackedWidget );

    // set the main widget
    mainWidget->setLayout( mainLayout );

    // set the main widget
    setCentralWidget( mainWidget );

}

