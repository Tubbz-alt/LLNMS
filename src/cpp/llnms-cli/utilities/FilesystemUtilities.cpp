/**
 * @file    FileUtilities.cpp
 * @author  Marvin Smith
 * @date    1/11/2014
*/
#include "FilesystemUtilities.hpp"

#include <cstdio>
#include <cstdlib>
#include <iostream>

#include <boost/filesystem.hpp>

namespace bf=boost::filesystem;

/**
 * Run a standard system command and grab the output
*/
bool run_command( const std::string& command, std::string& message ){

    /// create output message
    message="";
    
    // run the command on the file descriptor
    FILE* pipe = popen(command.c_str(), "r");
    if( !pipe ){
        message = "command failed to run.";
        return false;
    }
    else{
        
        // create our output
        char buffer[128];
        
        // iterate over the stream output
        while(!feof(pipe)) {
            if(fgets(buffer, 128, pipe) != NULL)
                message += buffer;
        }
        pclose(pipe);
    
    }
    

    return true;
}


/**
 * Check if a file exists
 */
bool file_exists( const std::string& filename ){
    return bf::exists( bf::path( filename ));
}

/**
 * Create a directory if does not exist.
 */
void path_mkdir( const boost::filesystem::path& pathname ){
    bf::create_directories( pathname );
}

