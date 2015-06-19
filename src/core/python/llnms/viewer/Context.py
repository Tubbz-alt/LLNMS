#    File:    Context.py
#    Author:  Marvin Smith
#    Date:    6/17/2015
#
#    Purpose:  LLNMS Context Object.
#

# LLNMS Imports
from .. import Asset
from .. import Network

#  Python Imports
import datetime, os, logging, shutil
from ConfigParser import SafeConfigParser

# ------------------------------- #
# -      LLNMS State Object     - #
# ------------------------------- #
class LLNMS_State(object):

    #  LLNMS_HOME
    LLNMS_HOME=None

    #  List of LLNMS Assets
    asset_list = []
    
    #  List of LLNMS Networks
    network_list = []

    #  Log Path
    log_pathname = os.environ['LLNMS_HOME'] + '/.llnms-viewer.log'

    #  Log State
    log_state = True

    # ----------------------------- #
    # -        Constructor        - #
    # ----------------------------- #
    def __init__(self, llnms_home=None ):

        #  Load the configuration file
        self.Load_Configuration_File()

        #  Set the LLNMS_HOME Variable
        self.LLNMS_HOME=llnms_home
        
        #  Load the LLNMS Assets
        self.asset_list  = Asset.llnms_load_assets(llnms_home=self.LLNMS_HOME)

        #  Load the LLNMS Networks
        self.network_list = Network.llnms_load_networks(llnms_home=self.LLNMS_HOME)
    
    # -------------------------- #
    # -       Add network      - #
    # -------------------------- #
    def Add_Network(self, new_network):
        
        #  Check if the network has a pathname
        if new_network.filename is None:
            new_network.filename = self.LLNMS_HOME + '/networks/' + datetime.datetime.now().strftime('%Y%M%d_%H%m%s') + '.llnms-network.xml'

        #  Write the network file
        new_network.Write_Network_File()

        #  Reload
        self.network_list = Network.llnms_load_networks(llnms_home=self.LLNMS_HOME)
    
    # ---------------------------------------- #
    # -       Remove an LLNMS Network        - #
    # ---------------------------------------- #
    def Remove_Network(self, network):

        #  Iterate over networks
        for net in self.network_list:
            if net.name == network.name:
                os.remove(network.filename)

        #  Reload the network llist
        self.Reload_Networks()

    # ----------------------------------- #
    # -     Reload the Network List     - #
    # ----------------------------------- #
    def Reload_Networks(self):

        #  Reload
        self.network_list = Network.llnms_load_networks(llnms_home=self.LLNMS_HOME)

    # ----------------------------------------- #
    # -      Process Configuration File       - #
    # ----------------------------------------- #
    def Load_Configuration_File( self, config_filename = None ):

        #  Make sure some config file is available
        if config_filename is None:
            config_filename = os.environ['HOME'] + '/.llnms-viewer.cfg'
        
        # Create a configuration parser
        parser = SafeConfigParser()

        # Read the configuration file
        if os.path.exists(config_filename) == True:
            parser.read(config_filename)
            
            #  Get the log state
            self.log_state = parser.getboolean('logging','enabled')

            #  Get the log pathname
            self.log_pathname = parser.get('logging','pathname')

        
        # Otherwise, generate the file
        else:
                
            #  Add the log file
            parser.add_section('logging')
            
            parser.set('logging','enabled','True')
            parser.set('logging','pathname',self.log_pathname)

            #  Write
            with open(config_filename,'wb') as configfile:
                parser.write(configfile)
        

        #  Configure Logging
        if self.log_state is True:
            logging.basicConfig( filename= self.log_pathname, 
                                 filemode='w', 
                                 level=logging.DEBUG)

