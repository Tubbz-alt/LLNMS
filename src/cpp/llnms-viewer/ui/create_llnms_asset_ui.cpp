/**
 * @file    create_llnms_asset.cpp
 * @author  Marvin Smith
 * @date    1/4/2014
*/
#include "create_llnms_asset_ui.hpp"

#include "curses_utils.hpp"

#include <ncurses.h>

#include <vector>

/**
 * Print the llnms asset creation footer
*/
void print_create_asset_footer(){
   
    // print header
    print_single_char_line('-', options.maxY-2, 0, options.maxX);
    print_string("ESC: escape immediately.", options.maxY-1, 0, options.maxX, "LEFT" );

}

void create_llnms_asset_ui(){
    

    // temporary value strings
    std::vector<std::string> temp_data( 3, "");

    //  create cursor positions
    std::vector<int> cursor_positions( 3, 0 );

    int currentIdx=0;
    int ch=0;

    bool SPECIAL_KEY_SET=false;
    /**
     * Start a loop
    */
    bool EXIT_LOOP=false;
    while( EXIT_LOOP == false ){

        // clear the screen
        clear();

        // print the header
        print_string("Create LLNMS Asset", 0, 0, options.maxX, "CENTER" );
        print_single_char_line('-', 1, 0, options.maxX);

        // print the form up to the asset hostname
        print_form_line( "Asset Hostname:", temp_data[0], 3, 0, options.maxX, "LEFT", (currentIdx == 0), cursor_positions[currentIdx] );
        
        // print the form up to the asset ip4 address
        print_form_line( "Asset IP4 Address:", temp_data[1], 5, 0, options.maxX, "LEFT", (currentIdx == 1), cursor_positions[currentIdx] );

        // print the form line up to the asset description
        print_form_line( "Asset Description:", temp_data[2], 7, 0, options.maxX, "LEFT", (currentIdx == 2), cursor_positions[currentIdx] );
        
        print_button("Save and Quit", options.maxY-6, 2, 26, (currentIdx == 3) );
        print_button("Don't Save and Quit", options.maxY-4, 2, 26, (currentIdx == 4) );
        
        // print the footer
        print_create_asset_footer();

        // refresh the ui
        refresh();

        // get a character
        ch = getch();

        /**
         * Parse options
         */
        switch(ch){

            // up key
            case KEY_UP:
                if( currentIdx > 0 ){ 
                    currentIdx--;
                }
                break;
            
            // down key
            case KEY_DOWN:
                if( currentIdx < 4 ){
                    currentIdx++;
                }
                break;
            
            // left key
            case KEY_LEFT:
                
                // make sure the index is one of our strings
                if( currentIdx < 3 ){
                    
                    // make sure their are characters remaining
                    if( cursor_positions[currentIdx] > 0 ){
                        cursor_positions[currentIdx]--;
                    }
                }
                break;

            // right key
            case KEY_RIGHT:
                
                // make sure the index is one of our strings
                if( currentIdx < 3 ){
                    
                    // make sure their are characters remaining
                    if( cursor_positions[currentIdx] < temp_data[currentIdx].size()){
                        cursor_positions[currentIdx]++;
                    }
                }
                break;

            // check for button
            case 10:
                if( currentIdx == 4 ){
                    EXIT_LOOP=true;
                }
                break;

            // default
            default:
                
                // check if character was entered
                if ( currentIdx < 3 && (ch >= 'a' && ch <= 'z' )){
                    temp_data[currentIdx].insert( cursor_positions[currentIdx], 1, (char)ch);
                    cursor_positions[currentIdx]++;
                }

                break;
        }
    }




}
