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
set -e
dev="Root"
echo "Root it is"
#mount 
folder="/home/pi/flash_drive"
if [ $(ls /media/pi | wc -l) -eq 1 ]; then 
	echo "Flashdrive attached" 
	echo "You have access" 
	echo "Copying files from flashdrive along with checksum"
	cd /media/pi/*/edf >> ~/log.txt
	for folder in ./*
	do
		cd ${folder};
		if [ ! -f checksum.txt ] || [ $(ls *.edf | wc -l) -ne $(grep .edf checksum.txt | wc -l) ]; then	
			if [ -f checksum.txt ]; then rm checksum.txt; fi 			
			for file in ./*.edf
			do
				md5sum ${file} >> checksum.txt
				echo "Checksum created for ${file}"
			done
		fi
	cd ../
	done
	echo "Rsync local directory with Flashdrive"
	sudo rsync -avzh /media/pi/*/edf/. ~/Desktop/edf/.
       	sudo rsync -avzh /media/pi/*/edf/. ~/Desktop/edf-archive/.	
	echo "md5checksum"
	cd ~/Desktop/edf
	for folder in ./*
	do
		cd ${folder};
		if [ -d /media/pi/*/edf/${folder} ] && [ $(md5sum -c checksum.txt | grep OK | wc -l) -eq $(ls *.edf | wc -l) ]; then
			rm -r /media/pi/*/edf/${folder}
			echo "Removed ${folder}"
		else
			echo "For some reason I cannot remove ${folder}"
		fi
		cd ../
	done
	echo "Upload all edf files to drive..."
	sudo mount -a
	sudo rsync -s -avzh --size-only --inplace ~/Desktop/edf/. /home/pi/Box/Sedline\ Data/Pitest/.
	rm -r ~/Desktop/edf/*
	read -p "press ENTER to exit"
else
	echo "Flashdrive detached" 
	echo "ACCESS DENIED" 
	sudo python3 /home/pi/SedLine-Monitor/no_flashdrive_attached.py
fi;

