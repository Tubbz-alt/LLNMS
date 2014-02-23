/**
 * @file    asset_information_ui.hpp
 * @author  Marvin Smith
 * @date    1/12/2014
*/
#ifndef __SRC_CPP_LLNMSVIEWER_UI_ASSETINFORMATIONUI_HPP__
#define __SRC_CPP_LLNMSVIEWER_UI_ASSETINFORMATIONUI_HPP__

/// LLNMS Utilities
#include "../llnms/LLNMS_Asset.hpp"

/// Utility Libraries
#include "../utilities/Logger.hpp"
#include "../utilities/Options.hpp"

extern Logger logger;
extern Options options;

/**
 * Create the asset info ui
*/
void asset_information_ui( LLNMS_Asset& asset );

#endif

