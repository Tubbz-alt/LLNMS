#!/usr/bin/env python

#  System Libraries
import curses

#  LLNMS Libraries
import llnms

# ------------------------------ #
# -     Initialize Curses      - #
# ------------------------------ #
def Initialize_Curses():

    curses.init_pair( 1, curses.COLOR_BLACK, curses.COLOR_WHITE)

# ------------------------- #
# -      Main Function    - #
# ------------------------- #
def main(stdscr):

    #  Initialize Curses
    Initialize_Curses()

    #  grab the current context
    llnms_state = llnms.LLNMS()

    #  Create the Main Window
    main_window = llnms.ui.MainWindow(stdscr)

    #  Process the input
    llnms_state = main_window.Process(llnms_state)


# --------------------------------------------------------------- #
# -   If the script is called from the cmdline, execute this    - #
# --------------------------------------------------------------- #
if __name__ == "__main__":

    #  Call the curses wrapper
    curses.wrapper(main)
