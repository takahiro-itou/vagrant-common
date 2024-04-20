#!/bin/bash  -xue

test  -f "/root/.provision/newhdd-ide"  &&  exit 0

# New HDD (/dev/sdc)
workdir=$(mktemp -d "/dev/shm/disk.XXXXXXXXXX")
mkdir -p "${workdir}"

cat <<  __EOF__  |  tee  "${workdir}/zero.md5"
53e979547d8c2ea86560ac45de08ae25 *-
__EOF__

cat <<  __EOF__  |  tee  "${workdir}/check_mbr.md5"
94e80e057734dbc291bdd784ea2fe010 *-
__EOF__

trg_hdd='/dev/sdb'

# MBR/GPT ヘッダ 3 セクタ 768 バイトが全部ゼロなら未初期化と判定
sudo  dd if=${trg_hdd} of="${workdir}/gpt.chk" bs=512 count=3
md5sum -b "${workdir}/gpt.chk"
if cat "${workdir}/gpt.chk" | md5sum -c "${workdir}/zero.md5" ; then
    sudo  parted --script --align optimal ${trg_hdd} -- mklabel gpt
    sudo  parted --script --align optimal ${trg_hdd} -- mkpart primary ext3 1 -1
    sudo  mkfs.ext3     "${trg_hdd}1"
else
    echo "Disk Already Formatted."  1>&2
    sleep 5
fi

# GPT ヘッダは毎回変わるようなので、MBR ヘッダだけ確認する
sudo  dd if=${trg_hdd} of="${workdir}/mbr.chk" bs=512 count=1
md5sum -b "${workdir}/mbr.chk"
if cat "${workdir}/mbr.chk" | md5sum -c "${workdir}/check_mbr.md5" ; then
    echo "MBR Header OK."   1>&2
    sleep 5
else
    od -t x1 "${workdir}/mbr.chk"
    echo "WARNING : Check MBR Header FAILED."   1>&2
    sleep 5
fi

sudo  mkdir  -p    /ext-hdd/data
sudo  chmod  1777  /ext-hdd/data

echo  -e  "${trg_hdd}1\t/ext-hdd/data\text3\tdefaults\t0\t0"  \
    |  sudo  tee -a  /etc/fstab

sudo  mount  -a
sudo  chmod  1777  /ext-hdd/data

ls -al /ext-hdd/
sleep 5

mkdir -p "/root/.provision"
date  >  "/root/.provision/newhdd-ide"
