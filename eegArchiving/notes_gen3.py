#!/usr/bin/env python3
from tkinter import Tk, Label, Button, StringVar, Entry, messagebox, Frame
from datetime import datetime
import subprocess
import glob
import os
import shutil

class first:
    def __init__(self, master):
        self.master = master
        master.title("Enter Notes")
        self.label = Label(master, text="Please Enter OR Number and other Info and click Enter")
        self.label.grid(row = 0, columnspan = 2)

        def callback(sv):
            c = sv.get()
            sv.set(c)

        # We have the GUI definitions here for NoteGen
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
        # Once the message is typed and and User clicks Yes the ball starts rolling
        if messagebox.askyesno("Confirm Message", "Click Yes to Close the GUI"):
            info = self.sv1.get() # The information to be written to Notes file is captured from the GUI
            cpuserial = "0000000000000000"
            try:
                file = open('/proc/cpuinfo','r')
                for line in file:
                    if line [0:6]=='Serial':
                        cpuserial = line[10:26]
                file.close()
            except:
                cpuserial = "ERROR00000000000"

            # Any old Notes files in edf folder are removed and the new message is written into a new Notes file
            for f in glob.glob("/home/pi/Desktop/edf/Notes*"):
                os.remove(f)
            with open('/home/pi/Desktop/edf/Notes_'+self.now+'.txt','w') as f:
                f.write('Date-Time: (GMT) '+self.now+'\nINFO:\n'+info+'\ncpuserial = '+cpuserial)           

            # We copy the notes file to all the directories with edf files
            # dest_folders = os.listdir("/home/pi/Desktop/edf/")
            # f = '/home/pi/Desktop/edf/Notes_'+self.now
            # for folder in dest_folders:
            #    shutil.copy(f, folder)
            # Then we remove the notes file in edf folder
            # os.remove(f)
            # The back-up for edf begins
            subprocess.Popen(['xterm','-e','/home/pi/SedLine-Monitor/backupV6_edf.sh; bash'])

            # Any old notes file in adc folder are removed and the new message is written into a new Notes file
            for f in glob.glob("/home/pi/Desktop/adc/Notes*"):
                os.remove(f)
            with open('/home/pi/Desktop/adc/Notes_'+self.now+'.txt','w') as f:
                f.write('Date-Time: (GMT) '+self.now+'\nINFO:\n'+info+'\ncpuserial = '+cpuserial)

            # We copy the notes file to all the directories with adc files
            # dest_folders = os.listdir("/home/pi/Desktop/adc/")
            # f = '/home/pi/Desktop/adc/Notes_'+self.now
            # for folder in dest_folders:
            #     shutil.copy(f, folder)
            # Then we remove the notes file in adc folder
            # os.remove(f)
            # The back-up for adc file begins    
            subprocess.Popen(['xterm','-e','/home/pi/SedLine-Monitor/backupV6_adc.sh; bash'])
            self.master.quit()

    def Buttonclickwrapper(self,event):
        self.Close()

root = Tk()
#root.overrideredirect(True)
root.geometry("{0}x{1}+0+0".format(root.winfo_screenwidth(), root.winfo_screenheight()))
my_gui = first(root)
root.mainloop()

