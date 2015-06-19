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



# ---------------------------------- #
# -      Base Sub-Window Type      - #
# ---------------------------------- #
class Base_Sub_Window_Type(object):

    #  Window Title
    window_title = ''

    #  Window Screen
    screen = None
    
    #  Cursor
    current_field = 0

    #  Cursor List
    cursors = []

    # -------------------------- #
    # -       Constructor      - #
    # -------------------------- #
    def __init__(self, screen, title = None):

        #  Set the title
        if title is not None:
            self.title = title

        #  Set the screen
        self.screen = screen

    
    # --------------------------- #
    # -      Render Line        - #
    # --------------------------- #
    def Render_Line(self, field, data, row, col, highlight, color_set=[0,1]):

        #  Print the field
        self.screen.addstr( row, col, field)

        #  Configure the color pair
        cpair = curses.color_pair(color_set[0])
        if highlight == True:
            cpair = curses.color_pair(color_set[1])

        #  Compute the offset
        col_offset = col + len(field)

        self.screen.addstr( row, col_offset, data, cpair )

        #  Set the cursor
        if highlight == True:
            cpos =  self.cursors[self.current_field]
            self.screen.addch( row, col_offset + cpos, data[cpos], cpair | curses.A_UNDERLINE)
    
    
