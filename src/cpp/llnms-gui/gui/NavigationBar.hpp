/**
 * @file    NavigationBar.hpp
 * @author  Marvin Smith
 * @date    1/28/2014
 */
#ifndef __SRC_CPP_LLNMSGUI_GUI_NAVIGATIONBAR_HPP__
#define __SRC_CPP_LLNMSGUI_GUI_NAVIGATIONBAR_HPP__

#include <QHBoxLayout>
#include <QToolButton>
#include <QWidget>


#include <core/DataContainer.hpp>

extern DataContainer settings;

/**
 * @class NavigationBar
 */
class NavigationBar : public QWidget{

    Q_OBJECT

    public:
        
        /**
         * Constructor
         */
        NavigationBar( QWidget* parent = NULL );
    
    
    signals:
        
        /**
         * Signal to return to the home menu
         */
        void summaryPaneButtonSignal();

        /**
         * Signal to return to network menu
         */
        void networkPaneButtonSignal();

        /**
         * Signal to return to asset menu
         */
        void assetPaneButtonSignal();

        /**
         * Signal to return to config menu
         */
        void configPaneButtonSignal();


    private:

        //---------------------------------//
        //-       Private Variables       -//
        //---------------------------------//
        
        /// Main Layout
        QVBoxLayout*  mainLayout;
        
        /// Home Button
        QToolButton*  homeButton;

        /// Network Button
        QToolButton*  networkButton;

        /// Asset Button
        QToolButton*  assetButton;

        /// Config Button
        QToolButton*  configButton;



}; /// End of NavigationBar class


#endif

