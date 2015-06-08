__author__ = 'marvinsmith'

# ----------------------------------- #
# -       Main Window Handler       - #
# ----------------------------------- #
class Main_Window_Handler(object):

    #  Window to manage
    window = None

    # ----------------------------------- #
    # -           Constructor            -#
    # ----------------------------------- #
    def __init__(self, window):

        #  Set the window
        self.window = window

    # ----------------------------------- #
    # -     Process Keyboard Input      - #
    # ----------------------------------- #
    def Process_Input(self, input_key, args):

        #  Make sure its actual input
        if input_key >= ord('a') and input_key <= ord('z'):
            return self.window.Process_Keyboard_Input( input_key, args)
        if input_key >= ord('A') and input_key <= ord('Z'):
            return self.window.Process_Keyboard_Input( input_key, args)
        if input_key >= ord('0') and input_key <= ord('9'):
            return self.window.Process_Keyboard_Input( input_key, args)

        return None