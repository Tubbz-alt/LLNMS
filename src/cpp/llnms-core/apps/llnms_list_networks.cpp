/**
 * @file    llnms_list_networks.cpp
 * @author  Marvin Smith
 * @date    2/14/2014
 * 
 * @brief   LLNMS-List-Network Command-Line Application
 *
 * Provides the user with a command-line utility to list
 * registered LLNMS Networks.
*/

#include <deque>
#include <iostream>
#include <string>

#include <LLNMS.hpp>

using namespace std;

/**
 * @class Options
*/
class Options{

    public:
        
        /**
         * Default constructor for option class
        */
        Options(){
            
            /// Set default LLNMS_Home
            LLNMS_HOME="/var/tmp";

        }

        /// Base directory of LLNMS
        std::string LLNMS_HOME;

}; /// End of Options class

/**
 * Print version information
*/
void version( ){
    
    cout << "llnms-list-networks" << endl;
    cout << endl;
    cout << "Version   : " << LLNMS_VERSION_MAJOR << "." << LLNMS_VERSION_MINOR << endl;
    cout << "Build Date: " << LLNMS_VERSION_DATE << endl;
    cout << endl;

}

/**
 * Usage instructions
*/
void usage( const std::string& program_name ){

    cout << "usage: " << program_name << " [options]" << endl;
    cout << endl;
    cout << "    options: " << endl;
    cout << "    -h, --help       : Print usage instructions." << endl;
    cout << "    -v, --version    : Print version information." << endl;
    cout << endl;

}

/**
 * Parse Command-Line Options
*/
Options parse_command_line_options( int argc, char* argv[] ){

    /// Create option container
    Options options;

    // Look for LLNMS Home
    // first, check if the environment variable exists, otherwise use expected
    const char* llnms_home_env = getenv("LLNMS_HOME"); 
    if( llnms_home_env != NULL && LLNMS::UTILITIES::exists( llnms_home_env ) == true ){
        if( LLNMS::UTILITIES::is_directory( llnms_home_env ) == true ){
            options.LLNMS_HOME = llnms_home_env;
        }   
    }

    // push all args onto a deque
    deque<string> args;
    for( int i=1; i<argc; i++ )
        args.push_back(argv[i]);

    // iterate through all arguments
    while( args.size() > 0 ){

        // grab the top argument
        string arg = args.front();
        args.pop_front();

        /// Check for Help Command
        if( arg == "-h" || arg == "--help" ){
            usage( argv[0] );
            exit(0);
        }

        /// Check for Version Command
        else if( arg == "-v" || arg == "--version" ){
            version();
            exit(0);
        }

    }

    return options;
}

int main( int argc, char* argv[] ){
    
    /// parse command-line options
    Options options = parse_command_line_options( argc, argv );

    cout << "LLNMS Home: " << options.LLNMS_HOME << endl;

    return 0;
}

