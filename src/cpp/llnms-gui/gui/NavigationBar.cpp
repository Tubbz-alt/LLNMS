/**
 * @file    NavigationBar.cpp
 * @author  Marvin Smith
 * @date    1/28/2014
 */
#include "NavigationBar.hpp"

/**
 * Constructor for NavigationBar class
 */
NavigationBar::NavigationBar( QWidget* parent ) : QWidget(parent){

    // create the main layout
    mainLayout = new QHBoxLayout;

    // create the home button
    homeButton = new QToolButton;
    homeButton->setText("Summary");
    mainLayout->addWidget( homeButton );

    
    // create the network button
    networkButton = new QToolButton;
    networkButton->setText("Networks");
    mainLayout->addWidget( networkButton );

    // create the asset button
    assetButton = new QToolButton;
    assetButton->setText("Assets");
    mainLayout->addWidget( assetButton );

    // create the config button
    configButton = new QToolButton;
    configButton->setText( "Settings");
    mainLayout->addWidget( configButton );

    // set the main layout
    setLayout( mainLayout );


}

