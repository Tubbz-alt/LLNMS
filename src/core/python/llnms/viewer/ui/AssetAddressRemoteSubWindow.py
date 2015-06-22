#    File:    AssetAddressRemoteSubWindow.py
#    Author:  Marvin Smith
#    Date:    6/21/2015
#
#    Purpose: Modify or create asset remote configurations.
#
__author__ = 'Marvin Smith'


#  Python Libraries
import curses, logging

#  LLNMS Libraries
import CursesTable, UI_Window_Base
from ErrorWindow import ErrorWindow
from ...Asset import AssetRemoteAccessState

# ------------------------------------------- #
# -      Add Asset Remote Window Object     - #
# ------------------------------------------- #
class AssetAddressRemoteSubWindow(UI_Window_Base.Base_Sub_Window_Type):

    #  Exit window
    exit_window = False

    #  Address Info
    remote_access = None

    #  offset
    x_offset = 10
    y_offset = 10

    # -------------------------- #
    # -      Constructor       - #
    # -------------------------- #
    def __init__(self, screen ):

        #  Build Parent
        UI_Window_Base.Base_Sub_Window_Type.__init__(self, screen)


    # --------------------------------- #
    # -     Build Default Settings    - #
    # --------------------------------- #
    def Set_Defaults(self, remote_access = None):

        # Set the remote access
        if remote_access is not None:
            self.remote_access = remote_access
        else:
            self.remote_access = AssetRemoteAccessState()

        #  Set the current field
        self.current_field = 0

        #  Set the address and scan fields
        self.sub_fields       = [0]
        self.sub_field_ranges = [0]

        #  Build the cursor list
        self.cursors = [0]




    # -------------------------------- #
    # -     Process This Window      - #
    # -------------------------------- #
    def Process(self, remote_access = None):

        #  Construct defaults
        self.Set_Defaults(remote_access)

        #  Start loop
        self.exit_window = False
        while self.exit_window != True:

            #  Print the background
            self.Render_Background()

            #  Render the main window
            self.Render_Main_Content()

            #  Refresh
            self.screen.refresh()

            #  Get the input
            c = self.screen.getch()

            #  If user wants to cancel without saving
            if c == 27:
                self.exit_window = True
                return None


            #  If the user provides the enter key
            elif c == curses.KEY_ENTER or c == 10:
                self.exit_window = True


            #  If the user provides arrow key, switch
            elif c == ord('\t') or c == curses.KEY_DOWN:
                self.current_field = (self.current_field + 1) % len(self.cursors)


            #  If the user provides up
            elif c == curses.KEY_UP:
                self.current_field -= 1
                if self.current_field < 0:
                    self.current_field = 0


            #  If entry is text, add to entry
            else:
                self.Process_Text( c )


        #  Return the updated llnms state
        return self.address


    # ---------------------------------- #
    # -      Render the Background     - #
    # ---------------------------------- #
    def Render_Background(self):

        #  Iterate over everything
        for y in xrange( self.y_offset, curses.LINES-self.y_offset):

            #  Width
            width_str = ' ' * (curses.COLS-(2 * self.x_offset))

            #  Print line
            self.screen.addstr( y, self.x_offset, width_str, curses.color_pair(4) )


    # ------------------------------------- #
    # -      Render the Main Content      - #
    # ------------------------------------- #
    def Render_Main_Content(self):

        #  Build the color set
        color_set = [0,1]

        #  Render the Remote Enabled Section
        self.Render_Remote_Enabled(color_set)


        #  Print the next option line
        instruction_line = curses.LINES-self.y_offset-4
        info_str = ''
        if self.current_field == 0:
            info_str += ' Tab) Toggle between enabled and disabled.'
        self.screen.addstr( instruction_line, self.x_offset+3, info_str)

        #  Print the option line
        instruction_line = curses.LINES-self.y_offset-3
        self.screen.addstr( instruction_line, self.x_offset+3, 'Enter) Validate and Save,  ESC) Cancel')

        option_line = curses.LINES-self.y_offset-2
        self.screen.addstr( option_line,      self.x_offset+3, 'option:', curses.color_pair(4))

    # ---------------------------------------------- #
    # -      Render the Remote Enabled Section     - #
    # ---------------------------------------------- #
    def Render_Remote_Enabled(self, color_set):

        #  Set the type
        row   = self.y_offset + 5
        col   = self.x_offset + 5
        field = 'Remote Access: '
        if self.remote_access.enabled is True:
            value = 'Enabled'
        else:
            value = 'Disabled'

        self.Render_Field( row, col, field, value, color_set)

    # ------------------------------ #
    # -      Render the Field      - #
    # ------------------------------ #
    def Render_Field(self, row, col, field, value, color_set):

        width = curses.COLS - len(field) - 6 - (2*self.x_offset)
        entry = CursesTable.Format_String( value, width )
        self.Render_Line( field, entry, row, col, self.current_field == 0, color_set )

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

        #  Key Right
        elif input_key == curses.KEY_RIGHT:
            field = ''
            if self.current_field == 0:
                field = Network_Utilities.IP_Address_Type().To_String(self.address_type)
            elif self.current_field == 1:
                field = self.address_info
            self.cursors[self.current_field] = min(self.cursors[self.current_field]+1, len(field))

    # ------------------------------------------- #
    # -       Add a character to the entry      - #
    # ------------------------------------------- #
    def Add_Letter(self, input_key ):

        #  Update the Network Name
        if self.current_field == 1:
            if self.address_info == '':
                self.address_info = chr(input_key)
            else:
                self.address_info = self.address_info[:self.cursors[1]] + chr(input_key) + self.address_info[self.cursors[1]:]


    # -------------------------------------------- #
    # -      Remove a Letter from the Input      - #
    # -------------------------------------------- #
    def Remove_Letter(self, position ):

        #  Skip if the position is zero
        if position < 0:
            return

        #  Delete the character
        if self.current_field == 1:
            if position < len(self.address_info):
                self.address_info = self.address_info[:position] + self.address_info[position+1:]



    # ----------------------------------------- #
    # -      Check if Input Is Character      - #
    # ----------------------------------------- #
    def Is_Character(self, input_key ):

        #  The address values should only be numbers and periods
        if self.current_field == 1:
            if input_key >= ord('0') and input_key <= ord('9'):
                return True
            elif input_key == ord('.') or input_key == ord(','):
                return True
            else:
                return False


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


