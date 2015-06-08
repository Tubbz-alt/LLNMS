__author__ = 'marvinsmith'


#  Python Libraries
import curses

# --------------------------------- #
# -       Base Window Type        - #
# --------------------------------- #
class Base_Window_Type(object):

    #  Window Title
    window_title = ''

    #  Window render screen
    screen = None

    # --------------------------- #
    # -      Constructor        - #
    # --------------------------- #
    def __init__(self, title = None, screen = None):

        #  Set the title
        if title is not None:
            self.window_title = title

        #  Set the screen
        if screen is not None:
            self.screen = screen
