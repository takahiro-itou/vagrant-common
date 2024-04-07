#! /bin/bash  -xue

test  -f "/root/.provision/setup-time"  &&  exit 0

echo  Provisioning $HOSTNAME

sudo  timedatectl  set-timezone Asia/Tokyo
sudo  timedatectl  set-ntp  true
sudo  systemctl restart systemd-timesyncd.service
sleep 4
systemctl status  systemd-timesyncd.service
sleep 4

mkdir -p "/root/.provision"
date  >  "/root/.provision/setup-time"
