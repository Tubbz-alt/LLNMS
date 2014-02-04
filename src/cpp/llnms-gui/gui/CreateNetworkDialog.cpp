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
    mainLayout->setAlignment( Qt::AlignTop );

    // create main label
    mainLabel = new QLabel("Create Network");
    mainLabel->setFont(QFont( mainLabel->font().family(), 16));
    mainLayout->addWidget( mainLabel );

    /// create the name widget
    build_name_widget();

    /// create the start widget
    build_start_widget();

    /// create the end widget
    build_end_widget();
    
    /// create the toolbar widget
    build_toolbar_widget();

    // set layout
    setLayout( mainLayout );


}

void CreateNetworkDialog::build_name_widget(){
    
    // create name widget
    networkNameWidget = new QWidget;

    // create the layout
    networkNameLayout = new QHBoxLayout;
    networkNameLayout->setAlignment( Qt::AlignLeft );

    networkNameLabel  = new QLabel("Name:");
    networkNameLabel->setFixedWidth( 120 );
    networkNameLayout->addWidget( networkNameLabel );

    networkNameEdit   = new QLineEdit();
    networkNameEdit->setFixedWidth( 150 );
    networkNameLayout->addWidget( networkNameEdit );

    networkNameWidget->setLayout( networkNameLayout );
    mainLayout->addWidget( networkNameWidget );


}

void CreateNetworkDialog::build_start_widget(){
    
    // create the start widget
    networkStartWidget = new QWidget;

    // create the layout
    networkStartLayout = new QHBoxLayout;
    networkStartLayout->setAlignment( Qt::AlignLeft );

    // create the label
    networkStartLabel  = new QLabel("Starting Address:");
    networkStartLabel->setFixedWidth( 120 );
    networkStartLayout->addWidget( networkStartLabel );

    // create the eidt
    networkStartEdit = new QLineEdit;
    networkStartEdit->setFixedWidth( 150 );
    networkStartLayout->addWidget( networkStartEdit );

    // set the layout
    networkStartWidget->setLayout( networkStartLayout );

    mainLayout->addWidget( networkStartWidget );
}

void CreateNetworkDialog::build_end_widget(){
    
    // create the end widget
    networkEndWidget = new QWidget;

    // create the layout
    networkEndLayout = new QHBoxLayout;
    networkEndLayout->setAlignment( Qt::AlignLeft );

    // create the label
    networkEndLabel  = new QLabel("Ending Address:");
    networkEndLabel->setFixedWidth( 120 );
    networkEndLayout->addWidget( networkEndLabel );

    // create the edit
    networkEndEdit = new QLineEdit;
    networkEndEdit->setFixedWidth( 150 );
    networkEndLayout->addWidget( networkEndEdit );

    // set the layout
    networkEndWidget->setLayout( networkEndLayout );

    mainLayout->addWidget( networkEndWidget );

}

void CreateNetworkDialog::build_toolbar_widget(){

    /// create the toolbar widget
    toolbarWidget = new QWidget;

    /// create the toolbar layout
    toolbarLayout = new QHBoxLayout;
    toolbarLayout->setAlignment( Qt::AlignLeft );

    /// create the save button
    toolbarSaveButton = new QToolButton;
    toolbarSaveButton->setIcon(QIcon("icons/save.png"));
    toolbarSaveButton->setIconSize(QSize(50,50));
    toolbarSaveButton->setFixedWidth(60);
    toolbarSaveButton->setFixedHeight(60);
    toolbarLayout->addWidget( toolbarSaveButton );
    connect( toolbarSaveButton, SIGNAL(clicked()), this, SLOT(saveAndClose()));

    /// create the cancel button
    toolbarCancelButton = new QToolButton;
    toolbarCancelButton->setIcon(QIcon("icons/delete.png"));
    toolbarCancelButton->setIconSize(QSize(50,50));
    toolbarCancelButton->setFixedWidth(60);
    toolbarCancelButton->setFixedHeight(60);
    toolbarLayout->addWidget( toolbarCancelButton );
    connect( toolbarCancelButton, SIGNAL(clicked()), this, SLOT(close()));

    // set the layout
    toolbarWidget->setLayout( toolbarLayout );

    // add to main widget
    mainLayout->addWidget( toolbarWidget );

}

void CreateNetworkDialog::saveAndClose(){

    close();
}
