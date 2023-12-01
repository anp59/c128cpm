#!/bin/sh

# Create build environment
rm -rf buildenv
mkdir buildenv
cd buildenv

# copy RunCPM to buildenv
cp ../runcpm/RunCPM .
# not needed, use default CCP
#cp ../runcpm/CCP/CCP-*.* .

# create Disk A user 0
mkdir -p A/0
cd A/0

# Copy tools from A.ZIP
unzip ../../../runcpm/DISK/A.ZIP
cp -v ../../../cpm/* .

# Upper case file names
if [ "$1" == "u" ] || [ "$1" == "U" ]
then
	echo -n "uppercase files:" 
	for i in *; 
	do 
		mv -f "$i" "$(echo $i|tr a-z A-Z)" >/dev/null 2>&1;	# merge stderr to stdout 
		echo -n "."
	done
	echo	# add CRLF
fi
# change dir to buildenv
cd ../..

../runCPM/RunCPM.exe
# submit cz
# exit

cd A/0
dd bs=1 if=KEYCODE.BIN of=CPM+.SYS skip=0 seek=256 count=1024 conv=notrunc
#rm *.ASM

cd ../../..

# Build disk image
DISTRIBUTION=releases/cpmfast

rm cpm+128.d71
ctools/cformat -2 cpm+128.d71
ctools/ctools cpm+128.d71 p buildenv/A/0/CPM+.SYS
for i in $DISTRIBUTION/*.*; do ctools/ctools cpm+128.d71 p $i; done
ctools/ctools cpm+128.d71 d

C:/PApps/GTK3VICE-3.7-win64/bin/x128.exe -80col -8 cpm+128.d71