from tkinter import Tk, Label, Button
import subprocess
 
class no_flashdrive_attached:
    def __init__(self, master):
        self.master = master
        master.title("Message")

        self.label = Label(master, text="No flashdrive attached\nPlease press the button on USB hub twice to reconnect flashdrive.")
        self.label.pack()

        self.Okay_button = Button(master, text="Ok", command=self.Okay)
        self.Okay_button.pack()

    def Okay(self):
        root.destroy()


root = Tk()
root.overrideredirect(True)
root.geometry("{0}x{1}+0+0".format(root.winfo_screenwidth(), root.winfo_screenheight()))
my_gui = no_flashdrive_attached(root)
root.mainloop()

