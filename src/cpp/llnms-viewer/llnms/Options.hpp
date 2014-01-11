/**
 * @file    Options.hpp
 * @author  Marvin Smith
 * @date    1/2/2014
*/
#ifndef __SRC_CPP_LLNMSVIEWER_OPTIONS_HPP__
#define __SRC_CPP_LLNMSVIEWER_OPTIONS_HPP__

/**
 * @class Options
*/
class Options{

    public:

        /**
         * Initialize Window
        */
        void init();

        /// Max Window Width
        int maxX;

        /// Max Window Height
        int maxY;
        
}; /// End of Options class

/**
 * Return true if the character is a valid char for a hostname
 */
bool isValidHostnameCharacter( const char& ch );
bool isValidIP4AddressCharacter( const char& ch );
bool isValidDescriptionCharacter( const char& ch );

#endif
