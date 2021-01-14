#!/usr/bin/env python3
#
#	REPO:       
#       https://github.com/cliffordlab/Sedline-EEG_Analysis
#
#   ORIGINAL SOURCE AND AUTHORS:     
#       Pradyumna Byappanahalli Suresh
#       Last Modified: January 14th, 2021
#
#	COPYRIGHT (C) 2021
#   LICENSE:    
#       This software may be modified and distributed under the terms
#       of the BSD 3-Clause license. See the LICENSE file in this repo for 
#       details.
#
from tkinter import Tk, Label, Button, StringVar, Entry, messagebox
from datetime import datetime

class first:
    def __init__(self, master):
        self.master = master
        master.title("Enter Notes")
        self.label = Label(master, text="Please Enter OR Number!")
        self.label.grid(row = 0, columnspan = 8)

        def callback(sv):
            c = sv.get()
            sv.set(c)


        self.sv1 = StringVar()
        self.sv1.trace("w", lambda name, index, mode, sv1=self.sv1: callback(self.sv1))
        self.sv1.set("")
        self.entry = Entry(master,  width=100, textvariable=self.sv1)
        self.entry.grid(row = 1, columnspan = 8)

        self.now = str(datetime.utcnow())[0:-7]

        self.Okay_button = Button(master, text="Okay", command=self.Close)
        self.Okay_button.grid(row = 4, columnspan = 2, ipadx = 150, ipady = 40)

    def Close(self):
        if messagebox.askyesno("Confirm Message", "Click Yes to Close the GUI"):
            info = self.sv1.get()
            with open('/home/pi/Desktop/edf/Notes_'+self.now,'w') as f:
                f.write('Date-Time: (GMT) '+self.now+'\nINFO:\n'+info)
            self.master.quit()

root = Tk()
#root.overrideredirect(True)
root.geometry("{0}x{1}+0+0".format(root.winfo_screenwidth(), root.winfo_screenheight()))
my_gui = first(root)
root.mainloop()
