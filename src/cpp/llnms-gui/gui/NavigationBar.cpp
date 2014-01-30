/**
 * @file    NavigationBar.cpp
 * @author  Marvin Smith
 * @date    1/28/2014
 */
#include "NavigationBar.hpp"

#include <iostream>
#include <string>

using namespace std;

/**
 * Constructor for NavigationBar class
 */
NavigationBar::NavigationBar( QWidget* parent ) : QWidget(parent){

    // create the main layout
    mainLayout = new QVBoxLayout;

    // create the home button
    homeButton = new QToolButton;
    homeButton->setText("Summary");
    homeButton->setIcon(QIcon(string("icons/summary.png").c_str()));
    homeButton->setIconSize( QSize( 60,60 ));
    homeButton->setFixedWidth( 85 );
    homeButton->setFixedHeight( 90 );
    homeButton->setToolButtonStyle( Qt::ToolButtonTextUnderIcon );
    mainLayout->addWidget( homeButton );

    
    // create the network button
    networkButton = new QToolButton;
    networkButton->setText("Networks");
    networkButton->setIcon(QIcon(string("icons/network.png").c_str()));
    networkButton->setIconSize(QSize(60,60));
    networkButton->setFixedWidth( 85 );
    networkButton->setFixedHeight( 90 );
    networkButton->setToolButtonStyle( Qt::ToolButtonTextUnderIcon );
    mainLayout->addWidget( networkButton );

    // create the asset button
    assetButton = new QToolButton;
    assetButton->setText("Assets");
    assetButton->setIcon(QIcon(string("icons/asset.png").c_str()));
    assetButton->setIconSize(QSize(60,60));
    assetButton->setFixedWidth( 85 );
    assetButton->setFixedHeight( 90 );
    assetButton->setToolButtonStyle( Qt::ToolButtonTextUnderIcon );
    mainLayout->addWidget( assetButton );

    // create the config button
    configButton = new QToolButton;
    configButton->setText( "Settings");
    configButton->setIcon(QIcon(string("icons/settings.png").c_str()));
    configButton->setIconSize(QSize(60,60));
    configButton->setFixedWidth( 85 );
    configButton->setFixedHeight( 90 );
    configButton->setToolButtonStyle( Qt::ToolButtonTextUnderIcon );
    mainLayout->addWidget( configButton );

    // set the main layout
    setLayout( mainLayout );


}

