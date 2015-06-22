#    File:    AssetModifyWindow.py
#    Author:  Marvin Smith
#    Date:    6/21/2015
#
#    Purpose: Modify an existing Asset.
#
__author__ = 'Marvin Smith'


#  System Libraries
import curses, logging

#  LLNMS Utilities
import CursesTable

from UI_Window_Base import Base_Window_Type
from AssetAddAddressWindow import AssetAddAddressSubWindow, AddressWindowMode
from ErrorWindow import ErrorWindow
from ...Asset import Asset
from ...utility.Network_Utilities import IP_Address_Type


# --------------------------------------- #
# -      Modify Asset Window Object     - #
# --------------------------------------- #
class AssetModifyWindow(Base_Window_Type):

    #  Default Screen
    screen = None

    #  Exit window
    exit_window = False

    #  Current Asset Data
    asset_data = None

    #  Cursor List
    cursors = None

    # -------------------------- #
    # -      Constructor       - #
    # -------------------------- #
    def __init__(self, screen ):

        #  Build the parent
        Base_Window_Type.__init__(self, title='Modify Asset Window',
                                        screen=screen,
                                        current_field=0)


    # --------------------------------- #
    # -     Build Default Settings    - #
    # --------------------------------- #
    def Set_Defaults(self):

        # Set the cursor list
        self.cursors = [0,0,0,0]

        #  Set the current field
        self.current_field    = 0

        #  Set the address and scan fields
        self.sub_fields      = [0,0,0,0]
        self.sub_field_range = [0,0,0,0]

        #  Load the asset data
        self.asset_data = None


    # -------------------------------- #
    # -     Process This Window      - #
    # -------------------------------- #
    def Process(self, asset ):

        #  Construct defaults
        self.Set_Defaults()

        #  Update the asset
        self.asset_data = asset
        self.sub_field_range[2] = len(self.asset_data.address_list)
        self.sub_field_range[3] = len(self.asset_data.registered_scanners)

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
            self.screen.addstr( curses.LINES-1, 0, 'option:')
            self.screen.refresh()

            #  Get the input
            c = self.screen.getch()

            #  If user wants to quit
            if c == 27:
                self.exit_window = True
                return asset

            #  If the user wants to modify the current asset
            if c == ord('m'):
                if self.current_field == 2 and self.sub_fields[self.current_field] < len(self.asset_data.address_list):

                    #  Modify
                    new_asset_address = AssetAddAddressSubWindow(self.screen).Process(mode=AddressWindowMode.MODIFY, address=self.asset_data.address_list[self.sub_fields[self.current_field]])

                    if new_asset_address is not None:
                        self.asset_data.address_list[self.sub_fields[self.current_field]] = new_asset_address

            #  If the user provides the enter key
            elif c == curses.KEY_ENTER or c == 10:

                #  Check if the user requested to add an address
                if self.current_field == 2 and self.sub_fields[self.current_field] == len(self.asset_data.address_list):

                    #  Render the add address window
                    new_asset_address = AssetAddAddressSubWindow(self.screen).Process(mode=AddressWindowMode.ADD)

                    #  Add the address
                    if new_asset_address is not None:
                        self.asset_data.address_list.append(new_asset_address)
                        self.sub_field_range[self.current_field] += 1

                #  Otherwise, add the asset
                else:

                    #  Make sure the network is valid
                    status_flag, error_msg = self.asset_data.Is_Valid(print_error_msg=True)
                    if status_flag is False:

                        #  Render an error window
                        ErrorWindow().Process(self.screen, 'Invalid Asset.', error_msg)

                    else:
                        self.exit_window = True


            #  If the user provides arrow key, increment the cursor
            elif c == ord('\t') or c == curses.KEY_DOWN:
                self.Increment_Active_Field()


            #  If the user provides up arrow key, decrement the cursor
            elif c == curses.KEY_UP:
                self.Decrement_Active_Field()


            #  If entry is text, add to entry
            else:
                self.Process_Text( c )


        #  Write the asset
        self.asset_data.Write_Asset_File()

        #  Return the updated llnms state
        return self.asset_data

    # ------------------------------- #
    # -     Render the Header       - #
    # ------------------------------- #
    def Render_Header(self):

        #  Add the header
        self.screen.addstr(0, 0, ' LLNMS Add Asset')
        self.screen.addstr(1, 0, '-' * (curses.COLS-1))

    # ------------------------------ #
    # -     Render the Footer      - #
    # ------------------------------ #
    def Render_Footer(self):

        #  Render Horizontal Bar
        self.screen.addstr( curses.LINES-4, 0, '-' * (curses.COLS-1))

        #  Render Menu
        self.screen.addstr( curses.LINES-3, 0, 'ESC) Cancel,  ENTER)  Accept,  Up/Down Arrow, Tab) Switch Current Field.,  m) When over address or scanner, modify it.')
        self.screen.addstr( curses.LINES-2, 0, 'Input text into fields.')

    # --------------------------------- #
    # -     Render Main Content       - #
    # --------------------------------- #
    def Render_Main_Content(self):

        # Render the asset hostname
        host_field = 'Hostname Field: '
        max_host_width = curses.COLS - len(host_field) - 5
        host_entry = CursesTable.Format_String( self.asset_data.hostname, max_host_width)
        self.Render_Line( host_field, host_entry, 3, 2, self.current_field == 0)

        #  Render the asset description
        desc_field = 'Description Field: '
        max_desc_width = curses.COLS - len(desc_field) - 5
        desc_entry = CursesTable.Format_String( self.asset_data.description, max_desc_width)
        self.Render_Line( desc_field, desc_entry, 5, 2, self.current_field == 1)

        #  Render the asset address list
        addr_field = 'Address List'
        max_addr_width = curses.COLS - len(addr_field) - 5
        self.Render_Line( addr_field, '', 7, 2, False )


        #  Print the header
        counter = 9
        self.screen.addstr( counter,   2, ' ID  Address Type      Address Value     Remote Access')
        self.screen.addstr( counter+1, 2, '--------------------------------------------------------' )

        #  iterate over each address
        counter += 2
        step = 0
        for addr in self.asset_data.address_list:

            #  Compute the field
            address_field        = str(step)
            address_type_field   = IP_Address_Type().To_String(addr.ip_type)
            address_entry_field  = str(addr.ip_value)
            address_remote_field = str(addr.remote_access.enabled)

            #  Line Data
            address_data = CursesTable.Format_String(address_type_field, 14) + CursesTable.Format_String(address_entry_field, 18) + CursesTable.Format_String(address_remote_field, 14)

            #  Get the field flag
            field_flag = (self.current_field == 2) and (self.sub_fields[self.current_field] == step)

            #  Render the line
            self.Render_Line( address_field, address_data, counter, 4, field_flag, field_to_data_gap=8 )

            #  Increment the counter
            counter += 1
            step += 1

        #  Add the final example
        field_flag = (self.current_field == 2) and (self.sub_fields[self.current_field] == step)
        self.Render_Line( '*', 'Select this to add new address entry.', counter, 4, field_flag, field_to_data_gap=8 )


        #  Render the asset scanner list
        scan_field = 'Scanner List'
        max_scan_width = curses.COLS - 5 - len(scan_field)
        self.Render_Line( scan_field, '', curses.LINES/2, 2, False )

         #  Print the header
        counter = curses.LINES/2 + 1
        self.screen.addstr( counter,   2, ' ID  Address Type      Address Value     Remote Access')
        self.screen.addstr( counter+1, 2, '--------------------------------------------------------' )

        #  iterate over each address
        counter += 2
        step = 0
        for addr in self.asset_data.registered_scanners:

            #  Compute the field
            scanner_field        = str(step)

            #  Line Data
            scanner_data = ''

            #  Get the field flag
            field_flag = (self.current_field == 3) and (self.sub_fields[self.current_field] == step)

            #  Render the line
            self.Render_Line( scanner_field, scanner_data, counter, 4, field_flag, field_to_data_gap=8 )

            #  Increment the counter
            counter += 1
            step += 1

        #  Add the final example
        field_flag = (self.current_field == 3) and (self.sub_fields[self.current_field] == step)
        self.Render_Line( '*', 'Select this to add new scanner entry.', counter, 4, field_flag, field_to_data_gap=8 )


        return


    # --------------------------- #
    # -      Render Line        - #
    # --------------------------- #
    def Render_Line(self, field, data, row, field_col, highlight, field_to_data_gap=2 ):

        #  Print the field
        self.screen.addstr( row, field_col, field)

        #  Configure the color pair
        cpair = curses.color_pair(0)
        if highlight == True:
            cpair = curses.color_pair(1)

        #  Compute the offset
        col_offset = field_col + len(field) + field_to_data_gap

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
                field = self.asset_data.hostname
            elif self.current_field == 1:
                field = self.asset_data.description
            self.cursors[self.current_field] = min(self.cursors[self.current_field]+1, len(field))

    # ------------------------------------------- #
    # -       Add a character to the entry      - #
    # ------------------------------------------- #
    def Add_Letter(self, input_key ):

        #  Update the Asset Hostname
        if self.current_field == 0:
            if self.asset_data.hostname == '':
                self.asset_data.hostname = chr(input_key)
            else:
                self.asset_data.hostname = self.asset_data.hostname[:self.cursors[0]] + chr(input_key) + self.asset_data.hostname[self.cursors[0]:]

        elif self.current_field == 1:
            if self.asset_data.description == '':
                self.asset_data.description = chr(input_key)
            else:
                self.asset_data.description = self.asset_data.description[:self.cursors[1]] + chr(input_key) + self.asset_data.description[self.cursors[1]:]


    # -------------------------------------------- #
    # -      Remove a Letter from the Input      - #
    # -------------------------------------------- #
    def Remove_Letter(self, position ):

        #  Skip if the position is zero
        if position < 0:
            return

        #  Delete the character
        if self.current_field == 0:
            if position < len(self.asset_data.hostname):
                self.asset_data.hostname = self.asset_data.hostname[:position] + self.asset_data.hostname[position+1:]

        elif self.current_field == 1:
            if position < len(self.asset_data.description):
                self.asset_data.description = self.asset_data.description[:position] + self.asset_data.description[position+1:]



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

