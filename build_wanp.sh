
# Create build environment
rm -rf buildenv
mkdir buildenv
cd buildenv

# RunCPMC:C:\Users\ANP\Documents\CPM+Dev\RunCPM_Win\RunCPM
cp ../../RunCPM_Win/RunCPM/RunCPM.exe .
cp ../../RunCPM_Win/CCP/CCP-*.* .

# Disk A user 0
mkdir -p A/0
cd A/0

# Copy tools from A.ZIP
unzip ../../../runcpm/DISK/A.ZIP
cp -v ../../../cpm_ap/* .

# Upper case file names
#for i in *; do mv -f "$i" "$(echo $i|tr a-z A-Z)" >/dev/null 2>&1; done

cd ../..
./RunCPM.exe

cd A/0
#if=, of= Name Eingabe- bzw. Ausgabedatei anstatt STDIN/STDOUT
#blocksize 1, conv=notrunc Ausgabedatei wird nicht abgeschnitten, 
#skip=N Blöcke am Anfang der Eingabe überspringen
#seek=N Blöcke am Anfang der Ausgabe überspringen
dd bs=1 if=KEYCODE.BIN of=CPM+.SYS skip=0 seek=256 count=1024 

cd ../../..

# Build disk image
DISTRIBUTION=releases/cpmfast

rm cpm+128a.d71
ctools/bin/cformat -2 cpm+128a.d71
ctools/bin/ctools cpm+128a.d71 p buildenv/A/0/CPM+.SYS
for i in $DISTRIBUTION/*.*; do ctools/bin/ctools cpm+128a.d71 p $i; done
ctools/bin/ctools cpm+128a.d71 d
# CMD-Fenster offenhalten
# C:/PApps/WinVICE-3.1-x64/image.png x128.exe -80col -8 cpm+128.d71 -extfunc 1 -extfrom test1.bin
C:/PApps/GTK3VICE-3.6.1-win64/bin/x128.exe -80col -8 cpm+128a.d71

# cartconv.exe -t c128 -l 0x8000 -i cart.bin -o cart.crt