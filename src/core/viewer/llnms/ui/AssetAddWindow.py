__author__ = 'marvinsmith'

#  System Libraries
import curses, logging



class AssetAddWindow(object):

    #  Default Screen
    screen = None

    #  Exit window
    exit_window = False

    #  Current Asset Data
    asset_data = None

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
        self.asset_data = []

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

        #  Return the updated llnms state
        return llnms_state

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
        self.screen.addstr( curses.LINES-3, 0, 'ESC) Cancel')

    # --------------------------------- #
    # -     Render Main Content       - #
    # --------------------------------- #
    def Render_Main_Content(self):

        # Render the network data
        return