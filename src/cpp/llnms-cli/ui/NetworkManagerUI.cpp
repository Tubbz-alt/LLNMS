/**
 * @file    NetworkManagerUI.cpp
 * @author  Marvin Smith
 * @date    1/14/2014
 */

/// LLNMS CLI Libraries
#include "NetworkManagerUI.hpp"
#include <utilities/CursesUtilities.hpp>
#include <utilities/Table.hpp>


/// NCurses
#include <ncurses.h>


/// Standard Libraries
#include <deque>
#include <vector>

/**
 * Initialize Table
 */
void initialize_tables( Table& networkDefinitionTable, 
                        Table& networkScanningTable
                      ){

    // initialize the network definition table
    networkDefinitionTable.setHeaderName( 0, "Select" );
    networkDefinitionTable.setHeaderName( 1, "Network Name" );
    networkDefinitionTable.setHeaderName( 2, "Starting Address" );
    networkDefinitionTable.setHeaderName( 3, "Ending Address" );
    
    networkDefinitionTable.setHeaderRatio( 0, 0.05 );
    networkDefinitionTable.setHeaderRatio( 1, 0.35 );
    networkDefinitionTable.setHeaderRatio( 2, 0.30 );
    networkDefinitionTable.setHeaderRatio( 3, 0.30 );
    
    // initialize the network scanning table
    networkScanningTable.setHeaderName( 0, "Select" );
    networkScanningTable.setHeaderName( 1, "IP4-Address" );
    networkScanningTable.setHeaderName( 2, "Status");
    networkScanningTable.setHeaderName( 3, "Last Checked" );

    networkScanningTable.setHeaderRatio( 0, 0.05 );
    networkScanningTable.setHeaderRatio( 1, 0.35 );
    networkScanningTable.setHeaderRatio( 2, 0.30 );
    networkScanningTable.setHeaderRatio( 3, 0.30 );

}

/**
 * Update the network definition table
 *
 * @param[in] table Table to update
 */
void update_network_definition_table( Table& table ){
    
    // load the data
    std::deque<LLNMS::NETWORK::NetworkDefinition> network_definitions = state.m_network_module.network_definitions();   
    for( size_t i=0; i<network_definitions.size(); i++ ){
        table.setData( 1, i, network_definitions[i].name() );
        table.setData( 2, i, network_definitions[i].address_start() );
        table.setData( 3, i, network_definitions[i].address_end() );
    }
}

/**
 * Update the network scanning table
 */
void update_network_scanning_table( Table& table ){

    // update LLNMS
    std::vector<LLNMS::NETWORK::NetworkHost> network_hosts = state.m_network_module.scanned_network_hosts();
    for( size_t i=0; i<network_hosts.size(); i++ ){
        table.setData( 1, i, network_hosts[i].ip4_address() );
    }


}

/**
 * Print network manager footer
 */
void print_network_manager_footer( const int& maxX, const int& maxY ){
    
    /// print the horizontal line
    print_single_char_line( '-', maxY-3, 0, maxX );

    // print the first row
    mvprintw( maxY-2, 0, "q/Q: Back to main menu.  u/U: Update Tables. ");
    mvprintw( maxY-1, 0, "s/S: Switch to network list.");

}


/**
 * Print the network list
 *
 * @param[in] table Table to print
 * @param[in] minY Starting row to print table data
 * @param[in] maxY Ending row to print table data
 */
void print_network_list( Table& table, 
                         const int& minY, 
                         const int& maxY 
                       ){
    
    // print the header
    mvprintw( minY, 0, "Network Definition List" );
    
    

    // print the table
    table.print( minY+1, maxY, 0, options.maxX-1 ); 

}

/**
 * Print the network scan results
 *
 * @param[in] table Table to print
 * @param[in] minY Starting row to print table data
 * @param[in] maxY Ending row to print table data
 */
void print_network_scan_results( Table& table, 
                                 const int& minY, 
                                 const int& maxY 
                               ){

    // print the header
    mvprintw( minY, 0, "Network Scanning Results" );

    // print the table
    table.print( minY+1, maxY, 0, options.maxX-1 );

}


/**
 * Network Manager UI
 */
void network_manager_ui(){
    
    // list of indeces for managing where stuff is
    int networkListWindowTop=3;
    int networkListWindowBot = (options.maxY / 2)-2;

    int networkScanWindowTop = networkListWindowBot+2;
    int networkScanWindowBot = options.maxY - 4;
    
    // Network Tables
    Table networkDefinitionTable;
    Table networkScanningTable;
    initialize_tables( networkDefinitionTable, networkScanningTable );
    update_network_definition_table( networkDefinitionTable );

    // start a loop
    bool EXIT_LOOP=false;
    while( EXIT_LOOP == false ){


        // clear the screen
        clear();

        // print header
        print_header("LLNMS Network Manager");

        // print the network list
        print_network_list( networkDefinitionTable, 
                            networkListWindowTop, 
                            networkListWindowBot );

        // print the network scanning results
        print_network_scan_results( networkScanningTable, 
                                    networkScanWindowTop, 
                                    networkScanWindowBot );
        
        // print footer
        print_network_manager_footer( options.maxX, options.maxY );

        // refresh the screen
        refresh();

        // grab the character
        int ch = getch();

        switch(ch){
            
            /// Update 
            case 'u':
                state.m_network_module.update();
                update_network_definition_table( networkDefinitionTable );
                update_network_scanning_table( networkScanningTable );
                break;

            /// Exit Menu
            case 'q':
                EXIT_LOOP=true;
                break;



        }

    }


}

