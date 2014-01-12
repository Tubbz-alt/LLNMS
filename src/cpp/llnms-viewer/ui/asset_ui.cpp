/**
 * @file    asset_ui.cpp
 * @author  Marvin Smith
 * @date    1/2/2014
*/
#include "asset_ui.hpp"
#include "asset_information_ui.hpp"
#include "create_llnms_asset_ui.hpp"

#include "../utilities/CursesUtilities.hpp"
#include "../utilities/Table.hpp"

#include <ncurses.h>
               
/**
 * Print User Interface for Deleting an Asset
*/
void delete_asset_ui( const LLNMS_Asset& asset ){
    
    int row, col, ch;
    std::string prompt;
    int currentIdx = 0;

    // start ui loop
    bool EXIT_LOOP=false;
    while( EXIT_LOOP == false ){

        // clear the screen
        clear();

        // ask to verify
        prompt = "Are you sure you wish to delete the asset?";
        row = 1;
        col = (options.maxX/2) - (prompt.size()/2);
        if( col < 0 ) col = 0;
        mvprintw( row, col, prompt.c_str());

        // print details of the asset
        prompt = std::string("hostname: ") + asset.hostname; 
        row = 3;
        col = (options.maxX/2) - (prompt.size()/2);
        if( col < 0 ) col = 0;
        mvprintw( row, col, prompt.c_str());
    
        prompt = std::string("ip4 address: ") + asset.ip4_address; 
        row = 4;
        col = (options.maxX/2) - (prompt.size()/2);
        if( col < 0 ) col = 0;
        mvprintw( row, col, prompt.c_str());

        prompt = std::string("description: ") + asset.description; 
        row = 5;
        col = (options.maxX/2) - (prompt.size()/2);
        if( col < 0 ) col = 0;
        mvprintw( row, col, prompt.c_str());
        
        //---------------------------------------//
        //           print the buttons           //
        //---------------------------------------//
        int startButtonX = (options.maxX/2) - 6;
        int stopButtonX  = (options.maxX/2) + 6;

        if( startButtonX < 0            ){ startButtonX  = 0;              }
        if( stopButtonX >= options.maxX ){ stopButtonX   = options.maxX-1; }

        print_button( "Cancel",       8,  startButtonX, stopButtonX,  (currentIdx == 0));
        print_button( "Delete Asset", 9,  startButtonX, stopButtonX,  (currentIdx == 1));



        // refresh the screen
        refresh();
    
        // grab the character
        ch = getch();


        switch( ch ){

            /// Key Up
            case KEY_UP:
                if( currentIdx > 0 ){ 
                    currentIdx--;
                }
                break;

            /// Key Down
            case KEY_DOWN:
                if( currentIdx < 1){
                    currentIdx++;
                }
                break;

            /// enter
            case 10:
                /// cancel
                if( currentIdx == 0 ){
                    EXIT_LOOP=true;
                }
                else if( currentIdx == 1 ){
                    std::string message;
                    bool delete_result = llnms_state.asset_manager.delete_asset( asset, message );
                    EXIT_LOOP=true;
                }
                break;

            // otherwise
            default:
                break;

        }

    }

}


void print_asset_footer(){

    for( int i=0; i<=options.maxX; i++ ){
       mvaddch( options.maxY-3, i, '-' );  
    }
    mvprintw( options.maxY-2, 0, " q: Exit Asset Pane,  c: Create Asset, d: Delete Asset");
    mvprintw( options.maxY-1, 0, " i: Asset Information");
}


/**
 * Asset Manager User Interface
*/
void asset_ui(){
    
    // position of the current index
    llnms_state.asset_manager.update_asset_list();
    int currentIdx = -1;
    if( llnms_state.asset_manager.asset_list.size() > 0 ){
        currentIdx = 0;
    }
    
    // index pointing to the top-most item shown in the table.
    int topIndex = 0;


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
        table.print( 2, options.maxX-1, options.maxY-4, currentIdx, topIndex );
        
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
             * Key Up
            */
            case KEY_UP: 
                if( currentIdx > 0 ){ 
                    currentIdx--; 
                }
                break;

            /**
             * Key Down
            */
            case KEY_DOWN:
                if( currentIdx < (llnms_state.asset_manager.asset_list.size()-1)){
                    currentIdx++;
                }
                break;

            /**
             * Delete Asset
            */
            case 'd':
            case 'D':
                
                /**
                 * Call the delete function with the current index
                 */
                delete_asset_ui( llnms_state.asset_manager.asset_list[currentIdx] );
                if( currentIdx > 0 && llnms_state.asset_manager.asset_list.size() > 0 ){
                    currentIdx--;
                }
                else if( llnms_state.asset_manager.asset_list.size() <= 0 ){
                    currentIdx = -1;
                }
                
                break;
            
            /** 
             * Asset information
             */
            case 'i':
            case 'I':
                
                // open the asset information pane
                asset_information_ui( llnms_state.asset_manager.asset_list[currentIdx] );
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
