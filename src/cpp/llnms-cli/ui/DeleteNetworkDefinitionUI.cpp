/**
 * @file    DeleteNetworkDefinitionUI.cpp
 * @author  Marvin Smith
 * @date    3/9/2014
 */
#include "DeleteNetworkDefinitionUI.hpp"

#include <ncurses.h>

#include <string>

#include <utilities/CursesUtilities.hpp>

using namespace std;

/**
 * Delete the network definition
 */
void delete_network_definition_ui( const int& networkDefinitionIndex ){

    // start the main loop
    bool EXIT_LOOP = false;
    while( EXIT_LOOP == false ){

        // clear the console
        clear();
        
        // print warning
        mvprintw( 2, 3, "+------------------------------------------------------+");
        mvprintw( 3, 3, "|     Do you wish to delete the following network?     |");
        mvprintw( 4, 3, "+------------------------------------------------------+");

        // print network information
        print_form_line( "Network Name:",     state.m_network_module.network_definitions()[networkDefinitionIndex].name().c_str(),           7, 1, options.maxX-1, "LEFT", false, -1);
        print_form_line( "Starting Address:", state.m_network_module.network_definitions()[networkDefinitionIndex].address_start().c_str(),  8, 1, options.maxX-1, "LEFT", false, -1);
        print_form_line( "Ending Address:",   state.m_network_module.network_definitions()[networkDefinitionIndex].address_end().c_str(),   11, 1, options.maxX-1, "LEFT", false, -1);
    
        // print buttons
        print_button("Confirm (y)", 15,  3, 19, false, false);
        print_button("Cancel (n)",  15, 25, 41, false, false); 
        
        // get user input
        int ch = getch();

        // compare against options
        std::string message = "";
        switch(ch){

            // cancel
            case 27:
                EXIT_LOOP = true;
                break;

            // y or enter on button
            case 'y':
            case 'Y':
                state.m_network_module.delete_network( networkDefinitionIndex, message ); 
                EXIT_LOOP = true;
                break;

            // no or any other key
            case 'n':
            case 'N':
                EXIT_LOOP = true;
                break;

            // default do nothing
            default:
                break;
        }



    }


}

