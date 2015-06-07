__author__ = 'marvinsmith'

#  LLNMS Libraries
from network_configuration_page import *
from network_summary_page import *
from AssetSummaryWindow import *
from UI_Window_Base import Base_Window_Type

#  Python Libraries
import time

# ---------------------------------------------------------------- #
# -    Print a response message acknowledging, then returning    - #
# ---------------------------------------------------------------- #
def print_response_message( stdscr, message ):

    #  Print a basic message telling the user you got their response
    stdscr.clear()
    stdscr.addstr(curses.LINES/2, curses.COLS/2-(len(message)/2), message)
    stdscr.refresh()
    time.sleep(0.25)

# ---------------------------- #
# -     Main Window Class    - #
# ---------------------------- #
class MainWindow(Base_Window_Type):

    #  Default LLNMS state
    llnms_state = None

    #  Default NCurses screen
    screen = None

    #  Flag if we want to exit the main loop
    exit_main_loop = False

    #  List of subwindows
    sub_windows = []

    #  Network Summary Page Index
    NETWORK_SUMMARY_INDEX = 0

    #  Asset configuration index
    ASSET_CONFIGURATION_INDEX = 1

    #  Network Configuration Page Index
    NETWORK_CONFIGURATION_INDEX = 2


    # -------------------------------- #
    # -        Constructor           - #
    # -------------------------------- #
    def __init__(self, screen, title = None ):

        #   Build child
        Base_Window_Type.__init__( self, "LLNMS Main Window")

        #  Set the screen
        self.screen = screen

        #  Create the network summary window
        self.sub_windows.append(NetworkSummaryWindow(screen))

        #  Create the asset configuration window
        self.sub_windows.append(AssetSummaryWindow(screen))

        #  Create the network configuration Window
        self.sub_windows.append(NetworkConfigurationWindow(screen))

    # ---------------------------- #
    # -    Render the Screen     - #
    # ---------------------------- #
    def Render(self):

        #  clear the screen
        self.screen.clear()

        #  Print the main menu
        self.screen.addstr(0, 0, self.window_title)
        self.screen.addstr(1, 0, '----------------------')
        self.screen.addstr(2, 0, '1.  Network Summary')
        self.screen.addstr(3, 0, '2.  Asset Summary')
        self.screen.addstr(4, 0, '3.  Network Status')
        self.screen.addstr(5, 0, 'q.  Quit LLNMS-Viewer')
        self.screen.addstr(6, 0, 'option:')
        self.screen.refresh()

    # ----------------------------------- #
    # -     Process Keyboard Input      - #
    # ----------------------------------- #
    def Process_Keyboard_Input(self, input_key, llnms_state ):

        #  Check if user wants to quit
        if input_key == ord('q'):
            print_response_message( self.screen, 'Quitting LLNMS')
            self.exit_main_loop = True

        # check if user wants to view the network summary
        elif input_key == ord('1'):

            #  Print a basic message telling the user you got their response
            print_response_message( self.screen, 'Loading Network Summary Page')

            #  open network summary page
            llnms_state = self.sub_windows[self.NETWORK_SUMMARY_INDEX].Process( llnms_state )

        #  Check if the user wants to view the asset page
        elif input_key == ord('2'):

            print_response_message( self.screen, 'Loading Asset Configuration Page')

            # Open asset page
            llnms_state = self.sub_windows[self.ASSET_CONFIGURATION_INDEX].Process(llnms_state)

        # check if user wants to view the network configuration page
        elif input_key == ord('3'):

            #  Print a basic message telling the user you got their response
            print_response_message( self.screen, 'Loading Network Status Page')

            #  open network summary page
            llnms_state = self.sub_windows[self.NETWORK_CONFIGURATION_INDEX].Process( llnms_state )

        #  Return the updated state
        return llnms_state

    # -------------------------- #
    # -     Process Input      - #
    # -------------------------- #
    def Process(self, llnms_state):

        # start the main loop
        while self.exit_main_loop == False:

            #  Render the Main Window
            self.Render()

            #  Get the input
            c = self.screen.getch()

            #  Process the input
            llnms_state = self.Process_Keyboard_Input( c, llnms_state )

        return llnms_state
