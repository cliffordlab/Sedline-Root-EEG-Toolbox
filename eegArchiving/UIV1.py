#!/usr/bin/env python3
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

