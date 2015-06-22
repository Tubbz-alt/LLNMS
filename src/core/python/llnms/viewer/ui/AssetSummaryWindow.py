#    File:    AssetSummaryWindow.py
#    Author:  Marvin Smith
#    Date:    6/21/2015
#
#    Purpose:  Print a list of assets.
#
__author__ = 'marvinsmith'

#  Python Libraries
import curses, logging

#  LLNMS Libraries
from UI_Window_Base import Base_Window_Type
from AssetAddWindow import AssetAddWindow
from AssetModifyWindow import AssetModifyWindow
import CursesTable


# ---------------------------------------- #
# -         Asset Summary Window         - #
# ---------------------------------------- #
class AssetSummaryWindow(Base_Window_Type):

    #  Exit loop variable
    exit_window = False

    #  Subwindows
    sub_windows = []

    #  Add Asset Sub Window
    ADD_ASSET_INDEX = 0

    #  Modify Asset Sub Window
    MODIFY_ASSET_INDEX = 1


    # ------------------------------- #
    # -        Constructor          - #
    # ------------------------------- #
    def __init__(self, screen = None, title=None ):

        #  Build the Parent
        Base_Window_Type.__init__(self, title="Asset Summary Window", screen=screen)

        #  Add the add asset window
        self.sub_windows.append(AssetAddWindow(screen))

        #  Modify asset window
        self.sub_windows.append(AssetModifyWindow(screen))


    # ----------------------------- #
    # -    Set default options    - #
    # ----------------------------- #
    def Set_Defaults(self, llnms_state):

        #  Set the cursors
        self.current_field = 0
        self.sub_fields      = [0] * len(llnms_state.asset_list)
        self.sub_field_range = [0] * len(llnms_state.asset_list)



    # ----------------------------- #
    # -    Process the window     - #
    # ----------------------------- #
    def Process(self, llnms_state):

        #  Set defaults
        self.Set_Defaults(llnms_state)


        #  Set the exit window flag
        self.exit_window = False
        while self.exit_window == False:

            #  clear the screen
            self.screen.clear()

            #  Print the header
            self.Render_Header()

            #  Print the tables
            max_network_row = curses.LINES - 5
            self.Render_Asset_Summary_Table( llnms_state,  3, max_network_row )

            #  Print the footer
            self.Render_Footer()

            #  grab the input
            self.screen.addstr( curses.LINES-1, 0, 'option:')
            self.screen.refresh()

            # get input
            c = self.screen.getch()

            #  If user wants to quit
            if c == ord('q'):
                self.exit_window = True

            #  If user wants to refresh asset summary screen
            elif c == ord('r'):
                llnms_state.Reload_Assets()

            #  Modify asset
            elif c == ord('m'):
                llnms_state.asset_list[self.current_field] = self.sub_windows[self.MODIFY_ASSET_INDEX].Process(llnms_state.asset_list[self.current_field])
                llnms_state.Reload_Assets()

            #  Add new asset
            elif c == ord('a'):
                llnms_state = self.sub_windows[self.ADD_ASSET_INDEX].Process(llnms_state)
                self.sub_fields.append(0)
                self.sub_field_range.append(0)

            #  Remove asset
            elif c == ord('d'):
                llnms_state.Remove_Asset(llnms_state.asset_list[self.current_field])
                self.current_field -= 1
                if self.current_field < 0:
                    self.current_field = 0
                self.sub_fields      = self.sub_fields[0:len(self.sub_fields)-1]
                self.sub_field_range = self.sub_field_range[0:len(self.sub_field_range)-1]

            #  Arrow Key
            elif c == curses.KEY_DOWN:
                self.Increment_Active_Field()

            elif c == curses.KEY_UP:
                self.Decrement_Active_Field()


        return llnms_state


    # --------------------------------------- #
    # -     Print Network Summary Footer    - #
    # --------------------------------------- #
    def Render_Footer(self):

        #  Render Horizontal Bar
        self.screen.addstr( curses.LINES-4, 0, '-' * (curses.COLS-1))

        #  Render Menu
        self.screen.addstr( curses.LINES-3, 0, 'q) Return to main menu, r) Refresh')
        self.screen.addstr( curses.LINES-2, 0, 'a) Add asset, d) Delete selected asset, m) Modify selected asset.')

    # ------------------------------------------ #
    # -    Print the Network Summary Table     - #
    # ------------------------------------------ #
    def Render_Asset_Summary_Table(self, llnms_state, min_row, max_row ):

        #  Create the table
        table = CursesTable.CursesTable( 4, 1 )

        #  Set the column headers
        table.Set_Column_Header_Item( 0, ' Hostname',    0.20)
        table.Set_Column_Header_Item( 1, ' Addresses',   0.25)
        table.Set_Column_Header_Item( 2, ' Description', 0.40)
        table.Set_Column_Header_Item( 3, ' Scanners',    0.15)

        table.Set_Column_Alignment( 0, CursesTable.StringAlignment.ALIGN_LEFT )
        table.Set_Column_Alignment( 1, CursesTable.StringAlignment.ALIGN_LEFT )
        table.Set_Column_Alignment( 2, CursesTable.StringAlignment.ALIGN_LEFT )
        table.Set_Column_Alignment( 3, CursesTable.StringAlignment.ALIGN_LEFT )

        #  Get the asset list
        asset_list = llnms_state.asset_list
        asset_pos_list = [x for x in xrange(0,len(llnms_state.asset_list))]

        #  Load the table
        counter = 1
        for x in xrange( 0, len(asset_list)):

            #  Set the position
            asset_pos_list[x] = counter

            #  Set the Hostname
            table.Set_Item( 0, counter, asset_list[x].hostname )

            #  Set the description
            table.Set_Item( 2, counter, asset_list[x].description )

            #  Get the IP Address List and scanner list
            max_cnt = max( len(asset_list[x].address_list), len(asset_list[x].registered_scanners))
            for y in xrange(0, max_cnt):

                #  add the address
                if y < len(asset_list[x].address_list):
                    table.Set_Item( 1, counter, asset_list[x].address_list[y].ip_value )

                #  Set the scanner
                if y < len(asset_list[x].registered_scanners):
                    table.Set_Item( 3, counter, asset_list[x].registered_scanners[y][0])

                #  Increment the counter
                counter += 1

            #  Increment the current asset counter
            counter += 1

        #  Print the Table
        min_col = 2
        max_col = curses.COLS-1 - min_col
        min_print_row = min_row+2

        #  set the cursor index
        cursor_idx = asset_pos_list[self.current_field]

        #  Render
        table.Render_Table( self.screen,
                            min_col,
                            max_col,
                            min_print_row,
                            max_row,
                            cursor_idx=cursor_idx)

