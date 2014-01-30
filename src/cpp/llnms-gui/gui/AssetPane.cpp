/**
 * @file    AssetPane.cpp
 * @author  Marvin Smith
 * @date    1/28/2014
 */
#include "AssetPane.hpp"

/**
 * Constructor for AssetPane class
 */
AssetPane::AssetPane( QWidget* parent ) : QWidget( parent ){

    // build main widget
    mainLayout = new QVBoxLayout;
    mainLayout->setAlignment( Qt::AlignLeft | Qt::AlignTop );

    // build main label
    mainLabel = new QLabel("LLNMS Asset Management Page");
    mainLabel->setFont(QFont(mainLabel->font().family(), 18));
    mainLayout->addWidget( mainLabel );

    // set layout
    setLayout( mainLayout );


}


