__author__ = 'marvinsmith'


#  System Libraries
import subprocess, logging, os, xml.etree.ElementTree as ET


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

        #  Set the ID
        if id is not None:
            self.id = id

        #  Set the value
        if value is not None:
            self.value = value

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

    # --------------------------- #
    # -      Constructor        - #
    # --------------------------- #
    def __init__( self,
                  id = None,
                  name = None,
                  description = None,
                  filename=None):

        #  Set the ID
        if id is not None:
            self.id = id

        #  Set the filename
        if filename is not None:
            self.Load_From_File(filename)

        #  Set the name
        if name is not None:
            self.name = name

        #  Set the description
        if description is not None:
            self.description = description


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
                temp_arg.name       = argnode.get('type')
                temp_arg.type_value = argnode.get('value')
                temp_arg.default    = argnode.get('default')

                #  Add the argument
                self.arguments.append(temp_arg)

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