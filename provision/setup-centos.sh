#! /bin/bash  -xue

test  -f "/root/.provision/setup-centos"  &&  exit 0

sudo  timedatectl  set-timezone Asia/Tokyo

mkdir -p "/root/.provision"
date  >  "/root/.provision/setup-centos"
