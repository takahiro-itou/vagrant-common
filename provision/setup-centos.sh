#! /bin/bash  -xue

test  -f "/root/.provision/setup-centos"  &&  exit 0

sudo  timedatectl  set-timezone Asia/Tokyo

sudo  yum  install -y  \
    screen

sudo  mkdir  -p    /tools
sudo  chmod  1777  /tools

mkdir -p "/root/.provision"
date  >  "/root/.provision/setup-centos"
