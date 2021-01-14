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
#var1=$(lsusb | awk -F"SanDisk" '{print $2}')
#echo $var1
echo "Root it is" >> ~/log.txt
#if [ $var1 == "Corp." ]; then
if [ $(ls /media/pi | wc -l) -eq 1 ]; then 
	echo "Flashdrive attached" >> ~/log.txt
	echo "You have access"  >> ~/log.txt
	echo "Copying file to flashdrive..." >> ~/log.txt
	cd /media/pi/*/edf >> ~/log.txt
	for folder in ./*
	do
		cd ${folder};
		if [ ! -f checksum.txt ] || [ $(ls *.edf | wc -l) -ne $(grep .edf checksum.txt | wc -l) ]; then	
			if [ -f checksum.txt ]; then rm checksum.txt; fi 			
			for file in ./*.edf
			do
				md5sum ${file} >> checksum.txt
			done
		fi
	cd ../
	done
	echo "Rsync local directory with Flashdrive"
	rsync -avzh  /media/pi/*/edf/.  ~/Desktop/edf/. >> ~/log.txt
	echo "md5checksum"
	cd ~/Desktop/edf
	for folder in ./*
	do
		cd ${folder};
		if [ -f /media/pi/*/edf/${folder} ] && [ $(md5sum -c checksum.txt | grep OK | wc -l) -eq $(ls *.edf | wc -l) ]; then
			rm -r /media/pi/*/edf/${folder}
		fi
	cd ../
	done
	echo "Upload all edf files to drive..." >> ~/log.txt
	sudo mount -a
	rsync -avzh ~/Desktop/edf/. /home/pi/Box/Sedline\ Data/Pitest/.
else
	echo "Flashdrive detached" >> ~/log.txt
	echo "ACCESS DENIED" >> ~/log.txt
fi;

