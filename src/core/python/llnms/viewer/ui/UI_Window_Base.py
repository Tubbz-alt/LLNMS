__author__ = 'marvinsmith'


#  Python Libraries
import curses, logging

# --------------------------------- #
# -       Base Window Type        - #
# --------------------------------- #
class Base_Window_Type(object):

    #  Window Title
    window_title = ''

    #  Window render screen
    screen = None

    #  Current Field
    current_field = 0

    #  Address Cursors
    sub_fields      = [0]
    sub_field_range = [0]

    # --------------------------- #
    # -      Constructor        - #
    # --------------------------- #
    def __init__(self, title = None,
                       screen = None,
                       current_field = 0):

        #  Set the title
        if title is not None:
            self.window_title = title

        #  Set the screen
        if screen is not None:
            self.screen = screen

        #  Current Field
        self.current_field = current_field

        #  Address Cursors
        self.sub_fields      = [0]
        self.sub_field_range = [0]

    # ----------------------------- #
    # -     Render the Header     - #
    # ----------------------------- #
    def Render_Header(self):

        #  Print the header
        self.screen.addstr(0, 0, self.window_title)
        self.screen.addstr(1, 0, '-' * (curses.COLS-1))

    # ------------------------------------------- #
    # -      Increment Cursor Field  (Down)     - #
    # ------------------------------------------- #
    def Increment_Active_Field(self):

        #  Increment the subfield
        self.sub_fields[self.current_field] += 1

        #  If the subfield is greater than the range, then increment the field
        if self.sub_fields[self.current_field] > self.sub_field_range[self.current_field]:

            #  Reset the current subfield
            self.sub_fields[self.current_field]=0

            #  Increment the field
            self.current_field += 1

            #  If the field is past the range, then reset
            if self.current_field >= len(self.sub_fields):
                self.current_field = 0

            #  Reset the active subfield
            self.sub_fields[self.current_field]=0

    # ------------------------------------ #
    # -      Decrement Cursor Field      - #
    # ------------------------------------ #
    def Decrement_Active_Field(self):

        #  Decrement the subfield
        self.sub_fields[self.current_field] -= 1

        #  If the subfield is less than 0
        if self.sub_fields[self.current_field] < 0:

            #  Decrement the field
            self.current_field -= 1

            #  If the field is less than 0, move back to the end
            if self.current_field < 0:
                self.current_field = len(self.sub_fields)-1

            #  Adjust the current subfield
            self.sub_fields[self.current_field] = self.sub_field_range[self.current_field]

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

    sub_fields       = [0]
    sub_field_ranges = [0]

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

        if len(field) <= 0:
            return

        #  Print the field
        self.screen.addstr( row, col, field)

        #  Configure the color pair
        cpair = curses.color_pair(color_set[0])
        if highlight == True:
            cpair = curses.color_pair(color_set[1])

        #  Compute the offset
        col_offset = col + len(field)
        
        #  Don't print if the string is null
        if len(data) <= 0:
            return

        self.screen.addstr( row, col_offset, data, cpair )

        #  Set the cursor
        if highlight == True:
            cpos =  self.cursors[self.current_field]
            self.screen.addch( row, col_offset + cpos, data[cpos], cpair | curses.A_UNDERLINE)
