#!/usr/bin/env python
#
#   File:    llnms-print-task-info.py
#   Author:  Marvin Smith
#   Date:    6/21/2015
#
#   Purpose: Allow user to print info on an LLNMS Task.
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
    parser = argparse.ArgumentParser(description='Print specific info about an LLNMS Task.')

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


    #  Task to evaluate
    parser.add_argument('-t','--task-id',
                        dest='task_id',
                        required=True,
                        help='Asset hostname.')

    #  Print the OS
    parser.add_argument('-o','--os',
                        dest='opsys',
                        required=True,
                        help="Operating system configuration to use.")

    #  Print the filename
    parser.add_argument('-c','--command',
                        dest='print_list',
                        action='append_const',
                        required=False,
                        const='command',
                        help='Print the command')

    #  Print if supported
    parser.add_argument('-s','--supported',
                        dest='print_list',
                        action='append_const',
                        required=False,
                        const='supported',
                        help='Print if the OS is supported for this task.')


    #  Return the parser
    return parser.parse_args()

# --------------------------- #
# -      Process Input      - #
# --------------------------- #
def Process_Input( options, llnms_home ):

    #  Print the flags
    print_flags = options.print_list

    #  Get the operating system
    opsys = options.opsys

    #  Get the task id
    task_id = options.task_id

    #  Load the task list
    task_list = llnms.Task.llnms_load_tasks(llnms_home=llnms_home)

    #  Find the right task
    task = None
    for task_candidate in task_list:

        #  Check the task id
        if task_candidate.id == task_id:

            #set the task
            task = task_candidate
            break

    #  If no task found, fail
    if task is None:
        raise Exception('unable to find matching task.')

    #  Look for the configuration
    configuration = None
    for config in task.configurations:

        #  Check the config
        if config.opsys == opsys:
            configuration = config
            break

    #  Make sure we have a proper configuration
    if configuration is None:
        raise Exception('No configuration found with the requested Operating System.')

    #  Return the result
    return [configuration, print_flags, opsys]


# ---------------------------- #
# -      Main Function       - #
# ---------------------------- #
def Main():

    #  Retrieve LLNMS_HOME
    llnms_home=os.environ['LLNMS_HOME']

    #  Parse Command-Line Arguments
    options = Parse_Command_Line()

    #  Validate Arguments
    [configuration, print_flags, opsys] = Process_Input( options, llnms_home )

    #  Print information
    output = ''
    for print_flag in print_flags:

        #  If Command
        if print_flag == 'command':
            output += configuration.command

    #  Print
    print(output)


if __name__ == '__main__':
    Main()