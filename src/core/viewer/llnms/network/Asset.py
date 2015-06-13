__author__ = 'marvinsmith'

#  System Libraries
import glob, logging, os
import xml.etree.ElementTree as ET

#  Python Libraries
import Scanner

# ---------------------------- #
# -       Asset Class        - #
# ---------------------------- #
class Asset(object):

    #  Hostname
    hostname = None

    #  Address
    address = None

    #  Description
    description = None

    #  Registered scanners
    scanners = []

    #  Filename
    filename = None

    # --------------------------- #
    # -       Constructor       - #
    # --------------------------- #
    def __init__( self,
                  hostname = None,
                  filename = None):

        #  Hostname
        if hostname is not None:
            self.hostname = hostname

        #  Filename
        if filename is not None:
            self.Load_From_File(filename)

    # ---------------------------------------------------- #
    # -      Load the Asset Information From A File      - #
    # ---------------------------------------------------- #
    def Load_From_File(self, filename ):

        #  Set the filename
        self.filename = filename

        #  Make sure the file exists
        if os.path.exists(self.filename) is not True:
            return

        #  Open the XML File
        root = ET.parse(self.filename)

        #  Get the hostname
        hnode = root.find('hostname')
        if hnode is not None:
            self.hostname = hnode.text

        #  Get the ip4 address
        anode = root.find('ip4-address')
        if anode is not None:
            self.address = anode.text

        #  Get the description
        dnode = root.find('description')
        if dnode is not None:
            self.description = dnode.text

        #  Get the scanner list
        snode = root.find('scanners')
        for scanner_node in snode.findall('scanner'):

            #  Get the id
            id = scanner_node.find('id').text

            #  Create the scanner
            temp_scanner = Scanner.Scanner()
            if id is None:
                continue
            temp_scanner.id = id

            #  Get the argument node
            for arg_node in scanner_node.findall('argument'):

                #  Get the name
                arg_name = arg_node.get('name')

                #  Argument value
                arg_value = arg_node.get('value')

                # Add the argument
                if arg_name is not None and arg_value is not None:
                    temp_scanner.arguments.append(Scanner.ScannerArgument(id = arg_name, value = arg_value))

            #  Add to scanner list
            self.scanners.append(temp_scanner)

# -------------------------------- #
# -       Load all Assets        - #
# -------------------------------- #
def llnms_load_assets( llnms_home ):

    #  make sure the directory exists
    asset_files = glob.glob(llnms_home + "/assets/*.llnms-asset.xml")
    logging.debug('Found ' + str(len(asset_files)) + ' asset files.')

    #  create our output
    output = []

    # iterate through the files, loading each
    for asset_file in asset_files:

        #  Create temporary network
        temp_asset = Asset(filename=asset_file)

        output.append(temp_asset)

        #  Log
        logging.debug('Loaded asset file: ' + asset_file)

    #  Return list
    return output

