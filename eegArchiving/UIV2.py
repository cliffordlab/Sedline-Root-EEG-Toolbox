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
        master.title("Auto-Archiver")

        self.label = Label(master, text="Options")
        self.label.grid(row=0,columnspan=2)

        self.Backup_button = Button(master, text="Backup", command=self.Backup)
        #self.Backup_button.pack(side="top",fill='both')
        self.Backup_button.grid(row=1,column=0,ipadx=80,ipady=45)

        self.Visualize_button = Button(master, text="Visualize", command=self.Visualize)
        #self.Visualize_button.pack(side="top",	fill='both',expand=True,padx=4,pady=2)
        self.Visualize_button.grid(row=1,column=1,ipadx=80,ipady=45)

        self.Record_button = Button(master, text="Audio Record", command=self.Record)
        #self.Record_button.pack(side="top",fill='both',expand=True,padx=4,pady=4)
        self.Record_button.grid(row=2,column=0,ipadx=60,ipady=45)

        self.close_button = Button(master, text="Close", command=master.quit)
        #self.close_button.pack(side="top",fill='both',expand=True,padx=4,pady=4)
        self.close_button.grid(row=2,column=1,ipadx=90,ipady=45)

    def Backup(self):
        self.master.update_idletasks()
        self.master.wm_state('iconic')
        subprocess.Popen(['/home/pi/SedLine-Monitor/notes_gen.py'])
        subprocess.Popen(['xterm','-e','/home/pi/SedLine-Monitor/backupV4_edf.sh; bash'])
        subprocess.Popen(['xterm','-e','/home/pi/SedLine-Monitor/backupV4_adc.sh; bash'])

    def Visualize(self):
        subprocess.Popen(['/home/pi/Code/jcsnyder/hypnox/main.py'])
    
    def Record(self):
        subprocess.Popen(['/home/pi/SedLine-Monitor/record.sh'])



root = Tk()
#root.overrideredirect(True)
root.geometry("{0}x{1}+0+0".format(root.winfo_screenwidth(), root.winfo_screenheight()))
my_gui = MyFirstGUI(root)
root.mainloop()

