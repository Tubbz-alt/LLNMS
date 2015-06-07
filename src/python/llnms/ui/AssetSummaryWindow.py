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

    # Default NCurses Screen
    screen = []

    #  Exit loop variable
    exit_window = False

    #  Subwindows
    sub_windows = []

    #  Add network subwindow
    ADD_ASSET_INDEX = 0

    # ------------------------------- #
    # -        Constructor          - #
    # ------------------------------- #
    def __init__(self, screen ):

        #  Build the Parent
        Base_Window_Type.__init__(self, "Asset Summary Window")

        #  Set the screen
        self.screen = screen

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
        table = CursesTable.CursesTable( 1, 1 )

        #  Set the column headers
        table.Set_Column_Header_Item( 0, ' Asset Name', 0.40)

        table.Set_Column_Alignment( 0, CursesTable.StringAlignment.ALIGN_LEFT )

        #  Load the table
        for x in xrange( 0, len(llnms_state.networks)):

            #  Set the Name
            table.Set_Item( 0, x+1, llnms_state.networks[x].name )

            #  Set the start address
            #table.Set_Item( 1, x+1, llnms_state.networks[x].address_start )

            #  Set the end address
            #table.Set_Item( 2, x+1, llnms_state.networks[x].address_end )

        #  Print the Table
        min_col = 2
        max_col = curses.COLS-1 - min_col
        min_print_row = min_row+2

        table.Render_Table( self.screen,
                            min_col,
                            max_col,
                            min_print_row,
                            max_row, -1)

