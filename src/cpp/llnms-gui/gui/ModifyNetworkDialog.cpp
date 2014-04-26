/**
 * @file    ModifyNetworkDialog.cpp
 * @author  Marvin Smith
 * @date    4/25/2014
*/
#include "ModifyNetworkDialog.hpp"

/**
 * Default Constructor
*/
ModifyNetworkDialog::ModifyNetworkDialog( QWidget* parent ) : QDialog(parent){

    // set the window title
    setWindowTitle("Modify Network Information");

    // create the main layout
    mainLayout = new QVBoxLayout();
    mainLayout->setAlignment( Qt::AlignTop | Qt::AlignLeft );

    // create the name widget
    initNameWidget();

    // create the starting address widget
    initStartAddressWidget();

    // create the ending address widget
    initEndAddressWidget();
    
    // create the toolbar
    initToolbar();

    // set the layout
    setLayout( mainLayout );

}

/**
 * Create the name widget
*/
void ModifyNetworkDialog::initNameWidget(){

    // create the widget
    nameWidget = new QWidget(this);

    // create the layout
    nameLayout = new QHBoxLayout();
    
    // set the label
    nameLabel = new QLabel("Network Name:", this);
    nameLayout->addWidget(nameLabel);

    // set the edit
    nameEdit = new QLineEdit(this);
    nameLayout->addWidget(nameEdit);

    // set the button
    nameLockButton = new QToolButton(this);
    nameLockButton->setIcon(QIcon("icons/unlock.png"));
    nameLayout->addWidget(nameLockButton);

    // set the layout
    nameWidget->setLayout(nameLayout);

    // add to main widget
    mainLayout->addWidget(nameWidget);

}

/**
 * Create the start address widget
*/
void ModifyNetworkDialog::initStartAddressWidget(){
    
    // create the widget
    startAddressWidget = new QWidget(this);

    // create the layout
    startAddressLayout = new QHBoxLayout();

    // create the label
    startAddressLabel = new QLabel("Starting Address:");
    startAddressLayout->addWidget(startAddressLabel);

    // create the edit 
    startAddressEdit = new QLineEdit();
    startAddressLayout->addWidget(startAddressEdit);

    // create the unlock button
    startAddressLockButton = new QToolButton();
    startAddressLockButton->setIcon(QIcon("icons/unlock.png"));
    startAddressLayout->addWidget(startAddressLockButton);

    // set the layout
    startAddressWidget->setLayout(startAddressLayout);

    // add to main widget
    mainLayout->addWidget(startAddressWidget);


}


/**
 * Create the end address widget
*/
void ModifyNetworkDialog::initEndAddressWidget(){
    
    // create the widget
    endAddressWidget = new QWidget(this);

    // create the layout
    endAddressLayout = new QHBoxLayout();

    // create the label
    endAddressLabel = new QLabel("Ending Address:");
    endAddressLayout->addWidget(endAddressLabel);

    // create the line edit
    endAddressEdit = new QLineEdit();
    endAddressLayout->addWidget(endAddressEdit);

    // create lock button
    endAddressLockButton = new QToolButton();
    endAddressLockButton->setIcon(QIcon("icons/unlock.png"));
    endAddressLayout->addWidget(endAddressLockButton);

    // set the layout
    endAddressWidget->setLayout(endAddressLayout);

    // add to main widget
    mainLayout->addWidget(endAddressWidget);


}

/**
 * Create the init toolbar
*/
void ModifyNetworkDialog::initToolbar(){

    // create the widget
    toolbarWidget = new QWidget(this);

    // create the layout
    toolbarLayout = new QHBoxLayout();

    // create the save button
    modifyButton = new QToolButton();
    modifyButton->setText("Save Changes");
    toolbarLayout->addWidget(modifyButton);
    
    // create the cancel button
    cancelButton = new QToolButton();
    cancelButton->setText("Cancel");
    toolbarLayout->addWidget(cancelButton);

    // set the layout
    toolbarWidget->setLayout(toolbarLayout);

    // add to main layout
    mainLayout->addWidget(toolbarWidget);
}

