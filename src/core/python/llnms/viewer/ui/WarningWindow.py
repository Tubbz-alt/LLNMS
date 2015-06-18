__author__ = 'marvinsmith'

#  LLNMS Libraries
import UI_Window_Base


# ------------------------------ #
# -       Warning Window       - #
# ------------------------------ #
class WarningWindow(UI_Window_Base.Base_Window_Type):


    # ------------------------- #
    # -      Constructor      - #
    # ------------------------- #
    def __init__(self):

        #  Parent
        UI_Window_Base.Base_Window_Type.__init__(self)


    # --------------------- #
    # -      Process      - #
    # --------------------- #
    def Process( self, screen ):

        #  Screen
        screen.clear()

        #  Print window
        screen.addstr(0, 0, "Do you wish to complete the action? (y/n - default): ")

        #  Refresh
        screen.refresh()

        #  Get the input
        c = screen.getch()

        if c == ord('y') or c == ord('Y'):
            return True
        else:
            return False
