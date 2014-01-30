/**
 * @file MainWindow.hpp
 * @author Marvin Smith
 * @date   1/27/2014
 *
 * Main GUI Window Implementation
*/
#ifndef __SRC_CPP_LLNMSGUI_GUI_MAIN_WINDOW_HPP__
#define __SRC_CPP_LLNMSGUI_GUI_MAIN_WINDOW_HPP__

///  QT Libraries
#include <QApplication>
#include <QMainWindow>
#include <QStackedWidget>
#include <QWidget> 


/// LLNMS GUI Libraries
#include <core/DataContainer.hpp>
#include <core/MessagingService.hpp>

#include <gui/ConfigPane.hpp>
#include <gui/SummaryPane.hpp>
#include <gui/NetworkPane.hpp>
#include <gui/AssetPane.hpp>

#include <gui/NavigationBar.hpp>


extern DataContainer settings;
extern MessagingService message_service;

/**
 * @class MainWindow
*/
class MainWindow : public QMainWindow {

	Q_OBJECT
	
    public:
		
        /** 
	 * Default Constructor 
	*/
	MainWindow(  );
	
    private slots:
        
        /**
         * Close the current Main Window, thus closing the entire GUI
        */
        void quit_program( );

    private:
	
	/******************************/
	/*     Private Functions      */
	/******************************/
    void build_ui();
	
    
    /******************************/
	/*     Private Variables      */
	/******************************/
    
    /// Main Widget
    QWidget*  mainWidget;

    /// Main Layout
    QHBoxLayout* mainLayout;

    /// Navigation Bar
    NavigationBar*     navigationBar;

    /// Stacked Widget
    QStackedWidget*  stackedWidget;

    /// Summary Pane
    SummaryPane*  summaryPane;

    /// Network Pane
    NetworkPane*  networkPane;

    /// Asset Pane
    AssetPane*    assetPane;
    
    /// Configuration Pane
    ConfigPane*   configPane;

};

#endif
