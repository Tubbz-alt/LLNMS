#    File:    Scanner.py
#    Author:  Marvin Smith
#    Date:    6/13/2015
#
#    Purpose: Manage and manipulate LLNMS Scanner entries.
#
__author__ = 'Marvin Smith'


#  System Libraries
import subprocess, logging, os, xml.etree.ElementTree as ET
import multiprocessing, itertools, sys
from multiprocessing import Pool

def Run_Scanner(args):

    scanner = args[0]
    address = args[1]
    args    = args[2]

    return scanner.Run_Scan( address, args)


# -------------------------------------------- #
# -      Scanner Command-Line Argument       - #
# -------------------------------------------- #
class ScannerArgument(object):

    #  ID
    id = None

    #  Value
    value = None

    # Type
    type = None

    #  Type value
    type_value = None

    #  Default value
    default = None

    # ------------------------- #
    # -      Constructor      - #
    # ------------------------- #
    def __init__(self, id = None, value = None):

        #  Set internals
        self.type = None
        self.type_value = None
        self.default = None

        #  Set the ID
        if id is not None:
            self.id = id

        #  Set the value
        if value is not None:
            self.value = value


    # -------------------------------------- #
    # -     Format to Debugging String     - #
    # -------------------------------------- #
    def To_Debug_String(self, offset=0):

        gap = ' ' * offset

        output  = gap + str(self.__class__) + '\n'
        output += gap + '     ID : ' + self.id + '\n'
        output += gap + '  Value : ' + str(self.value) + '\n'

        return output

# ---------------------------- #
# -      Scanner Class       - #
# ---------------------------- #
class Scanner(object):

    #  Scanner ID
    id = None

    #  Name
    name = None

    #  Description
    description = None

    #  Command Name
    command = None

    #  Base Path
    base_path = None

    #  Argument List
    arguments = []

    #  Filename
    filename = None

    #  LLNMS HOME
    llnms_home = None

    # --------------------------- #
    # -      Constructor        - #
    # --------------------------- #
    def __init__( self,
                  id = None,
                  name = None,
                  description = None,
                  filename=None,
                  LLNMS_HOME = None):

        #  Set the ID
        self.id = id

        #  Set the name
        self.name = name

        #  Set the description
        self.description = description

        #  Set LLNMS_HOME
        if LLNMS_HOME is not None:
            self.llnms_home = LLNMS_HOME
        else:
            self.llnms_home = os.environ['LLNMS_HOME']

        #  Set the filename
        if filename is not None:
            self.Load_From_File(filename)

    # ---------------------------------- #
    # -     Load the Scanner File      - #
    # ---------------------------------- #
    def Load_From_File(self, filename):

        #  Set the filename
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

        #  Get the name
        namenode = root.find('name')
        if namenode is not None:
            self.name = namenode.text

        #  Get the description
        dnode = root.find('description')
        if dnode is not None:
            self.description = dnode.text

        #  Get the config node
        confignode = root.find('configuration')

        #  Get the linux node
        lnode = confignode.find('linux')
        if lnode is not None:

            #  Get the command
            self.command = lnode.find('command').text

            #  Get the base path
            self.base_path = lnode.find('base-path').text

            #  Get the argnode
            for argnode in lnode.findall('argument'):

                #  Create the temp node
                temp_arg = ScannerArgument()

                #  Get the id
                temp_arg.id         = argnode.get('id')
                temp_arg.name       = argnode.get('name')
                temp_arg.type       = argnode.get('type')
                temp_arg.type_value = argnode.get('value')
                temp_arg.default    = argnode.get('default')

                #  Add the argument
                self.arguments.append(temp_arg)

    # ----------------------------------- #
    # -     Print to Debug String       - #
    # ----------------------------------- #
    def To_Debug_String(self):

        #  Print output
        output  = str(self.__class__) + '\n'
        output += '          ID : ' + self.id + '\n'
        output += '        Name : ' + self.name + '\n'
        output += ' Description : ' + self.description + '\n'
        output += '     Command : ' + self.command + '\n'
        for argument in self.arguments:
            output += '    Argument : ' + argument.To_Debug_String(offset=4) + '\n'
        return output

    # -------------------------------- #
    # -        Run the scan          - #
    # -------------------------------- #
    def Run_Scan(self, endpoint, arg_list ):

        #  Create Command To Run
        command = self.llnms_home + '/' + self.base_path + '/' + self.command

        #  Append the arguments
        for x in xrange(0, len(arg_list)):

            #  Add the argument name
            command += ' --' + arg_list[x][0]

            #  Check the type
            if str(self.arguments[x].type) == 'ASSET_ELEMENT':
                if arg_list[x][0] == 'ip4-address':
                    command += ' ' + endpoint
            else:
                command += ' ' + arg_list[x][1]

        #  Run the process
        proc = subprocess.Popen(command,
                                shell=True,
                                stdout=subprocess.PIPE,
                                stderr=subprocess.PIPE)

        out, err = proc.communicate()

        #  Get the output
        if out.strip() == "PASSED":
            return True
        else:
            return False

    # ------------------------------------------------------ #
    # -        Run the scan on a range of elements         - #
    # ------------------------------------------------------ #
    def Run_Scan_Range(self, endpoint_list, arg_list, num_threads=1 ):

        #  Run the multiprocessing module
        pool = Pool( processes=num_threads )

        #  Return the scan result
        output = pool.map( Run_Scanner, itertools.izip(itertools.repeat(self),
                                                       endpoint_list,
                                                       itertools.repeat(arg_list)))

        return output

# ----------------------------------- #
# -    Load the list of scanners    - #
# ----------------------------------- #
def llnms_load_scanners( llnms_home ):

    output = []

    #  Build the command
    cmd = 'llnms-list-scanners -l -f'

    #  Get the list of scanners
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)

    #  Get the data
    out, err = p.communicate()

    #  Split the list
    logging.info('Command: ' + cmd + '\n stdout: ' + out.strip() + '\n stderr: ' + err.strip())

    lst = filter( ( lambda a : len(str(a).strip()) > 0 ), str(out).split("\n"))
    for ls in lst:

        #  Create the temp scanner
        output.append(Scanner(filename=ls))


    #  Return the output
    return output

# ---------------------------------------- #
# -      Find a particular scanner       - #
# ---------------------------------------- #
def find_scanner( scanner_id, llnms_home ):

    #  Get the list of networks
    scanner_list = llnms_load_scanners(llnms_home)

    #  Iterate over networks
    for scanner_item in scanner_list:

        #  Compare the scanner id
        if scanner_item.id == scanner_id:
            return scanner_item

    #  Otherwise, return none
    return None

