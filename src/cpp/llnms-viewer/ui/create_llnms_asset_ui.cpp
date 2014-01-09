/**
 * @file    create_llnms_asset.cpp
 * @author  Marvin Smith
 * @date    1/4/2014
*/
#include "create_llnms_asset_ui.hpp"

#include "curses_utils.hpp"

#include <ncurses.h>

/**
 * Print the llnms asset creation footer
*/
void print_create_asset_footer(){
   
    // print header
    print_single_char_line('-', options.maxY-2, 0, options.maxX);
    print_string("ESC: escape immediately.", options.maxY-1, 0, options.maxX, "LEFT" );

}

void create_llnms_asset_ui(){
    

    // temporary hostname value
    std::string temp_hostname = "";
    std::string temp_ip4address = "";
    std::string temp_description = "";
    std::string test_value;

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
        print_form_line( "Asset Hostname:", temp_hostname, 3, 0, options.maxX, "LEFT", (currentIdx == 0) );
        
        // print the form up to the asset ip4 address
        print_form_line( "Asset IP4 Address:", temp_ip4address, 5, 0, options.maxX, "LEFT", (currentIdx == 1) );

        // print the form line up to the asset description
        print_form_line( "Asset Description:", temp_description, 7, 0, options.maxX, "LEFT", (currentIdx == 2) );
        
        print_button("Save and Quit", options.maxY-7, 2, 26, (currentIdx == 3) );
        print_button("Don't Save and Quit", options.maxY-4, 2, 26, (currentIdx == 4) );
        
        print_string( num2str(ch), 11, 10, 20, "LEFT" );

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

            // set lock key
            case 'q':
            case 'Q':
                EXIT_LOOP=true;
                break;
            
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

            // check for button
            case 10:
                if( currentIdx == 4 ){
                    EXIT_LOOP=true;
                }
                break;

                // default
            default:
                break;
        }
    }




}
