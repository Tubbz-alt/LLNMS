#!/usr/bin/env python
#
#    File:    llnms-query-system
#    Author:  Marvin Smith
#    Date:    6/14/2015
#
#    Purpose: Query the LLNMS System
#

__author__ = 'Marvin Smith'

#  Python Libraries
import argparse, os, sys


#  LLNMS Libraries
if os.environ['LLNMS_HOME'] is not None:
    sys.path.append(os.environ['LLNMS_HOME'] + '/lib')
import llnms


# ------------------------------------------- #
# -      Parse Command-Line Arguments       - #
# ------------------------------------------- #
def Parse_Command_Line():

    #  Create argument parser
    parser = argparse.ArgumentParser(description="Print system information.")

    #  Version
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

    #  Return
    return parser.parse_args()

# ------------------------------- #
# -        Main Function        - #
# ------------------------------- #
def Main():

    #  Parse the command-line arguments
    options = Parse_Command_Line()

    #  Check for system


if __name__ == '__main__':
    Main()