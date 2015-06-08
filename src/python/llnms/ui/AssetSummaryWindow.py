__author__ = 'marvinsmith'

#  Python Libraries
import curses

#  LLNMS Libraries
from UI_Window_Base import Base_Window_Type
from AssetAddWindow import AssetAddWindow
import CursesTable


# ---------------------------------------- #
# -         Asset Summary Window         - #
# ---------------------------------------- #
class AssetSummaryWindow(Base_Window_Type):

    #  Exit loop variable
    exit_window = False

    #  Subwindows
    sub_windows = []

    #  Add network subwindow
    ADD_ASSET_INDEX = 0

    # ------------------------------- #
    # -        Constructor          - #
    # ------------------------------- #
    def __init__(self, screen = None, title=None ):

        #  Build the Parent
        Base_Window_Type.__init__(self, title="Asset Summary Window", screen=screen)

        #  Add the add network window
        self.sub_windows.append(AssetAddWindow(screen))

    # ----------------------------- #
    # -    Process the window     - #
    # ----------------------------- #
    def Process(self, llnms_state):

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

            #  If user wants to refresh network screen
            elif c == ord('r'):
                llnms_state.refresh_networks()

            #  Add network
            elif c == ord('a'):
                llnms_state = self.sub_windows[self.ADD_ASSET_INDEX].Process(llnms_state)

        return llnms_state

    # ------------------------- #
    # -     Render Header     - #
    # ------------------------- #
    def Render_Header(self):

        #  Add the title
        self.screen.addstr( 0, 0, self.window_title)

        #  Add the horizontal bar
        self.screen.addstr( 1, 0, '-' * (curses.COLS-1))

    # --------------------------------------- #
    # -     Print Network Summary Footer    - #
    # --------------------------------------- #
    def Render_Footer(self):

        #  Render Horizontal Bar
        self.screen.addstr( curses.LINES-4, 0, '-' * (curses.COLS-1))

        #  Render Menu
        self.screen.addstr( curses.LINES-3, 0, 'q) Return to main menu, r) Refresh')
        self.screen.addstr( curses.LINES-2, 0, 'a) Add asset')

    # ------------------------------------------ #
    # -    Print the Network Summary Table     - #
    # ------------------------------------------ #
    def Render_Asset_Summary_Table(self, llnms_state, min_row, max_row ):

        #  Create the table
        table = CursesTable.CursesTable( 4, 1 )

        #  Set the column headers
        table.Set_Column_Header_Item( 0, ' Hostname',    0.20)
        table.Set_Column_Header_Item( 1, ' IP Address',  0.25)
        table.Set_Column_Header_Item( 2, ' Description', 0.40)
        table.Set_Column_Header_Item( 3, ' Scanners',    0.15)

        table.Set_Column_Alignment( 0, CursesTable.StringAlignment.ALIGN_LEFT )
        table.Set_Column_Alignment( 1, CursesTable.StringAlignment.ALIGN_LEFT )
        table.Set_Column_Alignment( 2, CursesTable.StringAlignment.ALIGN_LEFT )
        table.Set_Column_Alignment( 3, CursesTable.StringAlignment.ALIGN_LEFT )

        #  Get the asset list
        assets = llnms_state.assets

        #  Load the table
        counter = 1
        for x in xrange( 0, len(assets)):

            #  Set the Hostname
            table.Set_Item( 0, counter, assets[x].hostname )

            #  Set the IP Address
            table.Set_Item( 1, counter, assets[x].address )

            #  Set the description
            table.Set_Item( 2, counter, assets[x].description )

            #  Set the scanners
            scanners = assets[x].scanners
            for y in xrange(0, len(scanners)):
                table.Set_Item( 3, counter, scanners[y].id )
                counter += 1
            counter += 1

        #  Print the Table
        min_col = 2
        max_col = curses.COLS-1 - min_col
        min_print_row = min_row+2

        table.Render_Table( self.screen,
                            min_col,
                            max_col,
                            min_print_row,
                            max_row, -1)

