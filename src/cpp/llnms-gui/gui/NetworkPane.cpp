/**
 * @file    NetworkPane.cpp
 * @author  Marvin Smith
 * @date    1/28/2014
 */
#include "NetworkPane.hpp"

#include "CreateNetworkDialog.hpp"

#include <core/StringUtilities.hpp>

#include <QHeaderView>
#include <QMessageBox>

#include <iostream>
#include <vector>

using namespace std;

/**
 * Constructor
 */
NetworkPane::NetworkPane( QWidget*  parent ) : QWidget( parent ){

    // build main widget
    mainLayout = new QVBoxLayout;
    mainLayout->setAlignment( Qt::AlignLeft | Qt::AlignTop );

    // build main label
    mainLabel = new QLabel("LLNMS Network Management Page");
    mainLabel->setFont(QFont(mainLabel->font().family(), 18));
    mainLayout->addWidget( mainLabel );

    // build network list widget
    build_network_list_widget();

    // build network scan widget
    build_network_scan_widget();
    
    // set layout
    setLayout( mainLayout );
    
    // connect our main messages
    connect( &message_service, SIGNAL(update_llnms()), this, SLOT(updatePanel()));

}


/**
 * Create the network list widget
 */
void NetworkPane::build_network_list_widget(){
    
    // create the network list label
    networkListLabel  = new QLabel("Network List");

    // add network list to main widget
    mainLayout->addWidget( networkListLabel );

    // create the widget
    networkListWidget = new QWidget(this);

    // create the layout
    networkListLayout = new QHBoxLayout;

    // create the table
    networkListTable = new QTableWidget(0, 4, networkListWidget);
    networkListTableHeaders.resize(4);
    networkListTableHeaders[0].setText("Select");
    networkListTableHeaders[1].setText("Name");
    networkListTableHeaders[2].setText("Address-Start");
    networkListTableHeaders[3].setText("Address-End");
    for( int i=0; i<networkListTableHeaders.size(); i++ ){
        networkListTable->setHorizontalHeaderItem( i, &networkListTableHeaders[i] );
    }

    // add table to network list widget
    networkListLayout->addWidget( networkListTable );

    // create the toolbar
    networkListToolbar = new QWidget(networkListWidget);
    
    // create the toolbar layout
    networkListToolbarLayout = new QVBoxLayout;
    networkListToolbarLayout->setAlignment( Qt::AlignTop );

    // create the add network button
    networkListCreateNetworkButton = new QToolButton;
    networkListCreateNetworkButton->setIcon(QIcon("icons/plus.png"));
    networkListCreateNetworkButton->setIconSize(QSize(40,40));
    networkListCreateNetworkButton->setToolTip("Create a Network Definition");
    networkListToolbarLayout->addWidget( networkListCreateNetworkButton );
    connect( networkListCreateNetworkButton, SIGNAL(clicked()), this, SLOT(createNewNetworkDialog()));

    // create the remove network button
    networkListRemoveNetworkButton = new QToolButton;
    networkListRemoveNetworkButton->setIcon(QIcon("icons/delete.png"));
    networkListRemoveNetworkButton->setIconSize(QSize(40,40));
    networkListRemoveNetworkButton->setToolTip("Delete a Network Definition");
    networkListToolbarLayout->addWidget( networkListRemoveNetworkButton );
    connect( networkListRemoveNetworkButton, SIGNAL(clicked()), this, SLOT(deleteSelectedNetworks()));

    
    // create the modify network button
    networkListModifyNetworkButton = new QToolButton;
    networkListModifyNetworkButton->setIcon(QIcon("icons/gear.png"));
    networkListModifyNetworkButton->setIconSize(QSize(40,40));
    networkListModifyNetworkButton->setToolTip("Modify a Network Definition");
    networkListToolbarLayout->addWidget( networkListModifyNetworkButton );

    // set the layout
    networkListToolbar->setLayout( networkListToolbarLayout );

    // add the toolbar to the main layout
    networkListLayout->addWidget( networkListToolbar );

    // set the main layout
    networkListWidget->setLayout( networkListLayout );

    // add the network list widget to the primary layout
    mainLayout->addWidget( networkListWidget );

    // load the table
    load_network_list_table();

}

/**
 * Create the network scan widget
 */
void NetworkPane::build_network_scan_widget(){
    
    // create the network list label
    networkScanLabel  = new QLabel("Network Scan Results");

    // add network list to main widget
    mainLayout->addWidget( networkScanLabel );

    // create the widget
    networkScanWidget = new QWidget(this);

    // create the layout
    networkScanLayout = new QHBoxLayout;

    // create the table
    networkScanTable = new QTableWidget(0, 4, networkScanWidget);
    networkScanTableHeaders.resize(4);
    networkScanTableHeaders[0].setText("No.");
    networkScanTableHeaders[1].setText("IP-Address");
    networkScanTableHeaders[2].setText("Hostname");
    networkScanTableHeaders[3].setText("Asset (y/n)");
    for( int i=0; i<networkScanTableHeaders.size(); i++ ){
        networkScanTable->setHorizontalHeaderItem( i, &networkScanTableHeaders[i] );
    }

    // add table to network list widget
    networkScanLayout->addWidget( networkScanTable );

    // set the main layout
    networkScanWidget->setLayout( networkScanLayout );

    // add the network list widget to the primary layout
    mainLayout->addWidget( networkScanWidget );


}
/**
 * Load the network list table
 */
