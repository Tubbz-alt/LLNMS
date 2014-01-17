/**
 * @file    configure_ui.cpp
 * @author  Marvin Smith
 * @date    1/14/2014
 */
#include "configure_ui.hpp"
#include "../utilities/CursesUtilities.hpp"

#include <ncurses.h>

/**
 * Print description dialog
 */
void print_description_dialog( const std::string& variable, const std::string& description ){
    
    // clear
    clear();

    //  print string
    print_string( variable, options.maxY/2-2, 0, options.maxX, "CENTER" );
    print_string( description, options.maxY/2, 0, options.maxX, "CENTER" ); 
    
    // hide cursor
    move( 0, 0);
    
    /// refresh screen
    refresh();

    // get temp input
    int ch = getch();

    return;



}

/**
 * Print configuration footer
 */
void print_configuration_footer(){
    
    print_single_char_line( '-', options.maxY-3, 0, options.maxX );
    mvprintw( options.maxY-2, 0, "Up/Down Arrows: Navigate menu,  ENTER: Modify setting,  ?: print description" );
    mvprintw( options.maxY-1, 0, "q: back to main menu,  s: save configuration file");

}


/**
 * Save dialog
 */
void config_file_save_dialog(){

    /// clear the screen
    clear();

    /// write a message
    std::string message = "Configuration File Saved";
    int startx = (options.maxX/2) - (message.size()/2);
    if( startx < 0 ) startx = 0;
    mvprintw( options.maxY/2, startx, message.c_str());

    /// write okay button
    std::string line1 = "+--------------------------------+";
    std::string line2 = "|   Press Any Key to Continue    |";
    std::string line3 = "+--------------------------------+";
    startx = (options.maxX/2) - (line1.size()/2);
    if( startx < 0 ) startx = 0;

    mvprintw( options.maxY/2+2, startx, line1.c_str());
    mvprintw( options.maxY/2+3, startx, line2.c_str());
    mvprintw( options.maxY/2+4, startx, line3.c_str());

    // hide cursor
    move( 0, 0);
    
    /// refresh screen
    refresh();

    // get temp input
    int ch = getch();

    return;

}

/**
 *
 */
void print_configuration_window( const int& topRow, const int& currentIdx ){

    /// print the log filename
    if( topRow <= 0 && (topRow + options.maxY) > 1 ){
        print_form_line( "LOG_FILENAME:", options.log_filename, 3, 0, options.maxX-1, "LEFT", (currentIdx == 0), 0 );
    }
    
    /// print the log priority
    if( topRow <= 1 && (topRow + options.maxY) > 1 ){
        print_form_line( "LOG_PRIORITY:", num2str(options.log_priority), 4, 0, options.maxX-1, "LEFT", (currentIdx == 1), 0 );
    }

}



/**
 * Configuration User Interface
 */
void configure_ui(){

    int ch;
    int topRow=0;
    int currentIdx = 0;

    /**
     * Run Loop
     */
    bool EXIT_LOOP=false;
    while( EXIT_LOOP == false ){

        // clear the screen
        clear();

        // draw header
        print_header("LLNMS-Viewer Configuration Pane");
        
        
        // print configuration window
        print_configuration_window( topRow, currentIdx );    
        

        // print footer
        print_configuration_footer();

        // refresh screen
        refresh();

        // grab character
        ch = getch();
        
        // parse options
        switch(ch){

            // quit
            case 'q':
            case 'Q':
                EXIT_LOOP=true;
                break;

            
            // save
            case 's':
            case 'S':
                options.write_config_file();
                config_file_save_dialog();   
                break;
            
            // up arrow
            case KEY_UP:
                if( currentIdx > 0 ){
                    currentIdx--;
                }
                break;

            // down arrow
            case KEY_DOWN:
                if( currentIdx < 1 ){
                    currentIdx++;
                }
                break;

            // description
            case '?':
                
                switch( currentIdx ){
                    
                    // LOG_FILENAME
                    case 0:
                        print_description_dialog("LOG_FILENAME", "File to dump logging information to.");
                        break;
                    
                    // LOG_PRIORITY
                    case 1:
                        print_description_dialog("LOG_PRIORITY", "Priority of messages to display.");
                }
                break;


        }

    }

}

