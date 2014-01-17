/**
 * @file    asset_status_ui.cpp
 * @author  Marvin Smith
 * @date    1/14/2014
 */
#include "asset_status_ui.hpp"

#include "../utilities/CursesUtilities.hpp"
#include "../utilities/Table.hpp"

#include <ncurses.h>

/**
 * Print asset status footer
 */
void print_asset_status_footer(){
    
    print_single_char_line( '-', options.maxY-3, 0, options.maxX );
    print_string("q:  back to main menu.", options.maxY-1, 0, options.maxX, "LEFT" );


}

void print_asset_contents(){

   /**
    * Get the table to be printed from the asset manager
    */
    Table table;
    llnms_state.asset_manager.load_asset_state_table(table);
    table.print( 2, options.maxX-1, options.maxY-4, -1, 0 );


}

/**
 * Asset Status user interface
 */
void asset_status_ui(){
    
    // position of the current index
    llnms_state.asset_manager.update_asset_list();
    int currentIdx = -1;
    if( llnms_state.asset_manager.asset_list.size() > 0 ){
        currentIdx = 0;
    }
    
    int ch;

    // create loop
    bool EXIT_LOOP=false;
    while( EXIT_LOOP == false ){
        
        // clear the screen
        clear();

        // print header
        print_header("LLNMS Asset Status");

        // print content
        print_asset_contents();

        // print footer
        print_asset_status_footer();

        // refresh screen
        refresh();

        //
        ch = getch();

        switch(ch){

            // exit menu
            case 'q':
            case 'Q':
                EXIT_LOOP=true;
                break;


        }


    }

}