void NetworkPane::load_network_list_table(){
    
    // clear the table
    networkListTable->clearContents();
    
    // refresh the LLNMS Network Table
    llnms.update();

    // get the list of networks
    std::deque<LLNMS::NETWORK::NetworkDefinition> network_definitions = llnms.m_network_module.network_definitions();
    
    // resize the table
    networkListTable->setRowCount( network_definitions.size()+1 );
    
    // create the all item
    networkListTable->setItem( 0, 0, new QTableWidgetItem( ));
    networkListTable->item(0, 0)->setCheckState(Qt::Unchecked);
    networkListTable->setItem( 0, 1, new QTableWidgetItem("All Networks"));

    // load the table
    for( size_t i=0; i<network_definitions.size(); i++ ){
        networkListTable->setItem( i+1, 0, new QTableWidgetItem( ));
        networkListTable->item(i+1, 0)->setCheckState(Qt::Unchecked);
        networkListTable->setItem( i+1, 1, new QTableWidgetItem( network_definitions[i].name().c_str()));
        networkListTable->setItem( i+1, 2, new QTableWidgetItem( network_definitions[i].address_start().c_str()));
        networkListTable->setItem( i+1, 3, new QTableWidgetItem( network_definitions[i].address_end().c_str()));
    }

    networkListTable->setColumnWidth(0, 40);

#if QT_VERSION > 0x050000
    networkListTable->horizontalHeader()->setSectionResizeMode( 1, QHeaderView::Stretch );
    networkListTable->horizontalHeader()->setSectionResizeMode( 2, QHeaderView::Stretch );
    networkListTable->horizontalHeader()->setSectionResizeMode( 3, QHeaderView::Stretch );
#else
    networkListTable->horizontalHeader()->setResizeMode( 1, QHeaderView::Stretch );
    networkListTable->horizontalHeader()->setResizeMode( 2, QHeaderView::Stretch );
    networkListTable->horizontalHeader()->setResizeMode( 3, QHeaderView::Stretch );
#endif
 
}

/**
 * Iterate through all networks in the network list and make sure
 * they are unchecked.
*/
void NetworkPane::uncheckNetworkListTable(){

    for( size_t i=0; i<networkListTable->rowCount(); i++ ){
        networkListTable->item(i,0)->setCheckState(Qt::Unchecked);
    }
}

void NetworkPane::createNewNetworkDialog(){
    
    // load the new network dialog
    CreateNetworkDialog  networkDialog;
    networkDialog.exec();
    
}

/**
 * Delete networks which have been selected
*/
void NetworkPane::deleteSelectedNetworks(){
    
    // sign to update the gui
    bool guiUpdated = false;
    bool deleteEverything = false;
    int  networkReferenceIndex = 0;

    // if the all network box is checked then delete everything
    if( networkListTable->item(0, 0)->checkState() == Qt::Checked ){
        deleteEverything = true;
    }

    // iterate through the list looking for networks which are checked
    for( size_t i=1; i<networkListTable->rowCount(); i++ ){
        if( deleteEverything == true || networkListTable->item(i, 0)->checkState() == Qt::Checked ){

            // check if we really want to delete this
            std::string note = std::string("Do you wish to delete the network \"") + networkListTable->item(i, 1)->text().toLocal8Bit().constData() + std::string("\"?");
            QMessageBox msgBox;
            msgBox.setText(note.c_str());
            msgBox.setInformativeText("Do you want to delete the network?");
            msgBox.setStandardButtons(QMessageBox::Yes | QMessageBox::No );
            msgBox.setDefaultButton(QMessageBox::Cancel);
            int ret = msgBox.exec();

            if( ret == QMessageBox::Yes ){

                // delete the network inside llnms
                std::string message;
                llnms.m_network_module.delete_network(networkReferenceIndex, message);
                guiUpdated = true;
            } else {
                networkReferenceIndex++;
            }
        }
    }

    // if the gui was updated, then update llnms
    if( guiUpdated == true ){
        llnms.update();
        updatePanel();
    }
    else{
        uncheckNetworkListTable();
    }
}


/**
 * Load the network scan table
 */
void NetworkPane::load_network_scan_table(){
    
    // clear the table
    networkScanTable->clearContents();
    
    // refresh the LLNMS Network Table
    //llnms.network_container.update();
    
    /*
    // get the list of networks
    std::vector<LLNMS_Network> networkScanningList = llnms.network_container.network_list();
    
    // resize the table
    networkListTable->setRowCount( networklist.size()+1 );
    
    // create the all item
    networkListTable->setItem( 0, 0, new QTableWidgetItem("All Networks"));

    // load the table
    for( size_t i=0; i<networklist.size(); i++ ){
        networkListTable->setItem( i+1, 0, new QTableWidgetItem( networklist[i].name().c_str()));
        networkListTable->setItem( i+1, 1, new QTableWidgetItem( networklist[i].address_start().c_str()));
        networkListTable->setItem( i+1, 2, new QTableWidgetItem( networklist[i].address_end().c_str()));
    }

#if QT_VERSION > 0x050000
    networkListTable->horizontalHeader()->setSectionResizeMode( 0, QHeaderView::Stretch );
    networkListTable->horizontalHeader()->setSectionResizeMode( 1, QHeaderView::Stretch );
    networkListTable->horizontalHeader()->setSectionResizeMode( 2, QHeaderView::Stretch );
#else
    networkListTable->horizontalHeader()->setResizeMode( 0, QHeaderView::Stretch );
    networkListTable->horizontalHeader()->setResizeMode( 1, QHeaderView::Stretch );
    networkListTable->horizontalHeader()->setResizeMode( 2, QHeaderView::Stretch );
#endif
    */
 
}

/**
 * Update the panel
 */
void NetworkPane::updatePanel(){
    
    // reload the network list table
    load_network_list_table();

    // reload the network scan table
    load_network_scan_table();

}

