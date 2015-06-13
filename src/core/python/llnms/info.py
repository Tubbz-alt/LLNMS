#    File:    info.py
#    Author:  Marvin Smith
#    Date:    6/13/2015
#
#    Purpose: Print LLNMS Version Information
#
__author__ = 'marvinsmith'

#  Python Libraries
import os, subprocess

# -------------------------------------------- #
# -        Get the Version From File         - #
# -------------------------------------------- #
def Parse_LLNMS_Version_File( pathname ):

    #  Make sure the path exists
    if os.path.exists(pathname) is False:
        raise Exception("LLNMS Version File at " + pathname + " does not exist.")

    #  Construct a command
    file_data = open(pathname).readlines()

    #  Otherwise, open the file and read the elements
    version_major    = filter( lambda x: 'LLNMS_MAJOR' in str(x), file_data)[0].split('=')[1].strip()
    version_minor    = filter( lambda x: 'LLNMS_MINOR' in str(x), file_data)[0].split('=')[1].strip()
    version_subminor = filter( lambda x: 'LLNMS_SUBMINOR' in str(x), file_data)[0].split('=')[1].strip()


    #  Return the results
    return [version_major, version_minor, version_subminor]

# -------------------------------------------- #
# -        Print the Version String          - #
# -------------------------------------------- #
def Get_Version_String( llnms_home=None ):

    #  LLNMS_Home path
    LLNMS_HOME_PATH=None

    #  Check if LLNMS Home was specified
    if llnms_home is not None:
        LLNMS_HOME_PATH=llnms_home

    #  Check if the environment variable was given
    elif os.environ['LLNMS_HOME'] is not None:
        LLNMS_HOME_PATH=os.environ['LLNMS_HOME']

    #  Otherwise, no info
    else:
        return 'error: LLNMS_HOME unknown.'

    #  Check the version file
    [version_major, version_minor, version_subminor] = Parse_LLNMS_Version_File(LLNMS_HOME_PATH + '/config/llnms-info')

    #  Concat
    return str(version_major) + "." + str(version_minor) + "." + str(version_subminor)