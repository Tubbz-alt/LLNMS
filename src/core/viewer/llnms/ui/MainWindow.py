__author__ = 'marvinsmith'

#  LLNMS Libraries
from network_configuration_page import *
from network_summary_page       import *
from AssetSummaryWindow         import *
from ScannerSummaryWindow       import *
from UI_Window_Base import Base_Window_Type
from EventManager import EventManager
import handlers

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

    #  Flag if we want to exit the main loop
    exit_main_loop = False

    #  List of subwindows
    sub_windows = []

    #  Current window
    current_window = -1

    #  Network Summary Page Index
    NETWORK_SUMMARY_INDEX = 0

    #  Asset configuration index
    ASSET_CONFIGURATION_INDEX = 1

    #  Scanner Summary Index
    SCANNER_SUMMARY_INDEX = 2

    #  Network Configuration Page Index
    NETWORK_CONFIGURATION_INDEX = 3

    #  Event Manager
    event_manager = EventManager()


    # -------------------------------- #
    # -        Constructor           - #
    # -------------------------------- #
    def __init__(self, screen, title = None ):

        #   Build child
        Base_Window_Type.__init__( self,
                                   title="LLNMS Main Window",
                                   screen=screen)

        #  Initialize Sub-Windows
        self.Initialize_Sub_Windows()

        #  Initialize Event Manager
        self.Initialize_Event_Manager()

    # ----------------------------------- #
    # -     Initialize Sub-Windows      - #
    # ----------------------------------- #
    def Initialize_Sub_Windows(self):
        #  Create the network summary window
        self.sub_windows.append(NetworkSummaryWindow(title=None, screen=self.screen))

        #  Create the asset configuration window
        self.sub_windows.append(AssetSummaryWindow(title=None, screen=self.screen))

        #  Create the scanner window
        self.sub_windows.append(ScannerSummaryWindow(title=None, screen=self.screen))

        #  Create the network configuration Window
        self.sub_windows.append(NetworkConfigurationWindow(title=None, screen=self.screen))

    # ---------------------------------------- #
    # -     Initialize the event manager     - #
    # ---------------------------------------- #
    def Initialize_Event_Manager(self):

        #  Create the main window handler
        self.event_manager.Register_Handler( handlers.Main_Window_Handler(self) )

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
        self.screen.addstr(4, 0, '3.  Scanner Summary')
        self.screen.addstr(5, 0, '4.  Network Status')
        self.screen.addstr(6, 0, 'q.  Quit LLNMS-Viewer')
        self.screen.addstr(7, 0, 'option:')
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
            self.current_window = self.NETWORK_SUMMARY_INDEX
            llnms_state = self.sub_windows[self.NETWORK_SUMMARY_INDEX].Process( llnms_state )

        #  Check if the user wants to view the asset page
        elif input_key == ord('2'):

            print_response_message( self.screen, 'Loading Asset Configuration Page')

            # Open asset page
            self.current_window = self.ASSET_CONFIGURATION_INDEX
            llnms_state = self.sub_windows[self.ASSET_CONFIGURATION_INDEX].Process(llnms_state)

        #  Check if the user wants to view the scanner summary page
        elif input_key == ord('3'):

            #  Print message
            print_response_message( self.screen, 'Loading Scanner Summary Page')

            #  Open page
            self.current_window = self.SCANNER_SUMMARY_INDEX
            llnms_state = self.sub_windows[self.SCANNER_SUMMARY_INDEX].Process( llnms_state )

        # check if user wants to view the network configuration page
        elif input_key == ord('4'):

            #  Print a basic message telling the user you got their response
            print_response_message( self.screen, 'Loading Network Status Page')

            #  open network summary page
            self.current_window = self.NETWORK_CONFIGURATION_INDEX
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
            llnms_state = self.event_manager.Process_Input(c, llnms_state )


        return llnms_state
