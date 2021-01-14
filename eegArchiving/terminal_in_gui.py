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
from Tkinter import *
import os

root = Tk()
termf = Frame(root, height=400, width=500)

termf.pack(fill=BOTH, expand=YES)
wid = termf.winfo_id()
os.system('xterm -into %d -geometry 40x20 -sb &' % wid)

root.mainloop()