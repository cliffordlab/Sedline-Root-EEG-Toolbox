#!/bin/bash
#
#	REPO:       
#       https://github.com/cliffordlab/Sedline-Root-EEG-Toolbox
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
cat </dev/tcp/time.nist.gov/13 >> ~/rectime.txt
lxterminal -e arecord -D plughw:1 -f S16_LE -vv ~/rec-23Aug-10am.wav
cat </dev/tcp/time.nist.gov/13 >>~/rectime.txt
