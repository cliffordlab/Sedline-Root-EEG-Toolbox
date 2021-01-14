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
from tkinter import Tk, Label, Button
import subprocess
 
class MyFirstGUI:
    def __init__(self, master):
        self.master = master
        master.title("A simple GUI")

        self.label = Label(master, text="This is our first GUI!")
        self.label.pack()

        self.Backup_button = Button(master, text="Backup", command=self.Backup)
        self.Backup_button.pack()

        self.Visualize_button = Button(master, text="Visualize", command=self.Visualize)
        self.Visualize_button.pack()

        self.Record_button = Button(master, text="Audio Record", command=self.Record)
        self.Record_button.pack()

        self.close_button = Button(master, text="Close", command=master.quit)
        self.close_button.pack()

    def Backup(self):
        subprocess.Popen(['/home/pi/SedLine-Scripts/backupV2.sh'])

    def Visualize(self):
        subprocess.Popen(['/home/pi/Code/jcsnyder/hypnox/main.py'])
    
    def Record(self):
        subprocess.Popen(['/home/pi/SedLine-Scripts/record.sh'])


root = Tk()
my_gui = MyFirstGUI(root)
root.mainloop()

