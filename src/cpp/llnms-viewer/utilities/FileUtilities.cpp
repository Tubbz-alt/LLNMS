/**
 * @file    FileUtilities.cpp
 * @author  Marvin Smith
 * @date    1/11/2014
*/
#include "FileUtilities.hpp"

#include <cstdio>
#include <cstdlib>
#include <iostream>

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

