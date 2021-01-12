#!/bin/sh
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
		if [ -d ${folder} ]; then
			cd ${folder};
			if [ ! -f checksum.txt ] || [ $(ls *.edf | wc -l) -ne $(grep .edf checksum.txt | wc -l) ]; then	
				if [ -f checksum.txt ]; then sudo mount -n -o remount,rw /home/pi/*/ ; rm checksum.txt; fi 			
				for file in ./*.edf
				do
					sudo mount -n -o remount,rw /home/pi/*/
					md5sum ${file} >> checksum.txt
					echo "Checksum created for ${file}"
				done
			fi
		cd ../
		fi
	done
	echo "Rsync local directory with Flashdrive"
	sudo rsync -avzh /media/pi/*/edf/. ~/Desktop/edf/.
	CHECK=$(du -sb /home/pi/Desktop/edf-archive | cut -f1)
	if [ "$CHECK" -gt 10737418240 ]; then rm -r /home/pi/Desktop/edf-archive/*; fi
       	sudo rsync -avzh /media/pi/*/edf/. ~/Desktop/edf-archive/.	
	echo "md5checksum"
	cd ~/Desktop/edf
	for folder in ./*
	do
		if [ -d ${folder} ]; then		
			cd ${folder};
			if [ -d /media/pi/*/edf/${folder} ] && [ $(md5sum -c checksum.txt | grep OK | wc -l) -eq $(ls *.edf | wc -l) ]; then
				rm -r /media/pi/*/edf/${folder}
				echo "Removed ${folder}"
			else
				echo "For some reason I cannot remove ${folder}"
			fi
			cd ../
		fi
	done
	echo "Upload all edf files to drive..."
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
        sudo mkdir /home/pi/Box/Sedline\ Data/Emory/EUOSH/${folder1}/${upfolder}/edf

	sudo rsync -s -avzh --size-only --inplace ~/Desktop/edf/. /home/pi/Box/Sedline\ Data/Emory/EUOSH/${folder1}/${upfolder}/edf
	while [ $? -ne 0 ]; do echo "Trying Again"; sudo rsync -s -avzh --size-only --inplace ~/Desktop/edf/. /home/pi/Box/Sedline\ Data/Emory/EUOSH/${folder1}/${upfolder}/edf ; done
	sudo umount /home/pi/Box || true
	rm -r ~/Desktop/edf/*
	read -p "press ENTER to exit"
else
	echo "Flashdrive detached" 
	echo "ACCESS DENIED" 
	sudo python3 /home/pi/SedLine-Monitor/no_flashdrive_attached.py
fi;
