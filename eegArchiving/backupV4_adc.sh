#!/bin/sh
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

set -e
dev="Root"
echo "Root it is"
#mount 
folder="/home/pi/flash_drive"
if [ $(ls /media/pi | wc -l) -eq 1 ]; then 
	echo "Flashdrive attached" 
	echo "You have access" 
	echo "Copying files from flashdrive along with checksum"
	cd /media/pi/*/adc >> ~/log.txt
	for folder in ./*
	do
		if [ -d ${folder} ]; then
			cd ${folder};
			if [ ! -f checksum.txt ] || [ 3 -ne $(grep .edf checksum.txt | wc -l) ]; then	
				if [ -f checksum.txt ]; then rm checksum.txt; fi 			
				for file in ./*
				do
					md5sum ${file} >> checksum.txt
					echo "Checksum created for ${file}"
				done
			fi
		cd ../
		fi
	done
	echo "Rsync local directory with Flashdrive"
	sudo rsync -avzh /media/pi/*/adc/. ~/Desktop/adc/.
	CHECK=$(du -sb /home/pi/Desktop/adc-archive | cut -f1)
	if [ "$CHECK" -gt 21474836480 ]; then rm -r /home/pi/Desktop/adc-archive/*; fi
       	sudo rsync -avzh /media/pi/*/adc/. ~/Desktop/adc-archive/.	
	echo "md5checksum"
	cd ~/Desktop/adc
	for folder in ./*
	do
		if [ -d ${folder} ]; then		
			cd ${folder};
			if [ -d /media/pi/*/adc/${folder} ] && [ $(md5sum -c checksum.txt | grep OK | wc -l) -eq 3 ]; then
				rm -r /media/pi/*/adc/${folder}
				echo "Removed ${folder}"
			else
				echo "For some reason I cannot remove ${folder}"
			fi
			cd ../
		fi
	done
	echo "Upload all adc files to drive..."
	sudo mount /home/pi/Box || true

	folder1="$(sudo cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2)";
	sudo mkdir /home/pi/Box/Sedline\ Data/Emory/EUOSH/${folder1} || true
	#OUTPUT="$(find /home/pi/Box/Sedline\ Data/Emory/EUOSH/${folder1} -type d -exec echo Foundfile {} \; | wc -l )"
	#if [ ${OUTPUT} -ne 1 ]; then
	#	ls /home/pi/Box/Sedline\ Data/Emory/EUOSH/${folder1} | sort -n | tail -1 > a
	#	oldnum=`cut -d 'd' -f2 a`
	#	rm a
	#	newnum=`expr $oldnum + 1`
	#	num=`printf '%04i\n' ${newnum}`
	#	upfolder="Upload"${num}
	#else
	#	upfolder="Upload0001"
	#fi
	num="$(more /home/pi/Desktop/adc/No* | grep "Date*" | cut -d ' ' -f3)"
	upfolder="Upload_"${num}
	sudo mkdir /home/pi/Box/Sedline\ Data/Emory/EUOSH/${folder1}/${upfolder} || true
	sudo mkdir /home/pi/Box/Sedline\ Data/Emory/EUOSH/${folder1}/${upfolder}/adc
	echo ${folder1}
	echo ${upfolder}
	sudo rsync -s -avzh --size-only --inplace ~/Desktop/adc/. /home/pi/Box/Sedline\ Data/Emory/EUOSH/${folder1}/${upfolder}/adc
	sudo umount /home/pi/Box
	rm -r ~/Desktop/adc/* || true
	read -p "press ENTER to exit"
else
	echo "Flashdrive detached" 
	echo "ACCESS DENIED" 
	sudo python3 /home/pi/SedLine-Monitor/no_flashdrive_attached.py
fi;