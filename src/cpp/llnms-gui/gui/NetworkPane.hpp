/**
 * @file    NetworkPane.hpp
 * @author  Marvin Smith
 * @date    1/28/2014
 */
#ifndef __SRC_CPP_LLNMSGUI_GUI_NETWORKPANE_HPP__
#define __SRC_CPP_LLNMSGUI_GUI_NETWORKPANE_HPP__

#include <QHBoxLayout>
#include <QLabel>
#include <QTableWidget>
#include <QTableWidgetItem>
#include <QToolButton>
#include <QVBoxLayout>
#include <QWidget>

#include <vector>

#include "../llnms/LLNMS_State.hpp"

extern LLNMS_State   llnms;

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
         * Rebuild the network list table
         */
        void load_network_list_table();
        
        /**
         * Create a new asset
         */
        void createNewNetworkDialog();

    private:    
        
        /*************************************/
        /*         Private Functions         */
        /*************************************/
        
        /**
         * Create the network list widget
         */
        void build_network_list_widget();

        
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



}; /// End of NetworkPane Class


#endif

