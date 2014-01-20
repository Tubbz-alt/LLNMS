/**
 * @file    create_llnms_asset.cpp
 * @author  Marvin Smith
 * @date    1/4/2014
*/
/// header file
#include "create_llnms_asset_ui.hpp"
#include "error_ui.hpp"

/// Utility Libraries
#include "../utilities/CursesUtilities.hpp"
#include "../utilities/NetworkUtilities.hpp"

/// C Std Library
#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <vector>

/// NCurses
#include <ncurses.h>


/**
 * Save and create asset screen
 */
void save_and_create_asset( const std::string& hostname, const std::string& ip4address, const std::string& description ){
   
    
    // clear the screen
    clear();
                  

    // create the command to run
    std::string command = std::string("llnms-create-asset -host '")+hostname+std::string("' -ip4 ")+ip4address;
    if( description != "" ){
        command += std::string(" -d '") + description + std::string("'");
    }

    // create a pipe to cmd output
    FILE* pipe = popen(command.c_str(), "r");
    
    // what to do if the open fails
    if( !pipe){

        int row = options.maxY/2;
        int col = options.maxX/2-10;  
        if( col < 0 )  col=0;
        
        // print the screen
        mvprintw( row  , col, "Operation Failed" );
        mvprintw( row+1, col, "Press Any Key To Continue");
    
    }
    // otherwise, if the open works
    else{
        
        // create our output
        char buffer[128];
        std::string result = "";
        
        // iterate over the stream output
        while(!feof(pipe)) {
            if(fgets(buffer, 128, pipe) != NULL)
                result += buffer;
        }
        pclose(pipe);
    
    
        // create our output
        int lines = result.size()/(options.maxX/2);
        mvprintw( 0, 0, result.c_str());

        int row = options.maxY/2;
        int col = options.maxX/2-10;
        if( col < 0 ) col=0;

        mvprintw( row  , col, "Operation Successful" );
        mvprintw( row+1, col, "Press Any Key To Continue" );
    }

    

    // refresh and wait for character
    refresh();

    int ch=getch();

    return;
}

/**
 * Print the llnms asset creation footer
*/
void print_create_asset_footer(){
   
    // print header
    print_single_char_line('-', options.maxY-2, 0, options.maxX);
    print_string("ESC: escape immediately.", options.maxY-1, 0, options.maxX, "LEFT" );

}

