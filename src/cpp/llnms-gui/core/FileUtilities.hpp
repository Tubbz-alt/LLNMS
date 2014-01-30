/**
 * @file    FileUtilities.hpp
 * @author  Marvin Smith
 * @date    1/28/2014
 */
#ifndef __SRC_CPP_LLNMSGUI_CORE_FILEUTILITIES_HPP__
#define __SRC_CPP_LLNMSGUI_CORE_FILEUTILITIES_HPP__

#include <string>
#include <vector>

/**
 * Return true if the path exists
 *
 * @param[in] pathename File to check
 *
 * @return True if the path exists
 */
bool path_exists( const std::string& pathname );

/**
 * Get a list of files in a directory
 */
std::vector<std::string> path_ls( const std::string& pathname );


#endif
