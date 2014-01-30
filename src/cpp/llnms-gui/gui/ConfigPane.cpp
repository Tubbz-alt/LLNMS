/**
 * @file    ConfigPane.cpp
 * @author  Marvin Smith
 * @date    1/28/2014
 */
#include "ConfigPane.hpp"


/**
 * Default Constructor
 */
ConfigPane::ConfigPane( QWidget* parent ) : QWidget(parent){


    // build main widget
    mainLayout = new QVBoxLayout;
    mainLayout->setAlignment( Qt::AlignLeft | Qt::AlignTop );

    // build main label
    mainLabel = new QLabel("LLNMS Configuration Management");
    mainLabel->setFont(QFont(mainLabel->font().family(), 18));
    mainLayout->addWidget( mainLabel );

    // set layout
    setLayout( mainLayout );


}



