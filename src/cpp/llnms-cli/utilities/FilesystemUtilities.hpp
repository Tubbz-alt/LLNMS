/**
 * @file    FilesystemUtilities.hpp
 * @author  Marvin Smith
 * @date    1/11/2014
*/
#ifndef __SRC_CPP_LLNMSVIEWER_UTILITIES_FILESYSTEMUTILITIES_HPP__
#define __SRC_CPP_LLNMSVIEWER_UTILITIES_FILESYSTEMUTILITIES_HPP__

/// C++ Standard Library
#include <string> 

/// Boost Libraries
#include <boost/filesystem.hpp>

/**
 * Run a standard system command and grab output.
*/
bool run_command( const std::string& command, std::string& message );

/**
 * Check if a file exists
 */
bool file_exists( const std::string& filename );

/**
 * Create a directory if it does not exist.
 */
void path_mkdir( const boost::filesystem::path& pathname );

#endif
