#!/bin/bash
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
dev="Root"
var1=$(lsusb | awk -F"SanDisk" '{print $2}')
echo $var1
if ["$dev" = "Legacy"]; then
	echo "Legacy it is" >> ~/log.txt
	if [ $var1 == "Corp." ]; then
		echo "Flashdrive attached" >> ~/log.txt
		echo "You have access"  >> ~/log.txt
		echo "Stopping recording..." >> ~/log.txt
		kill $(ps aux| grep [a]record | awk '{print $2}') >> ~/log.txt
		echo "MP3 file generating..." >> ~/log.txt
		lame -V2 ~/rec.wav ~/rec.mp3 >> ~/log.txt
		echo "Copying file to flashdrive..." >> ~/log.txt
		cp ~/rec.mp3 /media/pi/PRADYUMNA/. >> ~/log.txt
		echo "cd to Flashdrive..." >> ~/log.txt
		cd /media/pi/PRADYUMNA/. >> ~/log.txt	
		echo "Upload all phy files to drive..." >> ~/log.txt
		gdrive push -no-prompt=true -hidden=true /media/pi/PRADYUMNA/*.phy >> ~/log.txt
		echo "Upload all wav files to drive..." >> ~/log.txt
		gdrive push -no-prompt=true -hidden=true /media/pi/PRADYUMNA/rec.mp3 >> ~/log.txt	
	else
		echo "Flashdrive detached" >> ~/log.txt
		echo "ACCESS DENIED" >> ~/log.txt
	fi;
else
	echo "Root it is" >> ~/log.txt
	if [ $var1 == "Corp." ]; then
		echo "Flashdrive attached" >> ~/log.txt
		echo "You have access"  >> ~/log.txt
		# echo "Stopping recording..." >> ~/log.txt
		kill $(ps aux| grep [a]record | awk '{print $2}') >> ~/log.txt
		# echo "MP3 file generating..." >> ~/log.txt
		lame -V2 ~/rec.wav ~/rec.mp3 >> ~/log.txt
		echo "Copying file to flashdrive..." >> ~/log.txt
		# cp ~/rec.mp3 /media/pi/PRADYUMNA/. >> ~/log.txt
		# echo "cd to Flashdrive..." >> ~/log.txt
		cd /media/pi/PRADYUMNA/. >> ~/log.txt	
		echo "Upload all phy files to drive..." >> ~/log.txt
		gdrive push -no-prompt=true -hidden=true /media/pi/PRADYUMNA/edf >> ~/log.txt
		# echo "Upload all wav files to drive..." >> ~/log.txt
		# gdrive push -no-prompt=true -hidden=true /media/pi/PRADYUMNA/rec.mp3 >> ~/log.txt	
	else
		echo "Flashdrive detached" >> ~/log.txt
		echo "ACCESS DENIED" >> ~/log.txt
	fi;
fi;
