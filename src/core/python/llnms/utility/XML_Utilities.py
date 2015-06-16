#    File:    XML_Utilities.py
#    Author:  Marvin Smith
#    Date:    6/15/2015
#
#    Purpose: XML Parsing Utilities
#
__author__ = 'Marvin Smith'


# -------------------------------- #
# -      Indent an XML File      - #
# -------------------------------- #
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

