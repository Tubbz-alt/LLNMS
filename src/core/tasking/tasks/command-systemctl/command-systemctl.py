#!/usr/bin/env python
#
#    File:     command-systemctl.py
#    Author:   Marvin Smith
#    Date:     6/14/2015
#
#    Purpose:  Run systemctl on the desired system.
#

#  Python Libraries
import os, sys, argparse

#  LLNMS Libraries
if os.environ['LLNMS_HOME'] is not None:
    sys.path.append(os.environ['LLNMS_HOME'] + '/lib')
import llnms

# ---------------------------------- #
# -       Parse Command-Line       - # 
# ---------------------------------- #
def Parse_Command_Line():

    #  Create parser
    parser = argparse.ArgumentParser(description="Command systemctl on the desired system.")


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


    #  Return parser
    parser.parse_args()

# --------------------------- #
# -       Main Driver       - #
# --------------------------- #
def Main():

    #  Parse command-line
    options = Parse_Command_Line()


if __name__ == "__main__":
    Main()

