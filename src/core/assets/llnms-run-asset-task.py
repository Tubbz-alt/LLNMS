#!/usr/bin/env python
#
#    File:    llnms-run-asset-task.py
#    Author:  Marvin Smith
#    Date:    6/15/2015
#
#    Purpose:  Run a task on a registered asset
#
__author__ = 'Marvin Smith'

#  Python Libraries
import os, sys, argparse

#  LLNMS Libraries
if os.environ['LLNMS_HOME'] is not None:
    sys.path.append(os.environ['LLNMS_HOME'] + '/lib')
import llnms


# -------------------------------- #
# -     Parse Command-Line       - #
# -------------------------------- #
def Parse_Command_Line():

    #  Create parser
    parser = argparse.ArgumentParser(description='Run a task on an LLNMS asset.')

    #  Version Info
    parser.add_argument('-v', '--version',
                        action='version',
                        version='%(prog)s ' + llnms.info.Get_Version_String(),
                        help='Print the version information.')

    #  Verbose Mode
    parser.add_argument('--verbose',
                        dest='verbose_flag',
                        required=False,
                        default=False,
                        action='store_true',
                        help='Print with verbose output.')

    #   Asset Name
    parser.add_argument('-a','--asset-hostname',
                        dest='asset_hostname',
                        required=True,
                        help='Asset to run task on.')

    #   Task ID
    parser.add_argument('-t','--task-name',
                        dest='task_name',
                        required=True,
                        help='Task to run.  Must be registered.')

    #  Parse the arguments
    parser.parse_args()

# --------------------------------------- #
# -       Process Input Arguments       - #
# --------------------------------------- #
def Process_Inputs(options, asset_list):

    #  Output variables
    asset = None

    #  Make sure the asset exists
    asset_hostname = options.asset_hostname
    if asset_hostname is None:
        raise Exception('No asset hostname provided.')
    for asset_candidate in asset_list:
        if asset_candidate.hostname == asset_hostname:
            asset = asset_candidate
    if asset is None:
        raise Exception('No asset found with name = ' + asset_hostname )

# -------------------------- #
# -      Main Program      - #
# -------------------------- #
def Main():

    #  Get LLNMS HOME
    llnms_home = os.environ['LLNMS_HOME']

    #  Parse the Command-Line
    options = Parse_Command_Line()

    #  Get the asset list
    asset_list = llnms.Asset.llnms_load_assets(llnms_home=llnms_home)

    #  Process Inputs
    Process_Inputs( options, asset_list )


if __name__ == '__main__':
    Main()