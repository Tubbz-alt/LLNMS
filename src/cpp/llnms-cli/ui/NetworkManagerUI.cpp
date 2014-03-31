/**
 * @file    NetworkManagerUI.cpp
 * @author  Marvin Smith
 * @date    1/14/2014
 */

/// LLNMS CLI Libraries
#include "NetworkManagerUI.hpp"
#include "CreateNetworkDefinitionUI.hpp"
#include "DeleteNetworkDefinitionUI.hpp"
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

    logger.add_message( "  -> Initializing Network Management Tables.", LOG_DEBUG );

    // initialize the network definition table
    networkDefinitionTable.setHeaderName( 0, "Select" );
    networkDefinitionTable.setHeaderName( 1, "Network Name" );
    networkDefinitionTable.setHeaderName( 2, "Starting Address" );
    networkDefinitionTable.setHeaderName( 3, "Ending Address" );
    
    networkDefinitionTable.setHeaderRatio( 0, 0.03 );
    networkDefinitionTable.setHeaderRatio( 1, 0.35 );
    networkDefinitionTable.setHeaderRatio( 2, 0.31 );
    networkDefinitionTable.setHeaderRatio( 3, 0.31 );
    
    // initialize the network scanning table
    networkScanningTable.setHeaderName( 0, "IP4-Address" );
    networkScanningTable.setHeaderName( 1, "Status");
    networkScanningTable.setHeaderName( 2, "Last Checked" );

    networkScanningTable.setHeaderRatio( 0, 0.40 );
    networkScanningTable.setHeaderRatio( 1, 0.30 );
    networkScanningTable.setHeaderRatio( 2, 0.30 );

}

/**
 * Update the network definition table
 *
 * @param[in] table Table to update
 */
void update_network_definition_table( Table& table ){
    
    logger.add_message("  -> Updating the network definition table.", LOG_DEBUG );
    
    // set the all networks position
    table.setData( 1, 0, "All Networks");
    
    // load the data
    std::deque<LLNMS::NETWORK::NetworkDefinition> network_definitions = state.m_network_module.network_definitions();   
    for( size_t i=0; i<network_definitions.size(); i++ ){
        table.setData( 1, i+1, network_definitions[i].name() );
        table.setData( 2, i+1, network_definitions[i].address_start() );
        table.setData( 3, i+1, network_definitions[i].address_end() );
    }
    
}

/**
 * Update the network scanning table
 */
void update_network_scanning_table( Table& table ){

    // update LLNMS
    logger.add_message("  -> Updating the network scanning table.", LOG_DEBUG );
    std::vector<LLNMS::NETWORK::NetworkHost> network_hosts = state.m_network_module.scanned_network_hosts();
    for( size_t i=0; i<network_hosts.size(); i++ ){
        table.setData( 0, i, network_hosts[i].ip4_address() );
    }


}

/**
 * Print network manager footer
 */
void print_network_manager_footer( const int& maxX, const int& maxY, int const& networkPaneIndex ){
    
    /// print the horizontal line
    print_single_char_line( '-', maxY-3, 0, maxX );

    // if we are on the Network Definition Table
    if( networkPaneIndex == 0 ){
        mvprintw( maxY-2, 0, std::string("Arrow Keys: Navigate Rows.  q: Back to main menu.  u: Update Tables. ").c_str());
        mvprintw( maxY-1, 0, std::string("s: Switch to Network Scanning Table.  c: Create Network Definition.  d: Delete Network Definition").c_str());
    } else if( networkPaneIndex == 1 ){
        mvprintw( maxY-2, 0, std::string("Arrow Keys: Navigate Rows.  q: Back to main menu.  u: Update Tables. ").c_str());
        mvprintw( maxY-1, 0, std::string("s: Switch to Network Definition Table.  c: Create Network Definition.").c_str());
    }


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
                         const int& maxY,
                         const bool& inFocus,
                         const int& currentIndex
                       ){
    
    int idx = -1;
    if( inFocus == true ){
        idx = currentIndex;
    }

    // print the header
    mvprintw( minY, 0, "Network Definition List" );
    
    // print the table
    table.print( minY+1, maxY, 0, options.maxX-1, idx ); 

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
                                 const int& maxY,
                                 const bool& inFocus,
                                 const int& currentIndex
                               ){

    int idx = -1;
    if( inFocus == true ){
        idx = currentIndex;
    }

    // print the header
    mvprintw( minY, 0, "Network Scanning Results" );

    // print the table
    table.print( minY+1, maxY, 0, options.maxX-1, idx );

}


