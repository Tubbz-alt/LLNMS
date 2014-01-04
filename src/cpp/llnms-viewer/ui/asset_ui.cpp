/**
 * @file    asset_ui.cpp
 * @author  Marvin Smith
 * @date    1/2/2014
*/
#include "asset_ui.hpp"
#include "curses_utils.hpp"

#include "Table.hpp"

#include <ncurses.h>
               

void create_llnms_asset_ui(){
    
    /**
     * Start a loop
    */
    bool EXIT_LOOP=false;
    while( EXIT_LOOP == false ){

        // clear the screen
        clear();

        // print the header
        for( int i=0; i<options.maxX; i++ ){
            mvaddch( 0, 0, parse_string("Create LLNMS Asset", i, 0, options.maxX, "CENTER" ) );          
        }

        // get a character


    }


}

void print_asset_footer(){

    for( int i=0; i<=options.maxX; i++ ){
       mvaddch( options.maxY-3, i, '-' );  
    }
    mvprintw( options.maxY-1, 0, " q: Exit Asset Pane");
    mvprintw( options.maxY,   0, " c: Create Asset"   );

}


/**
 * Asset Manager User Interface
*/
void asset_ui(){
    
    // start loop
    bool EXIT_LOOP=false;
    while( EXIT_LOOP == false ){
        
        // clear the screen
        clear();

        // print the header
        print_header("Asset Status and Configuration");
    
        /**
         * Create table
        */
        Table table;
        
        // update the asset list
        llnms_state.asset_manager.update_asset_list();

        // load the data
        llnms_state.asset_manager.load_table( table );

        // print the table data
        table.print( 2, options.maxX-1, options.maxY-4 );
        
        // print the footer
        print_asset_footer( );

        // refresh the screen
        refresh();

        // get the character
        int ch = getch();

        /**
         * Parse Switch
        */
        switch(ch){

            /**
             * Create Asset
            */
            case 'c':
            case 'C':
                create_llnms_asset_ui();
                break;

            /**
             * Back out of window
            */
            case 'q':
            case 'Q':
                EXIT_LOOP=true;
                break;


        }

    }

}
