__author__ = 'marvinsmith'


# -------------------------------- #
# -      Event Manager Class     - #
# -------------------------------- #
class EventManager:

    #  List of event handlers
    input_handlers = []

    # -------------------------- #
    # -      Constructor       - #
    # -------------------------- #
    def __init__(self):
        pass

    # ----------------------------------- #
    # -     Process Keyboard Input      - #
    # ----------------------------------- #
    def Process_Input(self, input_key, args ):

        #  Iterate over handlers
        for handler in self.input_handlers:

            #  Pass the input to the handler
            return handler.Process_Input(input_key, args)

    # -------------------------------- #
    # -      Register a Handler      - #
    # -------------------------------- #
    def Register_Handler(self, handler ):
        self.input_handlers.append(handler)