/**
 * Network Manager UI
 */
void network_manager_ui(){
    
    // print debugging message
    logger.add_message("Entering Network Management UI", LOG_DEBUG );

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

    // current network pane 
    int currentNetworkPaneIndex = 0;
    std::vector<int> networkPaneIndeces(2,0);


    // start a loop
    logger.add_message("  -> starting Network Management UI loop", LOG_DEBUG );
    bool EXIT_LOOP=false;
    while( EXIT_LOOP == false ){


        // clear the screen
        clear();

        // print header
        print_header("LLNMS Network Manager");

        // print the network list
        print_network_list( networkDefinitionTable, 
                            networkListWindowTop, 
                            networkListWindowBot, 
                            (currentNetworkPaneIndex == 0),
                            networkPaneIndeces[currentNetworkPaneIndex]
                          );

        // print the network scanning results
        print_network_scan_results( networkScanningTable, 
                                    networkScanWindowTop, 
                                    networkScanWindowBot,
                                    (currentNetworkPaneIndex == 0),
                                    networkPaneIndeces[currentNetworkPaneIndex]
                                  );
        
        // print footer
        print_network_manager_footer( options.maxX, options.maxY, currentNetworkPaneIndex );

        // refresh the screen
        refresh();

        // grab the character
        int ch = getch();

        switch(ch){
            
            /// Up Arrow Key
            case KEY_UP:
                
                if( networkPaneIndeces[currentNetworkPaneIndex] > 0 ){
                    networkPaneIndeces[currentNetworkPaneIndex]--;
                }
                break;
            
            /// Down Arrow Key
            case KEY_DOWN:
                
                // check against size of network definition table
                if( currentNetworkPaneIndex == 0 ){
                    if( networkPaneIndeces[0] < (networkDefinitionTable.rows()-1)){
                        networkPaneIndeces[0]++;
                    }
                }
                else if( currentNetworkPaneIndex == 1 ){
                    if( networkPaneIndeces[1] < (networkScanningTable.rows()-1)){
                        networkPaneIndeces[1]++;
                    }
                }

                break;

            /// switch focus
            case 's':
            case 'S':
                
                // switch the network panel focus
                currentNetworkPaneIndex++;
                if( currentNetworkPaneIndex > 1 ){
                    currentNetworkPaneIndex = 0;
                }

                break;

            /// delete
            case 'd':
            case 'D':
                if( currentNetworkPaneIndex == 0 && networkPaneIndeces[0] != 0 ){
                    delete_network_definition_ui(networkPaneIndeces[0]-1);
                }
                break;

            /// Update 
            case 'U':
            case 'u':
                state.m_network_module.update();
                update_network_definition_table( networkDefinitionTable );
                update_network_scanning_table( networkScanningTable );
                break;

            /// create network definition
            case 'c':
            case 'C':
                if( create_network_definition_ui() == true ){
                    state.m_network_module.update();
                    update_network_definition_table( networkDefinitionTable );
                    update_network_scanning_table( networkScanningTable );
                }
                break;

            /// Exit Menu
            case 'Q':
            case 'q':
                EXIT_LOOP=true;
                break;
        }

    }
    
    // print debugging message
    logger.add_message("Exiting Network Management UI", LOG_DEBUG );


}

