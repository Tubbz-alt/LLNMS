__author__ = 'Marvin Smith'

#  LLNMS Libraries
from ..Globals import *

#  Python Libraries
import re

# ---------------------- #
# -      IP Type       - #
# ---------------------- #
class IP_Address_Type(object):

    #  Value
    UNKNOWN = -1
    IPV4    = 0
    IPV6    = 1

    # ----------------------------- #
    # -         To String         - #
    # ----------------------------- #
    def To_String(self, value ):

        #  If IPV4
        if value == self.IPV4:
            return 'ipv4'

        #  If IPV6
        if value == self.IPV6:
            return 'ipv6'

        #  Return
        return 'unknown'

    # ----------------------------- #
    # -       From String         - #
    # ----------------------------- #
    def From_String(self, value):

        # IP4
        if value == 'ipv4' or value == 'ip4' or value == 'ip4-address':
            return IP_Address_Type.IPV4

        #  IP6
        if value == 'ipv6' or value == 'ip6' or value == 'ip6-address':
            return IP_Address_Type.IPV6

        #  Unknown
        return IP_Address_Type.UNKNOWN

    # ------------------------------- #
    # -       Check if Valid        - #
    # ------------------------------- #
    def Is_Valid(self, value):

        if value == IP_Address_Type.IPV4:
            return True
        if value == IP_Address_Type.IPV6:
            return True
        return False

# ---------------------------------------------- #
# -     Make sure network input is valid       - #
# ---------------------------------------------- #
def Is_Valid_IP4_Address( address ):

    #  Check none
    if address is None:
        return False

    #  Regex Check
    prog = re.compile(LLNMS_IP4_REGEX_PATTERN)
    if prog.match(address) is None:
        return False

    #  Split on period
    comps = address.split('.')
    if len(comps) != 4:
        return False

    #  Check the range
    for x in xrange(0,4):

        #  Make sure the components are >= 0 and <= 255
        if int(comps[x]) < 0 or int(comps[x]) > 255:
            return False

    return True