/**
 * @file    create_llnms_asset.hpp
 * @author  Marvin Smith
 * @date    1/4/2014
*/
#ifndef __SRC_CPP_LLNMSVIEWER_UI_CREATELLNMSASSET_HPP__
#define __SRC_CPP_LLNMSVIEWER_UI_CREATELLNMSASSET_HPP__

#include "../llnms/LLNMS_State.hpp"

#include "../utilities/CursesUtilities.hpp"
#include "../utilities/Options.hpp"

extern Options options;

extern LLNMS_State llnms_state;

/**
 * User Interface for creating a LLNMS Asset
*/
void create_llnms_asset_ui();

/**
 * Return true if the character is a valid char for a hostname
 */
bool isValidHostnameCharacter( const char& ch );

/**
 * Return true if the character is a valid ip4 address character
*/
bool isValidIP4AddressCharacter( const char& ch );

/**
 * Return true if the character is a valid character for a description
*/
bool isValidDescriptionCharacter( const char& ch );

#endif

