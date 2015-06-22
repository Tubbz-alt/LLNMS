#!/usr/bin/env python
#
#    File:     llnms-list-assets.py
#    Author:   Marvin Smith
#    Date:     6/21/2015
#
#    Purpose:  List LLNMS Task information.
#
__author__ = 'Marvin Smith'


#  Python Libraries
import os, sys, argparse


#  LLNMS Libraries
if os.environ['LLNMS_HOME'] is not None:
    sys.path.append(os.environ['LLNMS_HOME'] + '/lib')
import llnms


# ------------------------------------ #
# -      Parse the Command-Line      - #
# ------------------------------------ #
def Parse_Command_Line():

    #  Create an Argument Parser
    parser = argparse.ArgumentParser(description='Print LLNMS Task information.')

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

    #  Format Mode
    parser.add_argument('-p','--pretty',
                        dest='pretty_flag',
                        required=False,
                        default=False,
                        action='store_true',
                        help="Print in a pretty format.")

    parser.add_argument('-l','--list',
                        dest='list_flag',
                        required=False,
                        default=False,
                        action='store_true',
                        help="Print in a list format.")

    #  Return the parser
    return parser.parse_args()

# --------------------------- #
# -      Process Input      - #
# --------------------------- #
def Process_Input( options ):

    #  Check the format
    format = 'list'
    if options.pretty_flag is True:
        format = 'pretty'


    #  Set the print format
    return format

# ----------------------------- #
# -      Print Task List      - #
# ----------------------------- #
def Print_Task_List( task_list, print_format ):

    #  Iterate over list
    for task in task_list:

        #  Print the list
        if print_format == 'list':
            print(task.To_List_String())
        elif print_format == 'pretty':
            print(task.To_Pretty_String())
        else:
            raise Exception('Unknown mode (' + print_format + ')')


# ---------------------------- #
# -      Main Function       - #
# ---------------------------- #
def Main():

    #  Retrieve LLNMS_HOME
    llnms_home=os.environ['LLNMS_HOME']

    #  Parse Command-Line Arguments
    options = Parse_Command_Line()

    #  Validate Arguments
    print_format = Process_Input( options )

    #  Get the task list
    task_list = llnms.Task.llnms_load_tasks(llnms_home=llnms_home)

    #  Print the list
    Print_Task_List(task_list, print_format)


if __name__ == '__main__':
    Main()