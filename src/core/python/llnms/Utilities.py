__author__ = 'Marvin Smith'

#  LLNMS Libraries
import Globals

#  Python Libraries
import re

# ---------------------------------------------- #
# -     Make sure network input is valid       - #
# ---------------------------------------------- #
def Is_Valid_IP4_Address( address ):

    #  Check none
    if address is None:
        return False

    #  Regex Check
    prog = re.compile(Globals.LLNMS_IP4_REGEX_PATTERN)
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



def XML_Indent(elem, level=0):
    i = "\n" + level*"  "
    if len(elem):
        if not elem.text or not elem.text.strip():
            elem.text = i + "  "
        if not elem.tail or not elem.tail.strip():
            elem.tail = i
        for elem in elem:
            XML_Indent(elem, level+1)
        if not elem.tail or not elem.tail.strip():
            elem.tail = i
    else:
        if level and (not elem.tail or not elem.tail.strip()):
            elem.tail = i

