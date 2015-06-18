#    File:    Context.py
#    Author:  Marvin Smith
#    Date:    6/17/2015
#
#    Purpose:  LLNMS Context Object.
#

# LLNMS Imports
from .. import Asset

# ------------------------------- #
# -      LLNMS State Object     - #
# ------------------------------- #
class LLNMS_State(object):

    #  LLNMS_HOME
    LLNMS_HOME=None

    #  List of LLNMS Assets
    asset_list = []

    # ----------------------------- #
    # -        Constructor        - #
    # ----------------------------- #
    def __init__(self, llnms_home=None ):

        #  Set the LLNMS_HOME Variable
        self.LLNMS_HOME=llnms_home
        
        #  Load the LLNMS Assets
        asset_list = Asset.llnms_load_assets(llnms_home=self.LLNMS_HOME)

