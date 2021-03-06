#    File:    AssetAddAddressWindow.py
#    Author:  Marvin Smith
#    Date:    6/18/2015
#
#    Purpose: Provide user with interface to add asset addresses.
#
__author__ = 'Marvin Smith'

#  System Libraries
import curses, logging

#  LLNMS Utilities
import CursesTable, UI_Window_Base
from ErrorWindow import ErrorWindow
from AssetAddressRemoteSubWindow import AssetAddressRemoteSubWindow
from ...Asset import Asset, AssetAddress, AssetRemoteAccessState
from ...utility import Network_Utilities 


class AddressWindowMode:
    ADD=0
    MODIFY=1

# ------------------------------------ #
# -      Add Asset Window Object     - #
# ------------------------------------ #
class AssetAddAddressSubWindow(UI_Window_Base.Base_Sub_Window_Type):

    #  Exit window
    exit_window = False

    #  Address Info
    address = None

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
    def Set_Defaults(self, mode=None, address=None):

        # Set the cursor list
        self.address = AssetAddress(ip_type=Network_Utilities.IP_Address_Type.IPV4)

        #  Set the current field
        self.current_field = 0

        #  Set the address and scan fields
        self.sub_fields       = [0,0,0]
        self.sub_field_ranges = [0,0,0]
    
        #  Build the cursor list
        self.cursors = [0,0,0]

        #  Set the address
        if mode is not None and mode == AddressWindowMode.MODIFY and address is not None:
            self.address = address


    # -------------------------------- #
    # -     Process This Window      - #
    # -------------------------------- #
    def Process(self, mode        = AddressWindowMode.ADD,
                      address      = None):
        
        #  Construct defaults
        self.Set_Defaults(mode, address)

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

            # If the user provides the modify key while over the remote set
            elif c == ord('m') and self.current_field == 2:

                #  Get the remote access window
                remote_access = AssetAddressRemoteSubWindow(self.screen).Process()
            

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


        #  Set the type
        row   = self.y_offset + 5
        col   = self.x_offset + 5
        field = 'Address Type: '
        value = Network_Utilities.IP_Address_Type().To_String(self.address.ip_type)
        width = curses.COLS - len(field) - 6 - (2*self.x_offset)
        entry = CursesTable.Format_String( value, width )
        self.Render_Line( field, entry, row, col, self.current_field == 0, color_set )


        #  Set the address
        row   = self.y_offset + 9
        col   = self.x_offset + 5
        field = 'Address Value: '
        value = self.address.ip_value
        width = curses.COLS - len(field) - 6 - (2*self.x_offset)
        entry = CursesTable.Format_String( value, width )
        flag  = self.current_field == 1
        self.Render_Line( field, entry, row, col, flag, color_set )


        #  Set the remote info
        row   = self.y_offset + 11
        col   = self.x_offset + 5
        field = 'Remote-Access: '
        value = str(self.address.remote_access.enabled)
        width = curses.COLS - len(field) - 6 - (2*self.x_offset)
        entry = CursesTable.Format_String(value, width)
        flag  = self.current_field == 2
        self.Render_Line( field, entry, row, col, flag, color_set)


        #  Print the option line
        instruction_line = curses.LINES-self.y_offset-3
        self.screen.addstr( instruction_line, self.x_offset+3, 'Press Enter to Validate and Save, ESC to Cancel and return to asset menu.')
	
        option_line = curses.LINES-self.y_offset-2
        self.screen.addstr( option_line,      self.x_offset+3, 'option:', curses.color_pair(4))
    
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


