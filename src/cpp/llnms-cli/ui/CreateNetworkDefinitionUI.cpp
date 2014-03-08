/**
 * @file    CreateNetworkDefinitionUI.cpp
 * @author  Marvin Smith
 * @date    2/27/2014
 */
#include "CreateNetworkDefinitionUI.hpp"

#include <core/Options.hpp>
#include <ui/MessageDialog.hpp>
#include <utilities/CursesUtilities.hpp>

#include <ncurses.h>

#include <string>

/***
 * Print the footer
 */
void print_create_network_footer(){

    /// print the horizontal line
    print_single_char_line( '-', options.maxY-4, 0, options.maxX );

    // print the first row
    mvprintw( options.maxY-3, 0, "Type the appropriate values in the fields provided.");
    mvprintw( options.maxY-2, 0, "Up/Down/Left/Right Arrows to Navigate Fields.  Tab: Next field." );
    mvprintw( options.maxY-1, 0, "ESC: back.  Press Save Button to save and Cancel to discard changes." );

}

/**
 * Check if a key is valid for the network name
 */
bool networkNameValidKey( const int& key ){
    return true;
}

/**
 * Check if a key is valid for the network address
 */
bool networkAddressValidKey( const int& key ){

    if( key >= '0' && key <= '9' )return true;
    if( key == '.' ) return true;

    return false;
}

/**
 * create a network definition user interface
 */
void create_network_definition_ui(){

    int cursorIdx = 0;
    std::vector<int> cursorPositions( 3, 0);
    std::vector<std::string> valueList( 3, "");

    // start a loop
    bool EXIT_LOOP=false;
    while( EXIT_LOOP == false ){

        // clear the screen
        clear();

        // print the header
        print_header("LLNMS Create Network Definition");
        
        // print name form line
        print_form_line( "Name", valueList[0], 4, 0, options.maxX, "LEFT", (cursorIdx == 0), cursorPositions[0] );    
        
        // print address start form line
        print_form_line( "Start Address", valueList[1], 6, 0, options.maxX, "LEFT", (cursorIdx == 1), cursorPositions[1] );    
        
        // print address end form line
        print_form_line( "Ending Address", valueList[2], 8, 0, options.maxX, "LEFT", (cursorIdx == 2), cursorPositions[2] );    
        
        // print save button
        print_button( "Save", 10, 6, 16, (cursorIdx == 3), "CENTER" );

        // print cancel button
        print_button("Cancel", 10, 20, 30, (cursorIdx == 4), "CENTER" );

        // print the footer
        print_create_network_footer();

        // refresh
        refresh();

        // get user input
        int ch =getch();

        switch(ch){
            
            // Up Key
            case KEY_UP:
                if( cursorIdx > 0 ){
                    cursorIdx--;
                }
                break;

            // Down Key
            case 9:
            case KEY_DOWN:
                if( cursorIdx < 4 ){
                    cursorIdx++;
                }
                else{
                    cursorIdx = 0;
                }
                break;

            // Left Key
            case KEY_LEFT:
                
                // if we are in a field, move the cursor position indeces
                if( cursorIdx >= 0 && cursorIdx < 3 ){
                    if( cursorPositions[cursorIdx] > 0 ){
                        cursorPositions[cursorIdx]--;
                    }
                }
                // if we are on a button, move
                else if( cursorIdx == 4 ){
                    cursorIdx--;
                }
                break;

            // right key
            case KEY_RIGHT:
                
                // if we are on a field, move the cursor position indeces
                if( cursorIdx >= 0 && cursorIdx < 3 ){
                    if( cursorPositions[cursorIdx] < valueList[cursorIdx].size() ){
                        cursorPositions[cursorIdx]++;
                    }
                }
                // if we are on the left button, then go to the right
                else if(cursorIdx == 3){
                    cursorIdx++;
                }
                break;

            // exit gui
            case 27:
                EXIT_LOOP=true;
                break;
            
            // backspace key
            case KEY_BACKSPACE:
                
                // if we are over a field, back up the cursor and erase the character
                if( cursorIdx >= 0 && cursorIdx < 3 ){
                    if( cursorPositions[cursorIdx] > 0 ){
                        cursorPositions[cursorIdx]--;
                        valueList[cursorIdx].erase( valueList[cursorIdx].begin() + cursorPositions[cursorIdx]);
                    }
                }
    
                break;

            // enter key
            case KEY_ENTER:
            case 10:
                
                // if we are over the save key, just exit
                if( cursorIdx == 3 ){
                    
                    int result = message_dialog();
                    if( result == 1 ){

                    }

                    EXIT_LOOP=true;
                }

                // if we are over the cancel key, just exit
                if( cursorIdx == 4 ){

                    // give a warning screen

                    EXIT_LOOP=true;
                }
                break;

            // default case
            default:
                // if the input was a character, then add it to string
                if(( ch <= 'z' && ch >= 'a' ) ||
                   ( ch <= 'Z' && ch >= 'A' ) ||
                   ( ch <= '9' && ch >= '0' ) ||
                   ( ch == ' ' || ch == '.' ) ){
                    

                    // add the line to the container
                    if( cursorIdx == 0 && networkNameValidKey( ch ) == true ){
                        valueList[cursorIdx].insert( valueList[cursorIdx].begin() + cursorPositions[cursorIdx], (char)ch);
                        cursorPositions[cursorIdx]++;
                    }
                    if(( cursorIdx == 1 || cursorIdx == 2 ) && networkAddressValidKey( ch ) == true ){
                        valueList[cursorIdx].insert( valueList[cursorIdx].begin() + cursorPositions[cursorIdx], (char)ch);
                        cursorPositions[cursorIdx]++;
                    }
                }
        }

    }


}

