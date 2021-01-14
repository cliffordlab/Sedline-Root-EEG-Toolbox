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
from tkinter import Tk, Label, Button, StringVar, Entry, messagebox, Frame
from datetime import datetime
import subprocess
import glob
import os

class first:
    def __init__(self, master):
        self.master = master
        master.title("Enter Notes")
        self.label = Label(master, text="Please Enter OR Number and other Info and click Enter")
        self.label.grid(row = 0, columnspan = 2)

        def callback(sv):
            c = sv.get()
            sv.set(c)


        self.sv1 = StringVar()
        self.sv1.trace("w", lambda name, index, mode, sv1=self.sv1: callback(self.sv1))
        self.sv1.set("")
        self.entry = Entry(master,  width=58, textvariable=self.sv1)
        self.entry.grid(row = 1, columnspan = 8)
        self.entry.focus_force()

        self.now = str(datetime.utcnow())[0:-16]+"_"+str(datetime.utcnow())[-15:-7]
        
        self.Okay_button = Button(master, text="Enter", command=self.Close)
        self.Okay_button.grid(row = 4, columnspan = 2, ipadx = 210, ipady = 80)
        self.Okay_button.bind("<Return>", self.Buttonclickwrapper)
        
    def Close(self):
        if messagebox.askyesno("Confirm Message", "Click Yes to Close the GUI"):
            info = self.sv1.get()
            for f in glob.glob("/home/pi/Desktop/edf/Notes*"):
                os.remove(f)
            with open('/home/pi/Desktop/edf/Notes_'+self.now,'w') as f:
                f.write('Date-Time: (GMT) '+self.now+'\nINFO:\n'+info)           
            
            subprocess.Popen(['xterm','-e','/home/pi/SedLine-Monitor/backupV5_edf.sh; bash'])

            for f in glob.glob("/home/pi/Desktop/adc/Notes*"):
                os.remove(f)
            with open('/home/pi/Desktop/adc/Notes_'+self.now,'w') as f:
                f.write('Date-Time: (GMT) '+self.now+'\nINFO:\n'+info)
                
            subprocess.Popen(['xterm','-e','/home/pi/SedLine-Monitor/backupV5_adc.sh; bash'])
            self.master.quit()

    def Buttonclickwrapper(self,event):
        self.Close()

root = Tk()
#root.overrideredirect(True)
root.geometry("{0}x{1}+0+0".format(root.winfo_screenwidth(), root.winfo_screenheight()))
my_gui = first(root)
root.mainloop()

