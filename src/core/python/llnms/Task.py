#    File:    Task.py
#    Author:  Marvin Smith
#    Date:    6/21/2015
#
#    Purpose: LLNMS Task
#
__author__ = 'Marvin Smith'

#  Python Libraries
import os, xml.etree.ElementTree as ET, subprocess, logging


# ---------------------------------- #
# -       Task Configuration       - #
# ---------------------------------- #
class Task_Config(object):

    #  Operating System
    opsys = None

    #  Supported Flag
    supported = False

    #  Command to execute
    command = None


    # ---------------------------- #
    # -       Constructor        - #
    # ---------------------------- #
    def __init__(self, opsys=None,
                       supported=False,
                       command=None):

        #  Operating System
        self.opsys = opsys

        #  Command
        self.command = command

        #  Supported
        self.supported = supported

    # ---------------------------------- #
    # -     Print to List String       - #
    # ---------------------------------- #
    def To_List_String(self):

        #  Create output
        output = ''

        #  Add OpSys
        output += str(self.opsys)

        #  Add the supported flag
        output += ' ' + str(self.supported)

        #  Add command
        output += ' ' + str(self.command)

        return output

# ---------------------------- #
# -        Task Class        - #
# ---------------------------- #
class Task(object):

    #  Task ID
    id = None

    #  Task Description
    description = None

    #  Filename
    filename = None

    #  Configurations
    configurations = []


    # -------------------------- #
    # -      Constructor       - #
    # -------------------------- #
    def __init__(self, filename=None,
                       id = None,
                       description = None,
                       configurations = None ):

        #  Set the ID
        self.id = id

        #  Set the description
        self.description = description

        #  Set the configurations
        if configurations is not None:
            self.configurations = configurations
        else:
            self.configurations = []

        #  Set the filename
        self.filename = filename


    # ---------------------------------- #
    # -     Print as Pretty String     - #
    # ---------------------------------- #
    def To_Pretty_String(self, print_all=True,
                               print_filename=False,
                               print_id = False,
                               print_description = False):

        #  Create output
        output  = 'Task:\n'

        #  Print the filename
        if print_all is True or print_filename is True:
            output += '       Filename : ' + self.filename + '\n'

        #  Print the ID
        if print_all is True or print_id is True:
            output += '             ID : ' + self.id + '\n'

        #  Print the description
        if print_all is True or print_description is True:
            output += '    Description : ' + self.description + '\n'

        #  Return
        return output

    # ---------------------------------- #
    # -      Print as list string      - #
    # ---------------------------------- #
    def To_List_String(self, print_all=True,
                             print_filename=False,
                             print_id=False):
        '''
        Print the task attributes in a list format
        :return:
        '''

        #  Create output
        output = ''

        #  If Filename
        if print_all is True or print_filename is True:
            output += self.filename + ' '

        #  If id
        if print_all is True or print_id is True:
            output += self.id

        #  Return
        return output

    # ---------------------- #
    # -     Load Task      - #
    # ---------------------- #
    def Load_Task_File(self, filename = None ):

        #  Set the filename
        if filename is not None:
            self.filename = filename

        #  Make sure the file exists
        if os.path.exists(self.filename) is False:
            return

        #  Parse the file
        root = ET.parse(self.filename)

        #  Get the ID
        idnode = root.find('id')
        if idnode is not None:
            self.id = idnode.text

        #  Get the Description
        dnode = root.find('description')
        if dnode is not None:
            self.description = dnode.text

        #  Get the COnfiguration
        config_node = root.find('configuration')

        #  Iterate over subnodes
        for cnode in config_node:

            #  Get the config name
            opsys = cnode.tag

            #  Get the node command
            command = cnode.find('command').get('value')

            #  Get the supported flag
            supported = bool(cnode.find('supported').get('value'))

            #  Add the configuration
            self.configurations.append(Task_Config(opsys=opsys,
                                                   command=command,
                                                   supported=supported))


    # -------------------------------- #
    # -     Write the Task File      - #
    # -------------------------------- #
    def Write_Task_File(self, filename = None ):

        #  Check the filename
        if filename is not None:
            self.filename = filename

        # load the xml parser
        if os.path.exists(self.filename):
            tree = ET.parse(self.filename)
            root = tree.getroot()
        else:
            root = ET.Element('llnms-task')
            tree = ET.ElementTree(root)


        # set id
        id_node = root.find('id')
        if id_node is None:
            id_node = ET.SubElement(root, "id")
        id_node.text = self.id


        #  Get description node
        des_node = root.find('description')
        if des_node is None:
            des_node = ET.SubElement(root, 'description')
        des_node.text = self.description

        #  Write the file
        logging.debug('Writing task to ' + self.filename)
        tree.write(self.filename)

# ----------------------------------- #
# -      Load the list of tasks     - #
# ----------------------------------- #
def llnms_load_tasks( llnms_home ):

    #  Create output list
    output = []

    #  Get the list of task pathnames
    task_pathnames = llnms_list_registered_task_pathnames(llnms_home)


    #  Iterate over paths
    for task_path in task_pathnames:
        output.append(Task(filename=task_path))
        output[-1].Load_Task_File()

    #  Return the list
    return output


# ---------------------------------------- #
# -        Find a particular task        - #
# ---------------------------------------- #
def find_task( task_id, llnms_home ):

    #  Get the list of tasks
    task_list = llnms_load_tasks(llnms_home)

    #  Iterate over task
    for task_item in task_list:

        #  Compare the scanner id
        if task_item.id == task_id:
            return task_item

    #  Otherwise, return none
    return None

# ------------------------------------------------- #
# -         List the registered task files        - #
# ------------------------------------------------- #
def llnms_list_registered_task_pathnames(llnms_home):

    #  Create the output
    output = []

    #  Create the task file
    registered_task_path = llnms_home + '/run/llnms-registered-tasks.xml'

    #  Make sure the file exists
    if os.path.exists(registered_task_path) == False:

        #  Log a note
        logging.debug('No registered task file found at ' + registered_task_path + '. Generating now.')

        #  Generate the file
        llnms_write_registered_task_list(llnms_home, [])

    #  Open the file
    tree = ET.ElementTree()
    tree.parse(registered_task_path)

    #  Get the root
    root = tree.getroot()

    #  Get the tasks node
    tasks_node = root.findall('llnms-task')

    #  Iterate over all task nodes
    if tasks_node is not None:
        for task_node in tasks_node:

            #  Get the text
            task_path = task_node.text

            #  Make sure it exists
            if os.path.exists(task_path) == False:
                logging.warning('The LLNMS Task at ' + task_path + ' does not exist.')
            else:
                output.append(task_path)


    #  Return the task file list
    return output



# ------------------------------------------------ #
# -        Write the Registered Task List        - #
# ------------------------------------------------ #
def llnms_write_registered_task_list(llnms_home, task_list):

    #  Build the filename
    registered_task_path = llnms_home + '/run/llnms-registered-tasks.xml'

    #  Create the node
    root = ET.Element('llnms-registered-tasks')
    tree = ET.ElementTree(root)

    #  Iterate over each task
    for task in task_list:

        #  Create the node
        task_node = ET.SubElement(root, "llnms-task")

        #  Make sure the filename is not none
        if task.filename is None:
            raise Exception('task filename cannot be none. (ID: ' + task.id + ').')
        task_node.text = task.filename

    #  Write the file
    logging.debug('Writing task to ' + registered_task_path)
    tree.write(registered_task_path)
