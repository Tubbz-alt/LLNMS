#!/usr/bin/env python

#  System Libraries
import curses, os, sys

#  LLNMS Libraries
if os.environ['LLNMS_HOME'] is not None:
    sys.path.append(os.environ['LLNMS_HOME'] + '/lib')
import llnms


# ------------------------------ #
# -     Initialize Curses      - #
# ------------------------------ #
def Initialize_Curses():

    #  Use for Cursor Overlays
    curses.init_pair( 1, curses.COLOR_BLACK, curses.COLOR_WHITE)
    
    #  Use for Error Windows
    curses.init_pair( 2, curses.COLOR_BLACK, curses.COLOR_RED)

    #  Use for Error Text
    curses.init_pair( 3, curses.COLOR_RED, curses.COLOR_BLACK)

    #  Use for Simple Backgrounds
    curses.init_pair( 4, curses.COLOR_WHITE, curses.COLOR_BLUE )
    curses.init_pair( 5, curses.COLOR_BLUE, curses.COLOR_WHITE )


# ------------------------- #
# -      Main Function    - #
# ------------------------- #
def main(stdscr):

    #  Initialize Curses
    Initialize_Curses()


    #  grab the current context
    LLNMS_HOME=os.environ['LLNMS_HOME']
    llnms_state = llnms.viewer.LLNMS_State(llnms_home=LLNMS_HOME)


    #  Create the Main Window
    main_window = llnms.viewer.ui.MainWindow(stdscr)


    #  Process the input
    llnms_state = main_window.Process(llnms_state)


# --------------------------------------------------------------- #
# -   If the script is called from the cmdline, execute this    - #
# --------------------------------------------------------------- #
if __name__ == "__main__":

    #  Call the curses wrapper
    curses.wrapper(main)

