#!/bin/bash  -xue

test  -f "/root/.provision/newhdd"  &&  exit 0

# New HDD (/dev/sdc)
cat <<  __EOF__  |  tee  /dev/shm/zero.md5
53e979547d8c2ea86560ac45de08ae25 *-
__EOF__

cat <<  __EOF__  |  tee  /dev/shm/check_mbr.md5
0a4dbaf15747a2f282529ebec196a2d4 *-
__EOF__

# MBR/GPT ヘッダ 3 セクタ 768 バイトが全部ゼロなら未初期化と判定
sudo  dd if=/dev/sdc bs=512 count=3 | md5sum -b
if sudo dd if=/dev/sdc bs=512 count=3 | md5sum -c /dev/shm/zero.md5 ; then
    sudo  parted --script --align optimal /dev/sdc -- mklabel gpt
    sudo  parted --script --align optimal /dev/sdc -- mkpart primary ext3 1 -1
    sudo  mkfs.ext3     /dev/sdc1
else
    echo "Disk Already Formatted."  1>&2
    sleep 5
fi

# GPT ヘッダは毎回変わるようなので、MBR ヘッダだけ確認する
sudo  dd if=/dev/sdc bs=512 count=1 | md5sum -b
sudo  dd if=/dev/sdc bs=512 count=1 | md5sum -c /dev/shm/check_mbr.md5

sudo  mkdir  -p    /ext-hdd/data
sudo  chmod  1777  /ext-hdd/data

echo  -e  "/dev/sdc1\t/ext-hdd/data\text3\tdefaults\t0\t0"  \
    |  sudo  tee -a  /etc/fstab

sudo  mount  -a
sudo  chmod  1777  /ext-hdd/data

ls -al /ext-hdd/
sleep 5

mkdir -p "/root/.provision"
date  >  "/root/.provision/newhdd"