/**
 * Create the main llnms create asset gui
*/
void create_llnms_asset_ui(){
    

    // temporary value strings
    std::vector<std::string> temp_data( 3, "");

    //  create cursor positions
    std::vector<int> cursor_positions( 3, 0 );

    int currentIdx=0;
    int ch=0;
    bool hostnameValid = false, ip4addressValid = false;
    std::string hostnameLabel    = "Not Valid";
    std::string ip4addressLabel  = "Not Valid";
    int hostnameColor    = options.LABEL_INVALID_COLOR_PAIR; 
    int ip4addressColor  = options.LABEL_INVALID_COLOR_PAIR; 

    /**
     * Start a loop
    */
    bool EXIT_LOOP=false;
    while( EXIT_LOOP == false ){

        // find out if the temp hostname and address are valid
        bool hostnameValid = isValidHostnameFormat( temp_data[0] ); 
        bool ip4addressValid = isValidIP4AddressFormat( temp_data[1] );
        
        // create data points for them
        if( hostnameValid == true ){
            hostnameLabel = "Valid";
            hostnameColor = options.LABEL_VALID_COLOR_PAIR;
        } else {
            hostnameLabel = "Not Valid";
            hostnameColor = options.LABEL_INVALID_COLOR_PAIR;
        }
        if( ip4addressValid == true ){
            ip4addressLabel = "Valid";
            ip4addressColor = options.LABEL_VALID_COLOR_PAIR;
        } else {
            ip4addressLabel = "Not Valid";
            ip4addressColor = options.LABEL_INVALID_COLOR_PAIR;
        }


        // clear the screen
        clear();

        // print the header
        print_string("Create LLNMS Asset", 0, 0, options.maxX, "CENTER" );
        print_single_char_line('-', 1, 0, options.maxX);

        // print the form up to the asset hostname
        print_form_line( "Asset Hostname:", temp_data[0], 3, 2, options.maxX-15, "LEFT", (currentIdx == 0), cursor_positions[currentIdx] );
        print_label( hostnameLabel, 3, options.maxX-12, options.maxX-2, hostnameColor, "CENTER" );

        // print the form up to the asset ip4 address
        print_form_line( "Asset IP4 Address:", temp_data[1], 5, 2, options.maxX-15, "LEFT", (currentIdx == 1), cursor_positions[currentIdx] );
        print_label( ip4addressLabel, 5, options.maxX-12, options.maxX-2, ip4addressColor, "CENTER" );

        // print the form line up to the asset description
        print_form_multiline( "Asset Description  (Optional):" /*  Key Data             */, 
                              temp_data[2]                     /*  Value Data           */,
                              7                                /*  Starting Y Position  */,
                              options.maxY-8                   /*  Ending Y Position    */, 
                              2                                /*  Starting X Position  */, 
                              options.maxX-3                   /*  Ending X Position    */,
                              (currentIdx == 2)                /*  Highlight Flag       */, 
                              cursor_positions[currentIdx]     /*  Cursor Position      */
                             );
        
        print_button("Save and Quit",       options.maxY-6,  5,  28, (currentIdx == 3) );
        print_button("Don't Save and Quit", options.maxY-4,  5,  28, (currentIdx == 4) );
        
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

            // check for ENTER button
            case 10:
                
                // if we want to save and exit
                if( currentIdx == 3 ){
                    
                    // if both fields are not valid, then throw an error screen
                    if( hostnameValid == false ){
                        error_prompt("The Hostname is not valid.");
                    }
                    else if( ip4addressValid == false ){
                        error_prompt("The IP4 Address is not valid.");
                    }
                    else {
                        save_and_create_asset( temp_data[0], temp_data[1], temp_data[2] );
                        llnms_state.asset_manager.update_asset_list();
                        EXIT_LOOP=true;
                    }
                }
                // if we want to cancel our progress
                else if( currentIdx == 4 ){
                    EXIT_LOOP=true;
                }
                break;

            // backspace
            case KEY_BACKSPACE:
            case 127:
                if( currentIdx < 3 ){
                    if( cursor_positions[currentIdx] > 0 ){
                        // decrement the cursor
                        cursor_positions[currentIdx]--;

                        // delete the single character
                        temp_data[currentIdx].erase(cursor_positions[currentIdx], 1);
                    }
                }
                break;

            // default
            default:
                
                // check if character was entered
                if ( currentIdx < 3 ){
                    
                    // if the character is an accepted pattern
                    if( (currentIdx == 0 && isValidHostnameCharacter(ch)  ) ||
                        (currentIdx == 1 && isValidIP4AddressCharacter(ch)) ||
                        (currentIdx == 2 && isValidDescriptionCharacter(ch)   )) {

                    
                        temp_data[currentIdx].insert( cursor_positions[currentIdx], 1, (char)ch);
                        cursor_positions[currentIdx]++;
                    }
                }

                break;
        }
    }
}

/**
 * Check if character is a valid Description character
*/
bool isValidDescriptionCharacter( const char& ch ){
    
    if( ch >= 'a' && ch <= 'z' ){ return true; }
    if( ch >= 'A' && ch <= 'Z' ){ return true; }
    switch(ch){
        
        case ' ':
        case '.':
        case ',':
        case '-':
           return true;

        default:
            return false;
    }

    return false;
}

/**
 * Check if a character is a valid hostname character
*/
bool isValidHostnameCharacter( const char& ch ){

    if( ch >= 'a' && ch <= 'z' ){ return true; }
    if( ch >= 'A' && ch <= 'Z' ){ return true; }

    switch(ch){
    
        case '-': 
        case '.':
                 return true;
        default: 
                 return false;
    }

    return false;

}

/**
 * Check if a character is a valid ip4 address character
*/
bool isValidIP4AddressCharacter( const char& ch ){
    
    if( ch >= '0' && ch <= '9' ){ return true; }
    if( ch == '.' ){ return true; }

    return false;
}

