#!/bin/bash
# Auto install for 8192cu
# September, 1 2010 v1.0.0, willisTang
# 
# Add make_drv to select chip type
# Novembor, 21 2011 v1.1.0, Jeff Hung
# 
# Use elivated privileges only for install
# Remove su and use sudo
# Remove the tar file
# Rename the drive folder variable
# September, 22 2020 v1.1.1, Vishnu Sreekumar
################################################################################

echo "##################################################"
echo "Realtek Wi-Fi driver Auto installation script"
echo "September, 22 2020 v1.1.1"
echo "##################################################"

################################################################################
#			Choose the driver folder
################################################################################
cd driver
Drvfolder=`ls |grep -iv '.tar.gz'`
echo "$Drvfolder"
cd  $Drvfolder

################################################################################
#			If makd_drv exixt, execute it to select chip type
################################################################################
if [ -e ./make_drv ]; then
	./make_drv
fi

################################################################################
#                       make clean
################################################################################
echo "Cleanup previous build files if exists"
make clean; Error=$?

################################################################################
#			Compile the driver
################################################################################
echo "Compile"
make; Error=$?
################################################################################
#			Check whether or not the driver compilation is done
################################################################################
module=`ls |grep -i 'ko'`
echo "##################################################"
if [ "$Error" != 0 ];then
	echo "Compile make driver error: $Error"
	echo "Please check error Mesg"
	echo "##################################################"
	exit
else
	echo "Compile make driver ok!!"	
	echo "##################################################"
fi

echo "Authentication requested [root] for install driver:"
sudo make install
echo "Authentication requested [root] for remove driver:"
sudo modprobe -r ${module%.*}
echo "Authentication requested [root] for insert driver:"
sudo modprobe ${module%.*}
echo "##################################################"
echo "The Setup Script is completed !"
echo "##################################################"
