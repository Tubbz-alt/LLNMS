/**
 * @file    NetworkPane.hpp
 * @author  Marvin Smith
 * @date    1/28/2014
 */
#ifndef __SRC_CPP_LLNMSGUI_GUI_NETWORKPANE_HPP__
#define __SRC_CPP_LLNMSGUI_GUI_NETWORKPANE_HPP__

///  Qt Libraries
#include <QHBoxLayout>
#include <QLabel>
#include <QTableWidget>
#include <QTableWidgetItem>
#include <QToolButton>
#include <QVBoxLayout>
#include <QWidget>

/// LLNMS Core Library
#include <LLNMS.hpp>

/// C++ Libraries 
#include <vector>

/// LLNMS Gui Libraries
#include "../core/MessagingService.hpp"

/// LLNMS State Object
extern LLNMS::LLNMS_State llnms;

/// Messaging Services
extern MessagingService message_service;


/**
 * @class NetworkPane
 */
class NetworkPane : public QWidget{

    Q_OBJECT

    public:

        /**
         * NetworkPane Constructor
         */
        NetworkPane( QWidget* parent = NULL );


    public slots:
        
        /**
         * Update Widget
         */
        void updatePanel();

        /**
         * Rebuild the network list table
         */
        void load_network_list_table();
        
        /**
         * Rebuild the network scan table
         */
        void load_network_scan_table();

        /**
         * Create a new network
         */
        void createNewNetworkDialog();
        
        /**
         * Delete selected networks
         */
         void deleteSelectedNetworks();


    private:    
        
        /*************************************/
        /*         Private Functions         */
        /*************************************/
        
        /**
         * Create the network list widget
         */
        void build_network_list_widget();

        /**
         * Create the network scan result widget
         */
        void build_network_scan_widget();

        /**
         * Uncheck all items in the network list table
        */
        void uncheckNetworkListTable();

        /*************************************/
        /*         Private Variables         */
        /*************************************/

        // main layout
        QVBoxLayout*   mainLayout;

        // main label
        QLabel*        mainLabel;
        

        // network list label
        QLabel*        networkListLabel;
        
        // nework list widget
        QWidget*       networkListWidget;

        // network list layout
        QHBoxLayout*   networkListLayout;

        // network list table
        QTableWidget*  networkListTable;
        std::vector<QTableWidgetItem> networkListTableHeaders;
    
        // nework list toolbar
        QWidget*       networkListToolbar;

        // network list toolbar layout
        QVBoxLayout*   networkListToolbarLayout;

        // network list add network
        QToolButton*   networkListCreateNetworkButton;
        
        // network list remove network
        QToolButton*   networkListRemoveNetworkButton;

        // modify network
        QToolButton*   networkListModifyNetworkButton;
    
        /// Network Scan Label
        QLabel*        networkScanLabel;

        /// Network Scan Widget
        QWidget*       networkScanWidget;

        /// Network Scan Layout
        QHBoxLayout*   networkScanLayout;

        /// Network Scan Table
        QTableWidget*  networkScanTable;
        std::vector<QTableWidgetItem> networkScanTableHeaders;



}; /// End of NetworkPane Class


#endif

