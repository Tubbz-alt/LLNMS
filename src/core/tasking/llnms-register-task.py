#!/usr/bin/env python
#
#    File:    llnms-register-task.py
#    Author:  Marvin Smith
#    Date:    6/21/2015
#
#    Purpose: Register a Task with LLNMS
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
    parser = argparse.ArgumentParser(description='Register an LLNMS Task.')

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

    #  Task Filename
    parser.add_argument('-t','--task-file',
                        dest='task_path',
                        required=True,
                        help='LLNMS Task XML file to register.')

    #  Return the parser
    return parser.parse_args()


# ------------------------------ #
# -     Process Task Args      - #
# ------------------------------ #
def Process_Input( options ):

    #  Load the new task
    task = llnms.Task.Task(filename=options.task_path)

    #  Return
    return task


# ---------------------------- #
# -      Main Function       - #
# ---------------------------- #
def Main():

    #  Retrieve LLNMS_HOME
    llnms_home=os.environ['LLNMS_HOME']

    #  Parse Command-Line Arguments
    options = Parse_Command_Line()

    #  Validate Arguments
    new_task = Process_Input( options )

    #  Add to the task list
    task_list = llnms.Task.llnms_load_tasks(llnms_home)
    task_list.append(new_task)

    #  Write the task list
    llnms.Task.llnms_write_registered_task_list(llnms_home, task_list)

if __name__ == '__main__':
    Main()