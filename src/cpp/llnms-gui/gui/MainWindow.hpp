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
#include <QDockWidget>
#include <QMainWindow>
#include <QMenu>
#include <QShortcut>
#include <QStatusBar>
#include <QtGui>
#include <QWidget> 

/// LLNMS GUI Libraries
#include <src/core/DataContainer.hpp>
#include <src/core/MessagingService.hpp>


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
        /**
         * Build the Status Bar at the Bottom of the Window
        */
        void build_status_bar();
	    
        /**
         * Filter relevant events
        */
        bool eventFilter( QObject* object, QEvent* event );

        /**
         * Create all connections
         */
        void build_connections();
        
};

#endif
