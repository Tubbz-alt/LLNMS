__author__ = 'marvinsmith'


#  Python Libraries
import curses

# --------------------------------- #
# -       Base Window Type        - #
# --------------------------------- #
class Base_Window_Type(object):

    #  Window Title
    window_title = ''

    # --------------------------- #
    # -      Constructor        - #
    # --------------------------- #
    def __init__(self, title = None):

        #  Set the title
        if title != None:
            self.window_title = title
