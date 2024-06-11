#!/bin/sh
#I did these by commandline... so I'll paste them here. 
#using ubuntu 14.04 LTS on Virtualbox...

# i had to grab an old grub from here: ftp://alpha.gnu.org/gnu/grub/  and unzip it.
# i had to modify my mtools.conf file

#make sure your drive letter is not already in use here
cat /etc/mtools.conf

#Declare where to find your partition.. make sure you are inside your /home/user/kernel directory:
echo "drive j: file=\"`pwd`/core.img\" partition=1" > ~/.mtoolsrc

#create your partition:
dd if=/dev/zero of=core.img count=088704 bs=512
mpartition -I j:
mpartition -c -t 88 -h 16 -s 63 j:
mformat j:
mmd j:/boot
mmd j:/boot/grub

#move your files over to your new partition:
#Note the location of grub's stages from our extracted tarball
mcopy grub-0.97-i386-pc/boot/grub/stage1 j:/boot/grub
mcopy grub-0.97-i386-pc/boot/grub/stage2 j:/boot/grub
mcopy grub-0.97-i386-pc/boot/grub/fat_stage1_5 j:/boot/grub

#create a bmap to specify your device map:
echo "(hd0) core.img" > bmap
printf "geometry (hd0) 88 16 63 \n root (hd0,0) \n setup (hd0)\n" | /usr/sbin/grub --device-map=bmap  --batch

#Create a menu.lst file (the configuration file that GRUB relies on to load). You can use nano, as previously mentioned.
#added some echos to throw into a file incase someone tries to run th is script point blank.

echo "serial --unit=0 --stop=1 --speed=115200 --parity=no --word=8" >> menu.lst
echo ":terminal --timeout=0 serial console" >> menu.lst
echo "root= (hd0,0)" >> menu.lst
echo "#default 0" >> menu.lst
echo "timeout = 0" >> menu.lst
echo "title= mykernel" >> menu.lst
echo "kernel= /boot/grub/kernel.bin" >> menu.lst
###       module=/boot/grub/additional_modules #this was commented out for testing

#Copy the lst file and your binary kernel over to your new partition.
mcopy  menu.lst  j:/boot/grub/
mcopy  kernel.bin j:/boot/grub/

#then use qemu to boot: (note the second guide I'm following uses an older version of qemu... for the newer version like is on Ubuntu 14.04 LTS, please use the following)
qemu-system-i386 -hda core.img
