/** 
 * @file    asset_information_ui.cpp
 * @author  Marvin Smith
 * @date    1/12/2014
*/
#include "asset_information_ui.hpp"

#include "../utilities/CursesUtilities.hpp"

#include <ncurses.h>


/**
 * Print the list of registered scanners
*/
void print_registered_scanner_table( LLNMS_Asset& asset, int const& topRow, const bool& highlight ){
    
    
}

/**
 * Print the footer
*/
void asset_information_footer(){
     
    print_single_char_line( '-', options.maxY-3, 0, options.maxX ); 
    mvprintw( options.maxY-2, 0, "q: exit,  Up Arrow/Down Arrow: Scroll Page" );

}

/**
 * Build the user interface for the asset information screen
*/
void asset_information_ui( LLNMS_Asset& asset ){

    // input character
    int ch;

    // current cursor position
    int currentIdx = 0;
    int topRow = 0;

    // width variables
    int hostnameWidth = 40;
    if( hostnameWidth > options.maxX ){ hostnameWidth = options.maxX; }
    int ip4addressWidth = 40;
    if( ip4addressWidth > options.maxX ){ ip4addressWidth = options.maxX; }

    // start main loop
    bool EXIT_LOOP = false;
    while( EXIT_LOOP == false ){

        // clear the screen
        clear();

        // print the header
        print_header("LLNMS Asset Information");

        ///   Print Hostname Information
        print_form_line( "   Hostname:", asset.hostname, topRow+4, 1, hostnameWidth, "LEFT", (currentIdx == 0), 0 );  
        
        ///   Print IP4 Address Information
        print_form_line( "IP4 Address:", asset.ip4_address, topRow+6, 1, ip4addressWidth, "LEFT", (currentIdx == 1), 0);
        
        ///   Print description Information
        print_form_multiline( "Description:", asset.description, topRow+8, topRow+12, 1, hostnameWidth, (currentIdx == 2), 0); 
    
        ///   Print registered scanners
        print_registered_scanner_table( asset, topRow+14, (currentIdx == 3) );

        // print the footer
        asset_information_footer();

        // refresh the screen
        refresh();

        // get user input
        ch = getch();

        // parse input options
        switch(ch){

            case 'q':
            case 'Q':
                EXIT_LOOP=true;
                break;
            
            default:
                break;
        }


    }

}

