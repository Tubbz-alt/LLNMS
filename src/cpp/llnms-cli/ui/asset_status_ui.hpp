/**
 *  @file    asset_status_ui.hpp
 *  @author  Marvin Smith
 *  @date    1/14/2014
 */
#ifndef __SRC_CPP_LLNMSVIEWER_UI_ASSETSTATUSUI_HPP__
#define __SRC_CPP_LLNMSVIEWER_UI_ASSETSTATUSUI_HPP__

#include "../llnms/LLNMS_State.hpp"
#include "../utilities/Logger.hpp"
#include "../utilities/Options.hpp"

extern Logger logger;
extern Options options;
extern LLNMS_State llnms_state;

/**
 * Asset Status User Interface
 */
void asset_status_ui();

#endif
