__author__ = 'marvinsmith'

#  System Libraries
import curses, logging, sys

#  LLNMS Utilities
import CursesTable 
from ErrorWindow import ErrorWindow
from ...Network import Network

class NetworkAddWindow(object):

    #  Default Screen
    screen = None

    #  Exit window
    exit_window = False

    #  Current Network Data
    network_data = None

    #  Current field
    current_field = 0

    cursors = [0,0,0]

    # -------------------------- #
    # -      Constructor       - #
    # -------------------------- #
    def __init__(self, screen ):

        #  Set the screen
        self.screen = screen

    # -------------------------------- #
    # -     Process This Window      - #
    # -------------------------------- #
    def Process(self, llnms_state ):

        #  Clear the network data
        self.network_data = Network( name='',
                                     address_start='',
                                     address_end='',
                                     description='')

        #  Start loop
        self.exit_window = False
        while self.exit_window != True:

            #  Clear the screen
            self.screen.clear()

            #  Print the header
            self.Render_Header()

            #  Render the main window
            self.Render_Main_Content()

            # Print the footer
            self.Render_Footer()

            #  Refresh
            self.screen.addstr( curses.LINES-1, 0, 'input :')
            self.screen.refresh()

            #  Get the input
            c = self.screen.getch()

            #  If user wants to quit
            if c == 27:
                self.exit_window = True

            #  If the user provides the enter key
            elif c == curses.KEY_ENTER or c == 10:

                #  Make sure the network is valid
                status, error_msg = self.network_data.Is_Valid(print_error_msg=True)
                if status is False:
                    
                    #  Render an error window
                    ErrorWindow().Process(self.screen, 'Invalid Network.', error_msg)

                else:
                    llnms_state.Add_Network(self.network_data)
                    self.exit_window = True

            #  If the user provides arrow key, switch
            elif c == ord('\t') or c == curses.KEY_DOWN:
                self.current_field = (self.current_field+1) % 3

            #  If the user provides up
            elif c == curses.KEY_UP:
                self.current_field = (self.current_field-1) % 3

            #  If entry is text, add to entry
            else:
                self.Process_Text( c )

        #  Return the updated llnms state
        return llnms_state

    # ------------------------------- #
    # -     Render the Header       - #
    # ------------------------------- #
    def Render_Header(self):

        #  Add the header
        self.screen.addstr(0, 0, ' LLNMS Add Network')
        self.screen.addstr(1, 0, '-' * (curses.COLS-1))

    # ------------------------------ #
    # -     Render the Footer      - #
    # ------------------------------ #
    def Render_Footer(self):

        #  Render Horizontal Bar
        self.screen.addstr( curses.LINES-4, 0, '-' * (curses.COLS-1))

        #  Render Menu
        self.screen.addstr( curses.LINES-3, 0, 'ESC) Cancel,  ENTER)  Accept,  Up/Down Arrow, Tab) Switch Current Field.')
        self.screen.addstr( curses.LINES-2, 0, 'Input text into fields.')

    # --------------------------------- #
    # -     Render Main Content       - #
    # --------------------------------- #
    def Render_Main_Content(self):

        # Render the network data
        name_field = 'Network Name: '
        max_name_width = curses.COLS - len(name_field) - 5
        name_entry = CursesTable.Format_String( self.network_data.name, max_name_width)
        self.Render_Line( name_field, name_entry, 3, 2, self.current_field == 0)

        #  Render The Start Address
        start_field = 'Starting Address: '
        max_start_width = curses.COLS - len(start_field) - 5
        start_entry = CursesTable.Format_String(self.network_data.address_start, max_start_width)
        self.Render_Line( start_field, start_entry, 5, 2, self.current_field == 1)

        #  Render The End Address
        end_field = 'End Address: '
        max_end_width = curses.COLS - len(end_field) - 5
        end_entry = CursesTable.Format_String(self.network_data.address_end, max_end_width)
        self.Render_Line( end_field, end_entry, 7, 2, self.current_field == 2)

        return

    # --------------------------- #
    # -      Render Line        - #
    # --------------------------- #
    def Render_Line(self, field, data, row, col, highlight ):

        #  Print the field
        self.screen.addstr( row, col, field)

        #  Configure the color pair
        cpair = curses.color_pair(0)
        if highlight == True:
            cpair = curses.color_pair(1)

        #  Compute the offset
        col_offset = col + len(field)

        self.screen.addstr( row, col_offset, data, cpair )

        #  Set the cursor
        if highlight == True:
            cpos =  self.cursors[self.current_field]
            self.screen.addch( row, col_offset + cpos, data[cpos], cpair | curses.A_UNDERLINE)

    # --------------------------------- #
    # -      Process Input Text       - #
    # --------------------------------- #
    def Process_Text(self, input_key ):

        #  Check if letter
        if self.Is_Character(input_key):
            self.Add_Letter(input_key)
            self.cursors[self.current_field] += 1

        #  Check if backspace or Mac delete key
        elif input_key == curses.KEY_BACKSPACE or input_key == 127:
            self.Remove_Letter(self.cursors[self.current_field]-1)
            self.cursors[self.current_field] = max( self.cursors[self.current_field] - 1, 0)

        #  Check if delete key or fn+delete on macs
        elif input_key == curses.KEY_DL:
            self.Remove_Letter(self.cursors[self.current_field])

        #  Key Left
        elif input_key == curses.KEY_LEFT:
            self.cursors[self.current_field] = max(0, self.cursors[self.current_field]-1)

        elif input_key == curses.KEY_RIGHT:
            field = ''
            if self.current_field == 0:
                field = self.network_data.name
            elif self.current_field == 1:
                field = self.network_data.address_start
            elif self.current_field == 2:
                field = self.network_data.address_end
            self.cursors[self.current_field] = min(self.cursors[self.current_field]+1, len(field))

    # ------------------------------------------- #
    # -       Add a character to the entry      - #
    # ------------------------------------------- #
    def Add_Letter(self, input_key ):

        #  Update the Network Name
        if self.current_field == 0:
            if self.network_data.name == '':
                self.network_data.name = chr(input_key)
            else:
                self.network_data.name = self.network_data.name[:self.cursors[0]] + chr(input_key) + self.network_data.name[self.cursors[0]:]

        elif self.current_field == 1:
            if self.network_data.address_start == '':
                self.network_data.address_start = chr(input_key)
            else:
                self.network_data.address_start = self.network_data.address_start[:self.cursors[1]] + chr(input_key) + self.network_data.address_start[self.cursors[1]:]

        elif self.current_field == 2:
            if self.network_data.name == '':
                self.network_data.name = chr(input_key)
            else:
                self.network_data.address_end = self.network_data.address_end[:self.cursors[2]] + chr(input_key) + self.network_data.address_end[self.cursors[2]:]

    # -------------------------------------------- #
    # -      Remove a Letter from the Input      - #
    # -------------------------------------------- #
    def Remove_Letter(self, position ):

        #  Skip if the position is zero
        if position < 0:
            return

        #  Delete the character
        if self.current_field == 0:
            if position < len(self.network_data.name):
                self.network_data.name = self.network_data.name[:position] + self.network_data.name[position+1:]

        elif self.current_field == 1:
            if position < len(self.network_data.address_start):
                self.network_data.address_start = self.network_data.address_start[:position] + self.network_data.address_start[position+1:]

        elif self.current_field == 2:
            if position < len(self.network_data.address_end):
                self.network_data.address_end = self.network_data.address_end[:position] + self.network_data.address_end[position+1:]


    # ----------------------------------------- #
    # -      Check if Input Is Character      - #
    # ----------------------------------------- #
    def Is_Character(self, input_key ):

        #  Check if letter
        if input_key >= ord('a') and input_key <= ord('z'):
            return True
        if input_key >= ord('A') and input_key <= ord('Z'):
            return True
        if input_key >= ord('0') and input_key <= ord('9'):
            return True
        if input_key == ord(' ') or input_key == ord('-'):
            return True
        if input_key == ord('.') or input_key == ord(','):
            return True

        return False
