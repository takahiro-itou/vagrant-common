#!/bin/bash  -xue

test  -f "/root/.provision/ramdisk"  &&  exit 0

# RamDisk
sudo  mkdir  -p    /ramdisk
sudo  chmod  1777  /ramdisk

echo  -e  "tmpfs\t/ramdisk\ttmpfs\trw,size=2048m,x-gvfs-show\t0\t0"  \
      |  sudo  tee -a  /etc/fstab

sudo  mount  -a
sudo  chmod  1777  /ramdisk

mkdir -p "/root/.provision"
date  >  "/root/.provision/ramdisk"
