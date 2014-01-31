/**
 * @file    CreateNetworkDialog.cpp
 * @author  Marvin Smith
 * @date    1/30/2014
 */
#include "CreateNetworkDialog.hpp"


/**
 * Constructor
 */
CreateNetworkDialog::CreateNetworkDialog( QWidget* parent ) : QDialog(parent){

    // create layout
    mainLayout = new QVBoxLayout;

    // create main label
    mainLabel = new QLabel("Create Network");
    mainLayout->addWidget( mainLabel );

    // set layout
    setLayout( mainLayout );


}

