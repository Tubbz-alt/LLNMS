/**
 * @file    FilesystemUtilities.hpp
 * @author  Marvin Smith
 * @date    2/15/2014
 * 
 * @brief   Provide filesystem functions to abstract out the use of Boost Filesystem
 */
#ifndef __SRC_CPP_LLNMSCORE_UTILITIES_FILESYSTEMUTILITES_HPP__
#define __SRC_CPP_LLNMSCORE_UTILITIES_FILESYSTEMUTILITES_HPP__

#include <string>
#include <vector>

namespace LLNMS{
namespace UTILITIES{

/**
 * Check if a path is a directory
*/
bool is_directory( const std::string& pathname );

/**
 * Check if a path exists
*/
bool exists( const std::string& pathname );

/**
 * List the contents of a directory
*/
std::vector<std::string> list_contents( const std::string& pathname, const std::string& pattern = "*" );

} /// End of UTILITIES Namespace
} /// End of LLNMS Namespace

#endif
